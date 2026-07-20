# 💬 Slack Seed — ข้อความสำหรับ Workspace ทดสอบ

> **วิธีใช้:** สร้าง Channel ตามด้านล่างใน Slack workspace ทดสอบ แล้วโพสต์ข้อความเหล่านี้ (โพสต์เองหรือชวนเพื่อนช่วยโพสต์) เพื่อให้ lab สรุป Channel / Standup Bot เห็นผลจริง

## #general
```
HR [09:00] แจ้ง: ประชุม Budget Planning Workshop วันนี้ 14:00 — Department Head เข้าร่วมทุกท่านนะคะ
วิภา [09:05] รับทราบครับ เตรียมตัวเลขงบฝ่ายขายไปแล้ว
ธนา [09:10] ฝ่าย Tech พร้อมครับ
```

## #sales-team
```
สมหมาย [09:15] Close deal ลูกค้า Enterprise 2 ราย รวม 280K บาท 🎉
วิภา [09:20] เยี่ยมมาก! อัปเดต CRM ด้วยนะคะ
สมหมาย [10:00] ลูกค้า ABC Corp ขอใบเสนอราคา Notebook 50 เครื่อง — กำลังเตรียม
ธนา [10:30] @สมหมาย ส่ง spec มาด้วย จะได้เตรียม IT config ล่วงหน้า
```

## #dev-updates
```
อนุชา [14:00] CRM Module 4 เสร็จแล้ว รอ Code Review
กัญญา [14:30] รีบ Review ให้นะครับ ติดรอ Deploy อยู่
ธนา [15:00] Review แล้ว มี 2 comment minor — fix แล้วค่อย merge
```

## #team  (สำหรับ lab Weekly Report ปลายทาง)
```
สมชาย [17:00] ขอบคุณทุกคนสำหรับสัปดาห์นี้ครับ อย่าลืมส่งสรุปงานก่อนศุกร์
```

---
**Prompt ที่ทดสอบได้:**
- _"สรุป #general วันนี้"_
- _"สรุป Slack #sales-team 24 ชม.ที่ผ่านมา: Highlights | Open Items | Blockers"_
- (Automation คืน 4) _"รวบรวม briefing ของสัปดาห์ → สร้างสรุป → ส่งเข้า Slack #team"_
