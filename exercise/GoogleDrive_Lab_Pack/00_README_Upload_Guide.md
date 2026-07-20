# 📦 Google Drive Lab Pack — คู่มือเตรียมข้อมูลคืนที่ 3

**สำหรับ:** Workshop Claude Cowork — คืนที่ 3 (Document Intelligence + Connectors)
**จัดทำเพื่อ:** อาจารย์สามิตร

ชุดไฟล์นี้ใช้เตรียม "ชีวิตการทำงานจำลอง" ใน Google Drive + Gmail + Calendar + Slack เพื่อให้ lab เรื่อง Connector และ Morning Briefing **เห็นผลจริง** ไม่ใช่แค่ทฤษฎี

---

## 🎬 เรื่องราว (Storyline) ที่ร้อยทุกไฟล์เข้าด้วยกัน

ทุกไฟล์ออกแบบให้เชื่อมโยงกันเป็นเรื่องเดียว เพื่อให้ Multi-Connector Workflow น่าเชื่อ:

> วันนี้มี **ประชุม Budget Planning 14:00** — Claude ต้องดึงนัดจาก **Calendar**, หาไฟล์ `Q3_Budget_Draft_v2.xlsx` ใน **Drive**, อ่านอีเมลเรื่องงบจาก CFO ใน **Gmail** และสรุปเป็น Brief ให้ — ขณะที่ลูกค้า **ABC Corp** กำลังรอใบเสนอราคาอยู่ด้วย

---

## 1️⃣ โครงสร้างที่จะอัปโหลดเข้า Google Drive

ลากทั้งโฟลเดอร์ `Drive_Content/` เข้า Google Drive (จะได้ ≥ 12 ไฟล์ พอสำหรับ demo "10 ไฟล์ล่าสุด")

```
📁 Claude Cowork Lab/                         ← สร้างโฟลเดอร์นี้ใน Drive
├── 📁 01_Reports/
│   ├── 04_financial_statement_q1q4.csv       → แปลงเป็น Google Sheet
│   ├── 04_survey_results.csv                  → แปลงเป็น Google Sheet
│   ├── 04_research_notes.txt
│   └── 03_monthly_report_raw_data.txt
├── 📁 02_Meetings/
│   └── 04_meeting_transcript_01–05.txt        (5 ไฟล์)
├── 📁 03_Customer/
│   ├── 04_customer_feedback_q1.txt
│   └── 04_customer_feedback_q2.txt
├── 📁 04_Budget/
│   ├── Q3_Budget_Draft_v2.xlsx       ⭐ ผูกกับนัด 14:00
│   ├── marketing_budget_2026.xlsx    (มีคำว่า budget — demo ค้นหา)
│   └── budget_approval_notes.txt     (มีคำว่า budget — demo ค้นหา)
└── 📁 05_Projects/
    ├── project_brief_ABC_Corp.docx   ⭐ ผูกกับลูกค้า ABC Corp
    └── product_launch_updates.txt    ⭐ ใช้ demo "แก้ไขล่าสุด 24 ชม."
```

### วิธีอัปโหลด
1. เปิด Google Drive → สร้างโฟลเดอร์ **Claude Cowork Lab**
2. ลากเนื้อหาในโฟลเดอร์ `Drive_Content/` ทั้งหมดเข้าไป
3. **แนะนำ:** ตั้งค่า Drive ให้ "แปลงไฟล์ที่อัปโหลดเป็นรูปแบบ Google" (Settings → Convert uploads) เพราะ Connector อ่าน Google Docs/Sheets ได้ดีกว่า .txt/.csv/.xlsx
4. เชื่อม Connector: Settings → Connectors → Google Drive → Connect (เริ่มที่ **Drive.Read** ก่อน)

---

## 2️⃣ ตารางจับคู่ไฟล์ → Lab / Prompt

| Lab / Prompt | Connector | ไฟล์ที่ใช้ |
|--------------|-----------|-----------|
| Multi-Document Summary | Drive | `02_Meetings/*` ทั้ง 5 ไฟล์ |
| Meeting Summary | Drive | `04_meeting_transcript_01.txt` |
| Financial Analysis | Drive | `04_financial_statement_q1q4.csv` |
| Executive Briefing Sprint | Drive | meetings + feedback + survey + financial |
| ค้นหาไฟล์ `'budget'` | Drive | `Q3_Budget_Draft_v2.xlsx`, `marketing_budget_2026.xlsx`, `budget_approval_notes.txt` |
| "ไฟล์ที่แก้ไขล่าสุด 24 ชม." | Drive | `product_launch_updates.txt` (แก้ก่อนสอน) |
| Email Triage / Draft Reply | Gmail | `Connector_Seed/Gmail_seed.md` |
| "วันนี้มีประชุมอะไรบ้าง" | Calendar | `Connector_Seed/Calendar_seed.md` |
| สรุป Channel / Standup | Slack | `Connector_Seed/Slack_seed.md` |
| ⭐ Multi-Connector "เตรียมประชุม 14:00" | Cal + Drive + Gmail | นัด 14:00 + `Q3_Budget_Draft_v2.xlsx` + อีเมล CFO |
| ⭐ Morning Briefing | Cal + Gmail + Drive | ทุกแหล่งรวมกัน |

---

## 3️⃣ Checklist เตรียมก่อนสอน (ทำตามลำดับ)

- [ ] อัปโหลด `Drive_Content/` เข้า Google Drive (เปิด Convert uploads)
- [ ] เชื่อม Connector: Drive + Gmail + Calendar + Slack (Read-only ก่อน)
- [ ] **แก้ไข `product_launch_updates.txt` 1 บรรทัด** ก่อนคลาส → ให้ติด "modified ใน 24 ชม."
- [ ] ส่งอีเมลตาม `Gmail_seed.md` เข้า Inbox ทดสอบ (ส่งก่อนคลาส 1–2 ชม. ให้ยัง "ไม่อ่าน")
- [ ] สร้างเหตุการณ์ตาม `Calendar_seed.md` ใน **วันที่สอน** (ต้องมีนัด 14:00 Budget Workshop)
- [ ] โพสต์ข้อความตาม `Slack_seed.md` ในแต่ละ Channel
- [ ] ทดสอบ prompt ทุกตัวก่อนสอน 1 รอบ (Test Manual ก่อน Automate)

---

## 4️⃣ ข้อควรระวัง (สอดคล้องกับ Module 8 — Security)

- ใช้ **บัญชีทดสอบ** เท่านั้น อย่าใช้ Drive/Gmail งานจริงในคลาส
- เริ่มจาก **Read-only** ทุก Connector แล้วค่อยเพิ่มสิทธิ์ตอน demo Draft
- เป็นข้อมูลสมมติทั้งหมด — ปลอดภัยสำหรับแชร์หน้าจอ

---
*จัดทำโดย Claude Cowork สำหรับ Workshop คืนที่ 3 | อ้างอิง: 02_StepByStep_Guide & Workshop_Files*
