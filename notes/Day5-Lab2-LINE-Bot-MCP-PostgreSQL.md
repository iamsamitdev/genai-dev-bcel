# Day 5 - Lab 2: LINE Bot MCP Server + Webhook เก็บแชทกลุ่มลง PostgreSQL ให้ Claude สรุปข้อมูล

**เป้าหมาย:** เชื่อม LINE Official Account เข้ากลุ่ม LINE, เก็บข้อความในกลุ่มลง PostgreSQL ผ่าน Webhook, แล้วให้ Claude Code อ่านประวัติผ่าน MCP เพื่อสรุปบทสนทนา และส่งข้อความ/สรุปกลับเข้ากลุ่มผ่าน LINE Bot MCP Server

**อ้างอิงหลัก:** https://github.com/line/line-bot-mcp-server (v0.5.0, พ.ค. 2026)

---

## ข้อเท็จจริงสำคัญที่ต้องอธิบายผู้เรียนก่อนเริ่ม (สำคัญมาก)

1. **LINE Messaging API อ่านประวัติแชทย้อนหลังไม่ได้** - Bot จะได้รับข้อความผ่าน Webhook เฉพาะข้อความที่ส่ง "หลังจาก" bot เข้ากลุ่มแล้วเท่านั้น ดังนั้นเราจึงต้องสร้างระบบเก็บข้อความสะสมเอง (นี่คือเหตุผลของ Lab นี้ทั้ง Lab)
2. **line-bot-mcp-server มีเฉพาะเครื่องมือฝั่ง "ส่ง/จัดการ"** ได้แก่ push_text_message, push_flex_message, broadcast_text_message, broadcast_flex_message, get_profile, get_message_quota, เครื่องมือ rich menu และ get_follower_ids - ไม่มีเครื่องมืออ่านแชท
3. ดังนั้นสถาปัตยกรรมของเราคือ: **Webhook (ขาเข้า) + PostgreSQL (หน่วยความจำ) + Postgres MCP (ขาอ่าน) + LINE Bot MCP (ขาส่งกลับ)**
4. line-bot-mcp-server ต้องใช้ **Node.js v22 ขึ้นไป**

### แผนภาพสถาปัตยกรรม

```
สมาชิกในกลุ่ม LINE พิมพ์ข้อความ
        │
        ▼
LINE Platform ──► Webhook Server (Express + @line/bot-sdk)
   (HTTPS ผ่าน ngrok)         │ บันทึกข้อความ
                              ▼
                        PostgreSQL (ตาราง line_messages)
                              │ อ่านผ่าน Postgres MCP
                              ▼
                        Claude Code ── วิเคราะห์/สรุป
                              │ ส่งสรุปกลับผ่าน LINE Bot MCP
                              ▼
                        กลุ่ม LINE (push message ด้วย groupId)
```

---

## Part A: เตรียม LINE Official Account และ Messaging API (20 นาที)

### A1. สร้าง LINE OA และ Channel

1. เข้า LINE Developers Console: https://developers.line.biz/console/
2. สร้าง Provider (ถ้ายังไม่มี) เช่น "IT Genius Training"
3. สร้าง **Messaging API Channel** (ระบบจะสร้าง LINE OA ให้อัตโนมัติ) ตั้งชื่อ เช่น "Chat Recorder Bot"
4. ใน tab **Messaging API** จด/สร้างค่าต่อไปนี้:
   - **Channel access token (long-lived)** - กด Issue แล้วคัดลอกเก็บไว้ (ห้าม commit ลง git)
   - **Bot basic ID** (เช่น @123abcd) ไว้ให้เพื่อนแอดเข้ากลุ่ม

### A2. ตั้งค่าให้ Bot เข้ากลุ่มได้และไม่ตอบอัตโนมัติ

เข้า LINE Official Account Manager (https://manager.line.biz/) เลือก OA ที่เพิ่งสร้าง:

1. Settings → Account settings → **Chats** → เปิด "Allow bot to join group chats" (สำคัญ - ค่าเริ่มต้นปิดอยู่ bot จะเข้ากลุ่มไม่ได้)
2. Settings → Messaging API ตรวจว่าสถานะ Enabled
3. Response settings:
   - Auto-response messages: **ปิด** (Disabled)
   - Webhook: **เปิด** (Enabled)
   - Greeting message: ปิดหรือเปิดตามชอบ

### A3. สร้างกลุ่มทดสอบ

ให้ผู้เรียนจับกลุ่ม 3-4 คน สร้างกลุ่ม LINE ใหม่ชื่อ เช่น "ทดสอบ AI Day5 - กลุ่ม 1" แล้วเชิญ bot เข้ากลุ่ม (Invite → ค้นหาด้วย Bot basic ID) - ยังไม่ต้องพิมพ์อะไร รอ webhook เสร็จก่อน

---

## Part B: สร้างตารางเก็บข้อความใน PostgreSQL (10 นาที)

ใช้ PostgreSQL ตัวเดียวกับ Lab 1 สร้างฐานข้อมูลใหม่:

```cmd
psql -U postgres -c "CREATE DATABASE linechat;"
```

สร้างตาราง (บันทึกเป็นไฟล์ `sql/init.sql` ในโปรเจกต์):

```sql
CREATE TABLE line_messages (
    id              SERIAL PRIMARY KEY,
    line_message_id VARCHAR(64) UNIQUE,      -- กัน insert ซ้ำเมื่อ LINE retry webhook
    group_id        VARCHAR(64),             -- ID ของกลุ่ม (ขึ้นต้นด้วย C)
    user_id         VARCHAR(64),             -- ID ของผู้ส่ง (ขึ้นต้นด้วย U)
    display_name    VARCHAR(255),            -- ชื่อผู้ส่ง ณ เวลาที่ส่ง
    message_type    VARCHAR(20) NOT NULL,    -- text / sticker / image / อื่นๆ
    message_text    TEXT,                    -- เนื้อความ (เฉพาะ type = text)
    sent_at         TIMESTAMPTZ NOT NULL,    -- เวลาส่งจริงจาก LINE (timestamp ms)
    created_at      TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_line_messages_group_time ON line_messages (group_id, sent_at);
CREATE INDEX idx_line_messages_user ON line_messages (user_id);
```

รัน:

```cmd
psql -U postgres -d linechat -f sql\init.sql
```

---

## Part C: สร้าง Webhook Server ด้วย Claude Code (30 นาที)

### C1. เตรียมโปรเจกต์

```cmd
mkdir line-chat-recorder
cd line-chat-recorder
claude
```

### C2. Prompt สร้าง Webhook (copy ใช้ได้ทันที)

```
สร้าง webhook server สำหรับ LINE Messaging API ด้วย Node.js + Express
ใช้ TypeScript ไม่ใส่ semicolon โครงสร้างดังนี้

หน้าที่หลัก:
1. Endpoint POST /webhook รับ event จาก LINE
   - ตรวจ signature ด้วย channel secret ผ่าน middleware ของ @line/bot-sdk
   - สนใจเฉพาะ event type "message" ที่มาจาก group (source.type === "group")
   - ถ้าเป็นข้อความ text: ดึง display name ของผู้ส่งด้วย API
     getGroupMemberProfile แล้วบันทึกลง PostgreSQL ตาราง line_messages
     (ฐานข้อมูล linechat) ตาม schema ในไฟล์ sql/init.sql ที่ผมจะวางให้
   - ถ้าเป็น type อื่น (sticker, image) ให้บันทึกเฉพาะ metadata ไม่มี message_text
   - ใช้ ON CONFLICT (line_message_id) DO NOTHING กันข้อมูลซ้ำ
2. Endpoint GET /health ตอบ { status: "ok", messagesStored: จำนวนแถวในตาราง }
3. เมื่อ bot ถูกเชิญเข้ากลุ่ม (event type "join") ให้ reply ข้อความแนะนำตัว
   "สวัสดีครับ ผมคือบอทบันทึกบทสนทนา เริ่มบันทึกตั้งแต่ตอนนี้เป็นต้นไป"

ข้อกำหนดทางเทคนิค:
- ใช้ library @line/bot-sdk (เวอร์ชันล่าสุด) และ pg
- อ่าน config จากไฟล์ .env: CHANNEL_ACCESS_TOKEN, CHANNEL_SECRET, DATABASE_URL, PORT (default 3000)
- สร้าง .env.example และเพิ่ม .env ลง .gitignore
- มี error handling ที่ดี: webhook ต้องตอบ 200 เสมอแม้ DB จะพัง (log error ไว้)
  เพราะถ้าตอบ error ซ้ำๆ LINE จะหยุดส่ง event มาให้
- log ทุกข้อความที่บันทึกลง console แบบอ่านง่าย
- เขียน comment ภาษาไทยอธิบายจุดสำคัญ

ติดตั้ง dependencies ให้เรียบร้อย และบอกวิธีรัน
```

หลังจากนั้นวางไฟล์ `sql/init.sql` (จาก Part B) ลงโปรเจกต์ และกรอกค่าจริงใน `.env`

หมายเหตุ: Channel secret ดูได้จาก tab **Basic settings** ของ Channel ใน LINE Developers Console

### C3. เปิด Webhook สู่โลกภายนอกด้วย ngrok

LINE ต้องการ webhook URL ที่เป็น HTTPS จึงต้องใช้ tunnel:

1. สมัคร/ติดตั้ง ngrok: https://ngrok.com/download (หรือ `choco install ngrok`)
2. รัน webhook server: `npm run dev` (หรือตามที่ Claude Code บอก)
3. เปิด terminal ใหม่: `ngrok http 3000`
4. คัดลอก URL ที่ได้ เช่น `https://xxxx.ngrok-free.app`
5. ไปที่ LINE Developers Console → tab Messaging API → **Webhook URL** ใส่ `https://xxxx.ngrok-free.app/webhook` → กด **Verify** ต้องขึ้น Success → เปิด "Use webhook"

ทางเลือกแทน ngrok: `cloudflared tunnel --url http://localhost:3000` (ไม่ต้องสมัคร)

### C4. ทดสอบระบบเก็บข้อความ

1. ให้สมาชิกในกลุ่มพิมพ์คุยกันสัก 20-30 ข้อความ (แนะนำ: ให้คุยหัวข้อจริง เช่น วางแผนงานเลี้ยงทีม ถกเรื่องเทคโนโลยี เพื่อให้มีเนื้อหาไว้สรุป)
2. ดู log ใน terminal ของ webhook ต้องเห็นข้อความไหลเข้า
3. ตรวจในฐานข้อมูล:

```cmd
psql -U postgres -d linechat -c "SELECT display_name, message_text, sent_at FROM line_messages ORDER BY sent_at DESC LIMIT 10;"
```

### C5. หา groupId เก็บไว้ใช้ส่งข้อความกลับ

```cmd
psql -U postgres -d linechat -c "SELECT DISTINCT group_id FROM line_messages;"
```

จด groupId (ขึ้นต้นด้วย C) ไว้ใช้ใน Part D

---

## Part D: เชื่อม MCP ทั้ง 2 ตัวเข้า Claude Code (15 นาที)

### D1. เพิ่ม Postgres MCP (ขาอ่าน)

```cmd
claude mcp add postgres-linechat ^
  -- npx -y @modelcontextprotocol/server-postgres postgresql://postgres:รหัสผ่าน@localhost:5432/linechat
```

### D2. เพิ่ม LINE Bot MCP (ขาส่ง)

ต้องมี Node.js v22 ขึ้นไป (ตรวจด้วย `node -v`)

```cmd
claude mcp add line-bot ^
  -e NPM_CONFIG_IGNORE_SCRIPTS=true ^
  -e CHANNEL_ACCESS_TOKEN=โทเคนของคุณ ^
  -e DESTINATION_USER_ID=ใส่groupIdจากC5 ^
  -- npx -y @line/line-bot-mcp-server
```

เกร็ดสำคัญ: ตามเอกสาร `DESTINATION_USER_ID` ออกแบบไว้สำหรับ userId แต่ Push API ของ LINE รองรับการส่งไปยัง groupId ได้เช่นกัน จึงใส่ groupId ได้เลย ทำให้ push_text_message ส่งเข้ากลุ่มโดยตรง (ให้ทดสอบก่อนใช้จริงในคลาส)

### D3. ตรวจสอบ

เปิด `claude` → `/mcp` ต้องเห็น `postgres-linechat` และ `line-bot` เป็น connected

ทดสอบขาส่งด้วย prompt สั้นๆ:

```
ส่งข้อความ "ทดสอบจาก Claude Code ครับ" เข้ากลุ่ม LINE ผ่าน line-bot
```

---

## Part E: Prompts ฝึกสรุปและวิเคราะห์บทสนทนา (45 นาที)

### E1. สรุปบทสนทนาพื้นฐาน

```
อ่านข้อความทั้งหมดในตาราง line_messages ของวันนี้
แล้วสรุปว่ากลุ่มคุยเรื่องอะไรกันบ้าง แบ่งเป็นหัวข้อ
พร้อมระบุว่าใครเป็นคนเสนอประเด็นไหน
```

### E2. วิเคราะห์พฤติกรรมกลุ่ม

```
วิเคราะห์จากตาราง line_messages:
1. ใครพูดเยอะสุด 3 อันดับ (จำนวนข้อความและสัดส่วนเปอร์เซ็นต์)
2. ช่วงเวลาไหนของวันที่กลุ่มคุยกันคึกคักที่สุด
3. ความยาวข้อความเฉลี่ยของแต่ละคน บอกอะไรเกี่ยวกับสไตล์การสื่อสารบ้าง
```

### E3. ค้นหาและติดตามงาน (ใช้งานจริงในทีม)

```
ค้นในบทสนทนาว่ามีการนัดหมาย มอบหมายงาน หรือสัญญาว่าจะทำอะไรบ้าง
สรุปเป็นตาราง: ใครรับปาก / เรื่องอะไร / กำหนดเมื่อไหร่ (ถ้าระบุ)
```

### E4. สรุปแล้วส่งกลับเข้ากลุ่ม (ไฮไลท์ของ Lab)

```
สรุปบทสนทนาวันนี้ในกลุ่มให้กระชับไม่เกิน 10 บรรทัด
ขึ้นต้นว่า "สรุปประชุมกลุ่มวันนี้" ตามด้วยประเด็นสำคัญเป็นข้อๆ
และรายการงานที่มีคนรับไปทำ
แล้วส่งเข้ากลุ่ม LINE ผ่าน push_text_message
```

### E5. Flex Message รายงานสวยงาม

```
สร้างสรุปสถิติกลุ่มวันนี้เป็น Flex Message แบบ bubble:
หัวข้อ "Daily Group Report" พื้นหลังส่วนหัวสีน้ำเงินเข้ม
แสดง จำนวนข้อความรวม, Top 3 คนที่คุยเยอะสุด, หัวข้อเด่น 3 เรื่อง
แล้วส่งเข้ากลุ่มผ่าน push_flex_message
```

### E6. รายงาน HTML ประจำสัปดาห์

```
ดึงข้อมูลทั้งหมดจาก line_messages สร้างรายงาน reports/weekly-chat-report.html
- กราฟแท่ง: จำนวนข้อความรายวัน (Chart.js)
- กราฟวงกลม: สัดส่วนข้อความของสมาชิกแต่ละคน
- Timeline หัวข้อสนทนาสำคัญ
- ตารางงานค้างที่พบจากบทสนทนา
ธีมสี LINE (เขียว #06C755) ภาษาไทย
```

### E7. Challenge: Scheduled Daily Summary

ให้ผู้เรียนออกแบบ + เขียน prompt เอง: สร้างสคริปต์ `daily-summary.js` ที่ (1) ดึงข้อความ 24 ชม. ล่าสุดจาก PostgreSQL (2) เรียก Claude API สรุป (3) push เข้ากลุ่มด้วย @line/bot-sdk แล้วตั้ง Task Scheduler ของ Windows รันทุก 18:00 - จุดสอนคือการเปลี่ยนจาก "สั่งมือ" เป็น "ระบบอัตโนมัติ"

---

## ปัญหาที่พบบ่อย

| อาการ | สาเหตุ/วิธีแก้ |
|---|---|
| Verify webhook ไม่ผ่าน | server ยังไม่รัน / URL ไม่มี /webhook ต่อท้าย / ngrok หลุด (URL ฟรีเปลี่ยนทุกครั้งที่รันใหม่ ต้องอัปเดตใน console) |
| เชิญ bot เข้ากลุ่มไม่ได้ | ยังไม่เปิด "Allow bot to join group chats" ใน OA Manager |
| ข้อความไม่เข้า DB แต่ webhook ได้ 200 | ดู log ฝั่ง server มักเป็น DATABASE_URL ผิดหรือยังไม่รัน init.sql |
| Signature validation failed | CHANNEL_SECRET ไม่ตรง (อย่าสับสนกับ access token) |
| line-bot MCP ต่อไม่ได้ | Node ต่ำกว่า v22 หรือ access token หมดอายุ/ผิด |
| push_text_message ไม่ถึงกลุ่ม | DESTINATION_USER_ID ไม่ใช่ groupId ที่ถูกต้อง หรือ bot ถูกเตะออกจากกลุ่มแล้ว |
| ได้รับข้อความซ้ำใน DB | ปกติ LINE ส่ง retry ได้ - ตรวจว่าใช้ ON CONFLICT DO NOTHING แล้ว |
| โควต้าข้อความหมด | Free plan ส่ง push ได้ 200 ข้อความ/เดือน ตรวจด้วย tool get_message_quota |

## ข้อควรระวังด้าน Privacy (ย้ำในคลาส)

การเก็บบทสนทนากลุ่มลงฐานข้อมูลต้องแจ้งให้สมาชิกทุกคนในกลุ่มทราบและยินยอมก่อนเสมอ (ใน Lab เราให้ bot ประกาศตัวตอน join) ห้ามนำไปใช้กับกลุ่มจริงโดยไม่ได้รับอนุญาต และไม่ควรเก็บข้อมูลอ่อนไหว เช่น รหัสผ่านหรือข้อมูลส่วนบุคคล ลงรายงาน

---

## เอกสารอ้างอิง

- LINE Bot MCP Server: https://github.com/line/line-bot-mcp-server
- LINE Messaging API - Getting Started: https://developers.line.biz/en/docs/messaging-api/getting-started/
- LINE Messaging API - Receiving messages (Webhook): https://developers.line.biz/en/docs/messaging-api/receiving-messages/
- LINE Messaging API - Group chats: https://developers.line.biz/en/docs/messaging-api/group-chats/
- Channel access token: https://developers.line.biz/en/docs/basics/channel-access-token/
- @line/bot-sdk (Node.js): https://github.com/line/line-bot-sdk-nodejs
- Flex Message Simulator: https://developers.line.biz/flex-simulator/
- ngrok: https://ngrok.com/docs
- Claude Code - MCP: https://docs.claude.com/en/docs/claude-code/mcp
