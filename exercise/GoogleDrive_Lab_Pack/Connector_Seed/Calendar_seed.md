# 📅 Calendar Seed — เหตุการณ์สำหรับ Google Calendar

> สร้างเหตุการณ์เหล่านี้ใน Google Calendar ของบัญชีทดสอบ **โดยตั้งเป็น "วันที่สอน" (วันนี้)** เพื่อให้ lab Morning Briefing และ Multi-Connector ("เตรียมประชุม 14:00") เห็นผลจริง

## ⭐ เหตุการณ์สำคัญของวัน (ต้องมี)

| เวลา | หัวข้อ | รายละเอียด | ผูกกับไฟล์ใน Drive |
|------|--------|-----------|--------------------|
| 14:00 – 15:30 | **Budget Planning Workshop** | ผู้เข้าร่วม: CFO, Finance Team, Department Heads | `04_Budget/Q3_Budget_Draft_v2.xlsx` |

> นี่คือเหตุการณ์หลักที่ Multi-Connector Workflow จะใช้ ("เตรียมฉันสำหรับประชุม 14:00 น.") — Claude ต้องค้นเจอไฟล์ Q3 Budget ใน Drive + อีเมลเรื่องงบใน Gmail

## เหตุการณ์ประกอบ (สร้างในวันเดียวกัน)

- **09:00 – 09:30** Standup Team Meeting (Google Meet) — ทีม Product 6 คน
- **10:00 – 11:00** 1:1 กับ CEO — หัวข้อ: Q3 Strategy Review
- **11:30 – 12:30** Product Demo กับลูกค้า ABC Corp — *ลูกค้า Tier 1 เตรียม Demo Environment* (ผูกกับ `05_Projects/project_brief_ABC_Corp.docx`)
- **16:00 – 16:30** Training Session: New CRM System (Online)

## เหตุการณ์วันถัดไป (เผื่อ demo "ประชุมพรุ่งนี้")

- **10:00 – 12:00** Quarterly Business Review (QBR) — ผู้นำเสนอ: ทุก Department Head
- **13:00 – 14:00** Legal Review: Contract ABC Corp — ต้องการ Feedback ก่อน EOD

---
**Tip:** ใส่ผู้เข้าร่วมและลิงก์ Meet/Zoom จริง เพื่อให้ briefing ดูสมจริง และทดสอบ prompt _"วันนี้มีประชุมอะไรบ้าง เตรียม Brief สั้นๆ"_
