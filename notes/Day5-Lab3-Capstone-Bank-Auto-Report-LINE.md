# Day 5 - Lab 3 (Capstone): ระบบรายงานธนาคารอัตโนมัติ - จาก PostgreSQL สู่กลุ่ม LINE

**แนวคิด:** นำทุกอย่างที่เรียนใน Lab 1 + Lab 2 มาประกอบเป็นระบบเดียวที่ใช้งานได้จริงในธนาคาร: ดึงข้อมูลธุรกรรมจากฐานข้อมูล → สรุปเป็นรายงานประจำวัน → ส่งเข้ากลุ่ม LINE ผู้บริหาร → ตั้งเวลารันอัตโนมัติทุกเช้า

**ฐานข้อมูล:** `bankops` (ธนาคารจำลอง) - ไฟล์ seed อยู่ที่ `exercise\Database\PostgreSQL\bankops_seed.sql`
**เวลา:** ยืดหยุ่น 45-90 นาที (แกนหลักคือ Part A-D ส่วน Part E-F และ Bonus ตัดได้ตามเวลา)
**เงื่อนไขก่อนเริ่ม:** ผ่าน Lab 1 (มี PostgreSQL + psql) และ Lab 2 (มี LINE OA + CHANNEL_ACCESS_TOKEN + groupId + MCP line-bot) แล้ว

ข้อดีของ Lab นี้: **ไม่ต้องติดตั้งอะไรใหม่เลย** และไม่ต้องใช้ ngrok/webhook เพราะเราใช้ขา "ส่ง" (Push API) อย่างเดียว

### สถาปัตยกรรม

```
PostgreSQL (bankops) ◄── import จาก bankops_seed.sql
        │
        │ (1) อ่านผ่าน Postgres MCP  → วิเคราะห์แบบ interactive
        │ (2) อ่านผ่านสคริปต์ Node.js → รายงานอัตโนมัติ
        ▼
Claude Code ──► สร้างสคริปต์ daily-report ──► LINE Push API (Flex Message)
                        │                            │
                        ▼                            ▼
              Windows Task Scheduler          กลุ่ม LINE ผู้บริหาร
              (รันทุกเช้า 08:00)
```

---

## ทำความรู้จักฐานข้อมูล bankops

ธนาคารจำลองในลาว สกุลเงิน LAK มี 6 ตาราง:

| ตาราง | เนื้อหา | จำนวนแถว |
|---|---|---|
| `branches` | สาขา 6 แห่ง (เวียงจันทน์ 2, หลวงพระบาง, สะหวันนะเขต, ปากเซ, อุดมไซ) | 6 |
| `customers` | ลูกค้า แบ่ง segment: retail / sme / corporate | 50 |
| `accounts` | บัญชีเงินฝาก: savings / current / fixed พร้อมยอดคงเหลือ | 80 |
| `transactions` | ธุรกรรมย้อนหลัง 30 วัน: deposit / withdraw / transfer_in / transfer_out / fee ผ่าน 3 ช่องทาง (mobile_app / atm / branch) | 603 |
| `loans` | สินเชื่อ: home / auto / sme / personal สถานะ active / closed / overdue | 40 |
| `exchange_rates` | อัตราแลกเปลี่ยน THB / USD / CNY เทียบ LAK ย้อนหลัง 30 วัน | 90 |

จุดออกแบบที่วิทยากรควรรู้ (อย่าเพิ่งบอกผู้เรียน):

1. ข้อมูลธุรกรรมสร้างแบบสุ่ม **ย้อนหลัง 30 วันนับจากวันที่ import** ดังนั้น import วันไหนข้อมูลก็สดเสมอ query คำว่า "เมื่อวาน" ได้ผลจริงทุกครั้งที่สอน
2. มี **ธุรกรรมผิดปกติมูลค่าสูง 3 รายการ** (350-620 ล้าน LAK ผ่านช่องทาง branch) ฝังไว้ "เมื่อวานนี้" โดยเจตนา ไว้ใช้สอน Anomaly Detection ใน C4 - ให้ผู้เรียนค้นพบเอง
3. ความสัมพันธ์: `transactions` → `accounts` → `customers` และทุกตารางธุรกรรมผูกกับ `branches`

---

## Part A: สร้างและ Import ฐานข้อมูล (10 นาที)

เปิด Command Prompt ในโฟลเดอร์ `exercise\Database\PostgreSQL`

```cmd
psql -U postgres -c "CREATE DATABASE bankops;"
psql -U postgres -d bankops -f bankops_seed.sql
```

ตรวจสอบจำนวนแถวทุกตาราง:

```cmd
psql -U postgres -d bankops -c "SELECT 'branches' AS t, count(*) FROM branches UNION ALL SELECT 'customers', count(*) FROM customers UNION ALL SELECT 'accounts', count(*) FROM accounts UNION ALL SELECT 'transactions', count(*) FROM transactions UNION ALL SELECT 'loans', count(*) FROM loans UNION ALL SELECT 'exchange_rates', count(*) FROM exchange_rates;"
```

ผลที่คาดหวัง: branches 6, customers 50, accounts 80, transactions 603, loans 40, exchange_rates 90

ทดสอบว่ามีข้อมูล "เมื่อวาน" จริง:

```cmd
psql -U postgres -d bankops -c "SELECT b.name, count(*) AS txn, sum(t.amount) AS total FROM transactions t JOIN branches b ON b.id = t.branch_id WHERE t.txn_at::date = CURRENT_DATE - 1 GROUP BY b.name ORDER BY total DESC;"
```

---

## Part B: เชื่อม MCP (5 นาที)

รันในโฟลเดอร์โปรเจกต์ capstone (เช่น `day5-capstone`):

```cmd
claude mcp add postgres-bankops ^
  -- npx -y @modelcontextprotocol/server-postgres postgresql://postgres:รหัสผ่าน@localhost:5432/bankops
```

MCP `line-bot` ใช้ตัวเดิมจาก Lab 2 ได้เลย (ถ้าเพิ่มไว้เป็น scope local ของโปรเจกต์อื่น ให้รัน `claude mcp add line-bot ...` ซ้ำในโฟลเดอร์นี้ โดยใช้ CHANNEL_ACCESS_TOKEN และ DESTINATION_USER_ID = groupId เดิม)

เปิด `claude` → `/mcp` ตรวจว่าเห็นทั้ง `postgres-bankops` และ `line-bot`

---

## Part C: Warm-up - วิเคราะห์ข้อมูลธนาคารผ่าน MCP (15 นาที)

### C1. สำรวจฐานข้อมูล

```
สำรวจฐานข้อมูล bankops ว่ามีตารางอะไร เก็บอะไร สัมพันธ์กันอย่างไร
วาด ER diagram แบบ text แล้วอธิบายเป็นภาษาไทยว่านี่คือระบบอะไร
```

### C2. สรุปผลประกอบการเมื่อวาน

```
สรุปธุรกรรมของเมื่อวานทั้งธนาคาร:
- จำนวนรายการและยอดรวม แยกตามประเภทธุรกรรม
- แยกตามช่องทาง (mobile_app / atm / branch) พร้อมสัดส่วนเปอร์เซ็นต์
- สาขาไหนมียอดธุรกรรมสูงสุด
ตัวเลขให้มี comma และระบุหน่วยเป็น LAK
```

### C3. วิเคราะห์เชิงลึก

```
1. ลูกค้า segment ไหนมียอดเงินฝากรวม (balance) สูงสุด
2. สินเชื่อสถานะ overdue มีกี่สัญญา คิดเป็นยอดหนี้เท่าไหร่
   และกระจุกตัวอยู่สาขาไหน loan type ไหนมากที่สุด
3. อัตราแลกเปลี่ยน USD/LAK ในรอบ 30 วัน มีแนวโน้มขึ้นหรือลง
   วันไหนผันผวนสุด
```

### C4. Anomaly Detection (ไฮไลท์ - ให้ผู้เรียนค้นพบเอง)

```
ช่วยหาธุรกรรมที่ผิดปกติในรอบ 7 วันที่ผ่านมา
โดยเทียบกับค่าเฉลี่ยและส่วนเบี่ยงเบนมาตรฐานของยอดธุรกรรมทั้งหมด
รายการไหนสูงผิดปกติ (เกิน 3 เท่าของ SD) ให้แสดง
วันเวลา สาขา ช่องทาง จำนวนเงิน และชื่อเจ้าของบัญชี
พร้อมความเห็นว่าธนาคารควรทำอะไรต่อ
```

ผู้เรียนจะพบธุรกรรม 350-620 ล้าน LAK จำนวน 3 รายการที่ seed ฝังไว้ - จุดสอนคือ AI + SQL ทำ fraud screening เบื้องต้นได้ในประโยคเดียว

---

## Part D: สร้างสคริปต์ Daily Report ส่งเข้า LINE (30 นาที)

### D1. เตรียม .env

สร้างไฟล์ `.env` ในโปรเจกต์ (ใช้ค่าจาก Lab 2):

```
DATABASE_URL=postgresql://postgres:รหัสผ่าน@localhost:5432/bankops
CHANNEL_ACCESS_TOKEN=โทเคนของคุณ
LINE_GROUP_ID=groupIdของกลุ่ม
```

### D2. Prompt สร้างสคริปต์ (copy ใช้ได้ทันที)

```
สร้างสคริปต์ Node.js ชื่อ scripts/daily-report.js (ไม่ใส่ semicolon)
ทำหน้าที่รายงานผลประกอบการธนาคารประจำวัน โดย:

1. ต่อ PostgreSQL ด้วย library pg อ่าน config จาก .env (ใช้ dotenv)
2. Query ข้อมูลของ "เมื่อวาน" (CURRENT_DATE - 1):
   - ยอดรวมและจำนวนรายการ แยกตามประเภทธุรกรรม
   - สัดส่วนช่องทาง mobile_app / atm / branch
   - Top 3 สาขาตามยอดธุรกรรม
   - จำนวนบัญชีเปิดใหม่ (opened_at = เมื่อวาน) ถ้าไม่มีให้แสดง 0
   - ธุรกรรมมูลค่าเกิน 100 ล้าน LAK (ถ้ามี ให้ทำเป็นรายการแจ้งเตือน)
   - อัตราแลกเปลี่ยน USD THB CNY ล่าสุด
3. ประกอบเป็น Flex Message 1 bubble:
   - Header พื้นสี Navy #202063 ข้อความ "Daily Banking Report"
     และวันที่ภาษาไทย เช่น "ประจำวันที่ 22 ก.ค. 2026"
   - Body แบ่ง section: ยอดธุรกรรมรวม (ตัวใหญ่), แยกช่องทาง,
     Top 3 สาขา, อัตราแลกเปลี่ยน
   - ถ้ามีธุรกรรมเกิน 100 ล้าน ให้มี section แจ้งเตือนพื้นแดง #EC1C24
     ตัวหนังสือขาว บอกจำนวนรายการและยอดรวม
   - Footer ข้อความ "Generated by Claude Code" ตัวเล็กสีเทา
4. ส่งเข้ากลุ่มด้วย LINE Push API ผ่าน library @line/bot-sdk
   ไปที่ LINE_GROUP_ID
5. มี flag --dry-run ที่แสดง JSON ของ flex message แทนการส่งจริง
6. จัดการ error: DB ต่อไม่ได้ หรือ LINE ตอบ error ให้ log ชัดเจนและ
   exit code ไม่เป็น 0
7. comment ภาษาไทยอธิบายทุกฟังก์ชัน

ติดตั้ง dependencies (pg, @line/bot-sdk, dotenv) แล้วทดสอบด้วย --dry-run
ให้ผมดูผลลัพธ์ก่อน ยังไม่ต้องส่งจริง
```

### D3. ทดสอบส่งจริง

ตรวจ JSON จาก dry-run แล้วสั่ง:

```
ผลลัพธ์ถูกต้องแล้ว รัน node scripts/daily-report.js ส่งเข้ากลุ่มจริงเลย
```

ทุกกลุ่มควรเห็น Flex Message รายงานในกลุ่ม LINE ของตัวเอง - นี่คือ moment สำคัญของ capstone

จุดสอน: เปรียบเทียบให้เห็นว่า Part C (ถามผ่าน MCP) เหมาะกับงาน ad-hoc ส่วน Part D (สคริปต์) เหมาะกับงานประจำที่ต้องรันซ้ำโดยไม่มีคน และ Claude Code คือคนเขียนสคริปต์ให้เราทั้งสองแบบ

---

## Part E: ตั้งเวลารันอัตโนมัติด้วย Task Scheduler (10 นาที)

### E1. สร้างไฟล์ wrapper

ให้ Claude Code ทำให้:

```
สร้างไฟล์ run-daily-report.bat ที่ cd เข้าโฟลเดอร์โปรเจกต์นี้
แล้วรัน node scripts/daily-report.js พร้อม append log
ลง logs/daily-report.log ทั้ง stdout และ stderr พร้อม timestamp
```

### E2. ลงทะเบียนใน Task Scheduler

เปิด Command Prompt แบบ Run as administrator:

```cmd
schtasks /Create /TN "BankDailyReport" ^
  /TR "C:\path\to\day5-capstone\run-daily-report.bat" ^
  /SC DAILY /ST 08:00
```

ทดสอบรันทันทีโดยไม่ต้องรอถึงเวลา:

```cmd
schtasks /Run /TN "BankDailyReport"
```

ลบเมื่อจบคลาส (กันส่งรายงานทุกเช้าใส่กลุ่มตลอดไป):

```cmd
schtasks /Delete /TN "BankDailyReport" /F
```

จุดสอน: ระบบนี้คือ pattern เดียวกับงานจริงในธนาคาร เพียงเปลี่ยน bankops เป็นฐานข้อมูลรายงานจริง และเปลี่ยนกลุ่มทดสอบเป็นกลุ่มผู้บริหาร ย้ำเรื่อง governance ด้วย: ฐานข้อมูลจริงต้องใช้ read-only user และข้อมูลลูกค้าจริงห้ามส่งออกนอกระบบธนาคารโดยไม่ผ่านการอนุมัติ

---

## Part F: โจทย์ต่อยอด (เลือกตามเวลาที่เหลือ)

### F1. Weekly HTML Executive Report

```
สร้างรายงานประจำสัปดาห์ reports/weekly-report.html จากฐาน bankops
- กราฟเส้น: ยอดธุรกรรมรายวัน 30 วัน (Chart.js)
- กราฟแท่ง: เปรียบเทียบยอดแต่ละสาขา
- กราฟเส้น: แนวโน้ม USD/LAK
- ตารางสินเชื่อ overdue พร้อมไฮไลท์แดง
- สรุป insight เชิงธุรกิจ 3 ข้อจากข้อมูลจริง
ธีม Navy #202063 ภาษาไทย
```

### F2. Alert เฉพาะเหตุการณ์ผิดปกติ

```
เพิ่มสคริปต์ scripts/fraud-alert.js ที่ตรวจธุรกรรม 24 ชม. ล่าสุด
ถ้าพบรายการเกิน 200 ล้าน LAK ให้ push ข้อความเตือนเข้ากลุ่มทันที
บอกเวลา สาขา ช่องทาง จำนวนเงิน ชื่อบัญชี
ถ้าไม่พบ ไม่ต้องส่งอะไร (เงียบ)
```

### F3. ถาม-ตอบสด (ปิดท้ายสนุกๆ)

ให้แต่ละกลุ่มคิดคำถามธุรกิจเอง 1 ข้อ เช่น "ถ้าเราจะปิด 1 สาขา ควรปิดสาขาไหนเพราะอะไร" แล้วให้ Claude Code วิเคราะห์จากข้อมูลจริง นำเสนอหน้าห้องกลุ่มละ 2 นาที

---

## Bonus (สำหรับกลุ่มที่เร็ว): สร้าง MCP Server ของตัวเอง

เปลี่ยนบทบาทจาก "ผู้ใช้ MCP" เป็น "ผู้สร้าง MCP" - สร้าง server ที่ห่อ business logic ของธนาคารเป็น tools สำเร็จรูป:

```
สร้าง MCP server ชื่อ bankops-mcp ด้วย TypeScript (ไม่ใส่ semicolon)
ใช้ @modelcontextprotocol/sdk แบบ stdio transport มี 3 tools:
1. get_daily_summary(date) - สรุปธุรกรรมของวันที่ระบุ
2. check_overdue_loans() - รายการสินเชื่อค้างชำระพร้อมยอดรวม
3. get_fx_trend(currency, days) - อัตราแลกเปลี่ยนย้อนหลัง n วัน
ทุก tool ต่อ PostgreSQL ฐาน bankops ผ่าน DATABASE_URL
เขียน README วิธี register เข้า Claude Code ด้วย claude mcp add
เสร็จแล้ว build และบอกคำสั่ง register
```

จากนั้น register แล้วทดสอบ: `ใช้ tool get_daily_summary ดูสรุปของเมื่อวาน` - จุดสอนคือ MCP ที่ใช้มาทั้งวันไม่ใช่เวทมนตร์ เราสร้างเองได้ใน 20 นาที

---

## ปัญหาที่พบบ่อย

| อาการ | สาเหตุ/วิธีแก้ |
|---|---|
| import แล้วจำนวน transactions ไม่ตรง 603 | รันไฟล์ seed ซ้ำได้เลย (มี DROP TABLE ในตัว) |
| query "เมื่อวาน" ไม่มีข้อมูล | เพิ่ง import วันนี้ใช่หรือไม่ ข้อมูลสุ่มกระจาย 30 วัน บางวันอาจน้อย ลองเปลี่ยนเป็น 7 วันล่าสุด |
| Flex Message ไม่แสดงในกลุ่ม | ตรวจ LINE_GROUP_ID (ต้องขึ้นต้นด้วย C) และ bot ยังอยู่ในกลุ่ม |
| LINE ตอบ 400 invalid flex | JSON flex ผิดโครงสร้าง ให้วาง error ตอบกลับใส่ Claude Code แก้ หรือทดสอบใน Flex Simulator |
| Task Scheduler รันแล้วไม่มีอะไรเกิด | ดู logs/daily-report.log มักเป็น path ใน .bat ผิด หรือ node ไม่อยู่ใน PATH ของ SYSTEM ให้ใส่ full path ของ node.exe |
| โควต้า LINE หมด | Free plan 200 push/เดือน ตรวจด้วย tool get_message_quota ใน line-bot MCP |

---

## สรุปภาพรวมทั้งคอร์ส (ใช้ปิดท้าย Day 5)

| วัน | สิ่งที่สร้าง | ทักษะแกน |
|---|---|---|
| Day 1-2 | งานเอกสารด้วย Claude Design + Cowork | สั่งงาน AI, ตรวจงาน |
| Day 3 | Corporate site (React) | Brief, Agentic coding |
| Day 4 | Mobile app (React Native Expo) | Design First → Spec → Build |
| Day 5 | ระบบข้อมูล + รายงานอัตโนมัติเข้า LINE | MCP, Integration, Automation |

ข้อความปิดคอร์ส: ทั้ง 5 วันคือ pipeline เดียวกัน - ออกแบบให้ชัด สื่อสารกับ AI ให้เป็น ตรวจสอบให้เป็น แล้วประกอบเครื่องมือเข้าด้วยกันเป็นระบบอัตโนมัติที่ทำงานแทนเราทุกวัน

---

## เอกสารอ้างอิง

- Claude Code - MCP: https://docs.claude.com/en/docs/claude-code/mcp
- MCP - Build a Server: https://modelcontextprotocol.io/docs/develop/build-server
- @modelcontextprotocol/sdk (TypeScript): https://github.com/modelcontextprotocol/typescript-sdk
- LINE Messaging API - Push message: https://developers.line.biz/en/reference/messaging-api/#send-push-message
- LINE Flex Message: https://developers.line.biz/en/docs/messaging-api/using-flex-messages/
- Flex Message Simulator: https://developers.line.biz/flex-simulator/
- node-postgres (pg): https://node-postgres.com/
- Windows schtasks: https://learn.microsoft.com/windows-server/administration/windows-commands/schtasks
- PostgreSQL generate_series: https://www.postgresql.org/docs/current/functions-srf.html
