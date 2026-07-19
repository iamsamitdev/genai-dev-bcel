# Generative AI for Software Developer - วันที่ 3: AI Prototyping, Automation, Testing & Best Practices

**หลักสูตรอบรมเชิงปฏิบัติการ: Generative AI for Software Developer (ฉบับ 5 วัน ปี 2026)**
**จัดอบรมให้: ธนาคารการค้าต่างประเทศลาว มหาชน (BCEL)**
**วันที่ 3: สร้าง Prototype/UI ด้วย AI, Chatbot RAG เบื้องต้น, AI Testing และแนวปฏิบัติที่ดี**
วันที่: 22 กรกฎาคม 2569 (2026) | เวลา 09:30-16:30 น. | Onsite Workshop
ผู้สอน: อ.สามิตร โกยม | IT Genius Engineering Co., Ltd.

---

## 🎯 วัตถุประสงค์การเรียนรู้ประจำวัน

เมื่อจบการอบรมวันที่ 3 ผู้เรียนจะสามารถ:

1. ใช้ AI สร้าง UI และเว็บ Prototype จาก Prompt ด้วย HTML/Tailwind และเครื่องมือ v0/Lovable/Bolt แล้ว Deploy ขึ้น hosting จริง
2. อธิบายแนวคิด RAG และสร้าง Chatbot ตอบคำถามจากเอกสารภายในแบบเบื้องต้น (ปูพื้นสู่ RAG ระดับ Production วันที่ 4)
3. ใช้ AI เขียน Unit/Integration Test สร้างข้อมูลทดสอบ และทำ Spec-driven Development
4. เชื่อม AI เข้ากับกระบวนการ Automation/CI-CD และวัดคุณภาพงานที่ AI สร้าง
5. เข้าใจแนวปฏิบัติที่ดี ความปลอดภัย ลิขสิทธิ์ และธรรมาภิบาลการใช้ AI (AI Governance) ในงานพัฒนา
6. ลงมือสร้าง Web App/UI ขึ้น hosting, สร้าง RAG Chatbot เบื้องต้น และรวบรวม Prompt/Context Library ของทีม (Workshop Day 3)

> **หมายเหตุ:** วันนี้เป็น "สะพาน" ระหว่างการเป็นผู้ใช้ AI (วันที่ 1-2) กับการเป็นผู้สร้างระบบ AI (วันที่ 4-5) หัวข้อ RAG เบื้องต้นวันนี้จะถูกต่อยอดเป็น RAG ที่เขียนโค้ด Python เองในวันพรุ่งนี้

---

## 🧭 กำหนดการวันที่ 3 (โดยสังเขป)

| เวลา | หัวข้อ |
| ----------- | ------------------------------------------------------------ |
| 09:30-09:45 | ทบทวนวันที่ 2 + เปิดประเด็นวันที่ 3 |
| 09:45-11:00 | **Module 8** AI Prototyping & UI Generation |
| 11:00-11:15 | พักเบรก |
| 11:15-12:00 | **Module 9** AI-powered Chatbot, RAG & Assistant (เบื้องต้น) |
| 12:00-13:00 | พักกลางวัน |
| 13:00-14:15 | **Module 10** AI Testing, Automation & Spec-driven Development |
| 14:15-15:00 | **Module 11** Best Practices, Security & Governance |
| 15:00-15:15 | พักเบรก |
| 15:15-16:30 | **Workshop Day 3** สร้าง Web App + Deploy, RAG Chatbot, Prompt Library |

---

## 🔁 ทบทวนวันที่ 2 (09:30-09:45)

> เมื่อวานเราใช้ Agent สร้าง API ต่อ MCP และรีวิวโค้ด วันนี้เราจะเร่งความเร็วช่วง "สร้างของให้เห็นผลไว" ตั้งแต่ UI Prototype ไปจนถึง Chatbot ที่ตอบจากเอกสารของเราเอง และปิดท้ายด้วยแนวปฏิบัติที่ทำให้ใช้ AI ได้อย่างปลอดภัยและมีธรรมาภิบาล

---

## 📚 Module 8: AI Prototyping & UI Generation

### เวลา 09:45-11:00 น.

> 💡 **หัวใจของ Module นี้:** สมัยก่อนกว่าจะได้ prototype ที่จับต้องได้ใช้เวลาเป็นวัน ปี 2026 เราพิมพ์ prompt แล้วได้ UI ที่คลิกได้ในไม่กี่นาที ทำให้ "คุยกันด้วยของจริง" ได้เร็วขึ้นมาก แต่ต้องรู้ทันข้อจำกัดเพื่อไม่หลงคิดว่า prototype = production

---

### 8.1 สร้าง UI ด้วย AI: HTML, Tailwind CSS และ Component

แนวทางที่เร็วและคุมได้ดีคือให้ AI สร้าง UI เป็น **HTML + Tailwind CSS** (utility-first) เพราะ:

- ได้ผลลัพธ์เป็นไฟล์เดียวเปิดดูได้ทันที ไม่ต้อง build
- Tailwind ทำให้ AI จัดสไตล์ได้สม่ำเสมอผ่าน class มาตรฐาน
- แก้/ต่อยอดง่าย และย้ายเข้าเฟรมเวิร์ก (React/Vue) ภายหลังได้

**ตัวอย่าง Prompt:** "สร้างหน้า Dashboard สรุปยอดธุรกรรมด้วย HTML + Tailwind (CDN) มี card สรุป 4 ตัว, ตารางรายการล่าสุด และกราฟ placeholder จัด layout แบบ responsive โทนสีสุภาพเหมาะกับธนาคาร"

> 💡 **เทคนิคคุมคุณภาพ UI:** ระบุ "โทนสี, ระยะห่าง, ฟอนต์, ความ responsive และตัวอย่างข้อมูล" ให้ชัด ยิ่งบอกละเอียด AI ยิ่งสร้างตรงใจ และขอให้แยกส่วนที่ต้องแก้บ่อยออกมาชัด ๆ

### 8.2 เครื่องมือสร้างเว็บ/UI จาก Prompt ปี 2026

| เครื่องมือ | ลักษณะ | เหมาะกับ |
| --- | --- | --- |
| **v0 (Vercel)** | สร้าง React/Tailwind component จาก prompt | UI component คุณภาพสูง ต่อ Next.js |
| **Lovable** | สร้าง full-stack web app จาก prompt | MVP ที่มี backend/DB เบื้องต้น |
| **Bolt (StackBlitz)** | สร้าง+รันโปรเจกต์ในเบราว์เซอร์ | prototype เต็มรูปแบบ แก้โค้ดสด |
| **Framer AI** | สร้างเว็บ/landing page เชิงดีไซน์ | หน้า marketing, landing |

> 📌 เครื่องมือกลุ่มนี้เหมาะกับ **prototype และ internal tool** มาก แต่โค้ดที่ได้ต้องอ่าน/ปรับ/ทดสอบก่อนใช้จริง โดยเฉพาะเรื่อง security และการต่อกับระบบภายในธนาคาร

### 8.3 Generate และ Deploy เว็บขึ้น Hosting จริง

ให้เห็นผลจริง เราจะ deploy prototype ขึ้น hosting ฟรีที่ตั้งค่าง่าย:

| แพลตฟอร์ม | เหมาะกับ | วิธี Deploy ที่ง่ายที่สุด |
| --- | --- | --- |
| **GitHub Pages** | เว็บ static (HTML/CSS/JS) | push ขึ้น repo แล้วเปิด Pages |
| **Vercel** | static + Next.js/serverless | เชื่อม repo แล้ว auto-deploy |
| **Netlify** | static + serverless functions | ลากโฟลเดอร์วาง หรือเชื่อม repo |

```text
Flow มาตรฐาน (static site):
สร้าง UI ด้วย AI ──▶ ทดสอบในเครื่อง ──▶ push ขึ้น GitHub ──▶ เปิด GitHub Pages/Vercel
                                                              │
                                                              ▼
                                                    ได้ URL สาธารณะ คลิกดูได้จริง
```

### 8.4 ปรับแต่งและต่อยอดโค้ดที่ AI สร้าง

โค้ดจาก AI คือ "จุดเริ่มต้นที่ดี" ไม่ใช่ "ของเสร็จ" เช็คลิสต์ก่อนนำไปใช้ต่อ:

```text
[ ] อ่านเข้าใจทุกส่วน (ไม่ใช้โค้ดที่อ่านไม่ออก)
[ ] ลบส่วนที่ไม่ใช้ / dependency เกินจำเป็น
[ ] ตรวจ accessibility เบื้องต้น (contrast, alt, keyboard)
[ ] ตรวจ security (ไม่มี key ฝัง, ไม่ trust input ดิบ)
[ ] แยก config/ข้อมูลออกจาก UI ให้แก้ง่าย
```

---

## 📚 Module 9: AI-powered Chatbot, RAG & Assistant (เบื้องต้น)

### เวลา 11:15-12:00 น.

> 💡 **หัวใจของ Module นี้:** LLM รู้เรื่องทั่วไป แต่ไม่รู้ "เอกสารภายในองค์กรเรา" RAG คือเทคนิคให้ AI ตอบโดยอ้างอิงจากเอกสารของเรา ทำให้ได้ chatbot ที่แม่นและตรวจสอบที่มาได้ วันนี้เข้าใจแนวคิด+ทำแบบ no/low-code พรุ่งนี้เขียนเองด้วย Python

---

### 9.1 ทำไมต้อง RAG และมันแก้ปัญหาอะไร

| ปัญหาของ LLM ล้วน ๆ | RAG แก้อย่างไร |
| --- | --- |
| ไม่รู้ข้อมูลภายในองค์กร | ดึงเอกสารเราเข้าไปเป็นบริบทก่อนตอบ |
| Hallucination (มั่ว) | ตอบจากเอกสารจริง + อ้างอิงแหล่ง |
| ข้อมูลล้าสมัย (knowledge cutoff) | อัปเดตเอกสารได้โดยไม่ต้องเทรนใหม่ |
| ข้อมูลลับเทรนลงโมเดลไม่ได้ | เก็บข้อมูลแยก ดึงมาใช้ตอน query |

### 9.2 RAG ทำงานอย่างไร (ภาพรวม)

```text
    ── ตอนเตรียมข้อมูล (ทำครั้งเดียว/เป็นระยะ) ──
เอกสาร ──▶ ตัดเป็นชิ้น ──▶ แปลงเป็นเวกเตอร์ ──▶ เก็บใน
(PDF/docs)   (Chunk)      (Embedding)        Vector DB

    ── ตอนผู้ใช้ถาม (Runtime) ──
คำถาม ──▶ แปลงเป็นเวกเตอร์ ──▶ ค้นชิ้นที่ใกล้เคียงสุด ──▶ ส่งคำถาม+ชิ้นที่เจอ
                                (Retrieve)              ให้ LLM สรุปตอบ + อ้างอิง
```

องค์ประกอบสำคัญที่จะลงลึกวันพรุ่งนี้: **Chunking** (ตัดเอกสาร), **Embedding** (แปลงความหมายเป็นเวกเตอร์), **Vector Database** (เก็บ+ค้นด้วยความคล้าย), **Retrieval + Generation** (ค้นแล้วให้ LLM ตอบ)

### 9.3 สร้าง Chatbot จากเอกสารแบบเบื้องต้น (No/Low-code)

วันนี้เราทำแบบเข้าใจง่ายก่อน เพื่อเห็นภาพก่อนลงโค้ด:

```text
วิธีที่ 1 (ง่ายสุด - Project/Custom GPT):
  อัปโหลดเอกสารเข้า Claude Project หรือ Custom GPT
  → ตั้ง System Prompt ให้ตอบเฉพาะจากเอกสาร + อ้างอิง
  → ได้ FAQ Bot เบื้องต้นทันที (เหมาะทดลอง/ภายในทีมเล็ก)

วิธีที่ 2 (ควบคุมได้มากขึ้น):
  ใช้ platform ที่มี RAG ในตัว อัปโหลดเอกสาร ตั้งค่า retrieval
  → ได้ chatbot ที่ฝังในเว็บได้
```

**ตัวอย่าง System Prompt สำหรับ FAQ Bot ที่ลด Hallucination:**

```text
คุณคือผู้ช่วยตอบคำถามพนักงาน ตอบโดยอ้างอิง "เฉพาะ" จากเอกสารที่ให้เท่านั้น
- ถ้าคำตอบไม่มีในเอกสาร ให้ตอบว่า "ไม่พบข้อมูลนี้ในเอกสาร กรุณาติดต่อฝ่าย X"
- อ้างอิงชื่อเอกสาร/หัวข้อที่ใช้ตอบทุกครั้ง
- ห้ามเดาหรือเติมข้อมูลจากความรู้ทั่วไป
```

### 9.4 Coding Assistant และ FAQ Bot สำหรับทีม

นอกจากตอบลูกค้า RAG ยังทำ "ผู้ช่วยภายใน" ได้ดี เช่น bot ตอบจาก coding standard/เอกสารสถาปัตยกรรมของทีม, bot ตอบ policy ภายใน, bot ช่วย onboard สมาชิกใหม่ ทั้งหมดนี้ต่อยอดเป็นระบบจริงด้วยโค้ดในวันที่ 4

> ✅ **ปูพื้นสู่วันที่ 4:** วันนี้เราเห็นว่า RAG "มีค่าอย่างไร" พรุ่งนี้เราจะเปิดฝากระโปรงดูข้างใน เขียน Python ทำ Chunk → Embed → Store → Retrieve → Generate เองทีละขั้น

---

## 📚 Module 10: AI Testing, Automation & Spec-driven Development

### เวลา 13:00-14:15 น.

> 💡 **หัวใจของ Module นี้:** AI เขียนโค้ดเร็วขึ้น แต่ "เร็วโดยไม่มีเทสต์" คืออันตราย เทสต์คือตาข่ายที่ทำให้ปล่อย AI ทำงานได้อย่างมั่นใจ และ Spec-driven Development คือการ "เขียนสเปกให้ชัดก่อน แล้วให้ AI สร้าง+ตรวจตามสเปก"

---

### 10.1 ใช้ AI เขียน Unit Test และ Integration Test

AI เก่งเรื่องเขียนเทสต์ เพราะเทสต์มีรูปแบบชัดและครอบเคสได้เป็นระบบ

| ประเภทเทสต์ | ตรวจอะไร | AI ช่วยอย่างไร |
| --- | --- | --- |
| **Unit Test** | ฟังก์ชัน/หน่วยเล็ก | สร้างเคส happy path + edge case + error |
| **Integration Test** | หลายส่วนทำงานร่วมกัน | จำลองการเรียก API/DB, ตรวจ flow |
| **Test Data** | ข้อมูลตัวอย่าง | สร้างข้อมูลจำลองหลากหลาย ครอบ boundary |

**ตัวอย่าง Prompt เขียนเทสต์ที่ดี:**

```text
เขียน unit test สำหรับฟังก์ชัน calculateInterest(principal, rate, days)
- ครอบ: happy path, ค่า 0, ค่าติดลบ (ควร throw), ทศนิยม, ค่ามากผิดปกติ
- ใช้ pytest (หรือ Jest/Vitest ตาม stack)
- ตั้งชื่อ test สื่อความหมาย + คอมเมนต์ว่าแต่ละเคสตรวจอะไร
- อย่าแก้โค้ดต้นฉบับ ถ้าเจอว่าโค้ดมีบั๊กให้ระบุแยกไว้
```

> ⚠️ **จุดพลาดที่พบบ่อย:** AI อาจเขียนเทสต์ให้ "ผ่านตามโค้ดที่มีบั๊ก" (เทสต์ยืนยันพฤติกรรมผิด) ต้องอ่านเทสต์ว่ามัน "ตรวจสิ่งที่ถูกต้อง" ไม่ใช่แค่ "ทำให้เขียว"

### 10.2 Spec-driven Development

แทนที่จะสั่งลอย ๆ เราเขียน **สเปก (Specification)** ให้ชัดก่อน แล้วให้ AI สร้างและตรวจงานตามสเปก ทำให้ผลลัพธ์คาดเดาได้และตรวจสอบได้

```text
วิธีเดิม (Vibe):              Spec-driven:
"เขียนฟังก์ชันคำนวณดอกเบี้ย"    1. เขียน spec: input/output/rule/edge case ชัดเจน
      │                       2. ให้ AI สร้างโค้ด + test ตาม spec
      ▼                       3. รัน test ยืนยันว่าตรง spec
ได้บ้างไม่ได้บ้าง ตรวจยาก        4. spec = สัญญาที่ตรวจสอบได้
```

**ตัวอย่างโครงสเปก:**

```markdown
## Spec: calculateInterest
- Input: principal (number > 0), rate (0-100), days (int >= 0)
- Output: number ปัดเศษ 2 ตำแหน่ง
- Rule: interest = principal * (rate/100) * (days/365)
- Edge: principal <= 0 → throw Error("invalid principal")
- Edge: days = 0 → return 0
```

> ✅ **ทำไมได้ผล:** สเปกทำให้ทั้งคนและ AI เข้าใจตรงกันว่า "เสร็จ" คืออะไร ลดการตีความผิด และใช้เป็นเกณฑ์ตรวจงาน AI ได้ตรง ๆ

### 10.3 เชื่อม AI เข้ากับ CI/CD และ Automation

AI แทรกเข้ากระบวนการอัตโนมัติได้หลายจุด:

```text
Developer push ──▶ CI Pipeline
                    ├─ AI ช่วย review PR อัตโนมัติ (คอมเมนต์จุดเสี่ยง)
                    ├─ รัน test ที่ AI ช่วยเขียน
                    ├─ AI สรุป changelog จาก commit
                    └─ AI ตรวจ security เบื้องต้น
                          │
                          ▼
                    ผ่าน ──▶ Deploy (มนุษย์อนุมัติจุดสำคัญ)
```

> ⚠️ ในงานธนาคาร ให้ AI เป็น "ผู้ช่วยเสนอ" ในไปป์ไลน์ แต่จุดอนุมัติ merge/deploy ต้องเป็นมนุษย์เสมอ

### 10.4 วัดคุณภาพและความถูกต้องของงานที่ AI สร้าง

อย่าเชื่อว่า "AI ทำแล้วถูก" ให้วัดด้วยตัวชี้วัดจริง: test coverage, ผลรัน test, ผลรัน linter/type-check, และการรีวิวโดยมนุษย์ หลักคือ "ทุกอย่างที่ AI อ้างว่าทำได้ ต้องพิสูจน์ได้ด้วยการรัน"

---

## 📚 Module 11: Best Practices, Security & Governance

### เวลา 14:15-15:00 น.

> 💡 **หัวใจของ Module นี้:** ใช้ AI ให้เร็วนั้นง่าย แต่ใช้ให้ "ปลอดภัยและถูกต้องตามหลักธรรมาภิบาล" คือสิ่งที่แยกทีมมืออาชีพออกจากทีมทั่วไป โดยเฉพาะในองค์กรที่กำกับดูแลเข้มอย่างธนาคาร

---

### 11.1 เชื่อม AI เข้า Dev Lifecycle อย่างเป็นระบบ

```text
Plan ──▶ Build ──▶ Test ──▶ Review ──▶ Deploy
  │        │         │         │          │
 AI ช่วย   AI ช่วย    AI เขียน   AI review  มนุษย์
 ร่าง+     เขียน+     test+     ด่านแรก    อนุมัติ
 ออกแบบ    refactor  gen data              (จุดสำคัญ)
  └──────── มนุษย์กำกับและรับผิดชอบทุกขั้น ────────┘
```

### 11.2 ข้อควรระวังด้านความปลอดภัยและข้อมูล

| ประเด็น | ความเสี่ยง | แนวปฏิบัติ |
| --- | --- | --- |
| **Data Privacy** | ข้อมูลลับหลุดเข้า AI สาธารณะ | ห้ามวางข้อมูลจริง/PII, ใช้ enterprise plan ที่ไม่เก็บ log, หรือรันโมเดลเอง |
| **Secret ในโค้ด** | AI สร้างโค้ดฝัง key | ใช้ env/secret manager, สแกน secret ก่อน commit |
| **Hallucination** | AI มั่ว API/logic | verify ด้วยการรัน + test เสมอ |
| **Insecure code** | AI สร้างโค้ดมีช่องโหว่ | AI code review + human review ด้านความปลอดภัย |
| **Supply chain** | AI แนะนำ package แปลก/อันตราย | ตรวจ dependency ก่อนติดตั้ง |

### 11.3 ลิขสิทธิ์และ License ของโค้ด

- โค้ดที่ AI สร้างอาจคล้ายโค้ดที่มี license เข้มงวด ควรตรวจสอบก่อนใช้ในเชิงพาณิชย์
- ตรวจ license ของ dependency ที่ AI แนะนำ (MIT/Apache ใช้ได้กว้าง, GPL มีเงื่อนไข)
- เก็บหลักฐานว่าโค้ดสำคัญผ่านการรีวิวโดยมนุษย์ เพื่อความรับผิดชอบและ audit

> 📌 **สำหรับองค์กร:** ควรมีนโยบายชัดว่า "งานส่วนไหนใช้ AI ได้ ระดับข้อมูลใดห้ามป้อน และใครรับผิดชอบผลลัพธ์" นี่คือหัวใจของ AI Governance

### 11.4 AI Governance และความรับผิดชอบของนักพัฒนา

```text
เสาหลักของ AI Governance ในทีมพัฒนา:
┌────────────────────────────────────────────────────┐
│ 1. Policy    - ใช้ AI ตัวไหนได้ กับข้อมูลระดับใด       │
│ 2. Guardrails - AGENTS.md, สิทธิ์ least-privilege     │
│ 3. Review    - มนุษย์ตรวจงานสำคัญเสมอ (accountability)│
│ 4. Audit     - บันทึกว่าใครใช้ AI ทำอะไร ตรวจย้อนได้   │
│ 5. Training  - ทีมเข้าใจทั้งพลังและข้อจำกัดของ AI      │
└────────────────────────────────────────────────────┘
```

### 11.5 สร้าง Prompt/Context Library ของทีม

Prompt ที่ใช้ได้ผลควร "เก็บเป็นสินทรัพย์ทีม" ไม่ใช่จำในหัวคนเดียว

```text
โครงสร้าง Prompt Library ที่แนะนำ:
prompts/
├── code-review.md      - prompt รีวิวโค้ดมาตรฐานทีม
├── write-tests.md      - prompt เขียน test
├── refactor.md         - prompt refactor ปลอดภัย
├── explain-legacy.md   - prompt อธิบายโค้ดเก่า
└── design-api.md       - prompt ออกแบบ API
```

> ✅ Prompt Library + `AGENTS.md` = "ความรู้การใช้ AI ของทีม" ที่ทำให้ทุกคนใช้ AI ได้คุณภาพเท่ากัน และ onboard คนใหม่ได้เร็ว

---

## 🛠️ Workshop Day 3 - Web App + Deploy, RAG Chatbot และ Prompt Library

### เวลา 15:15-16:30 น.

> **เป้าหมาย:** ให้ผู้เรียนได้ prototype ที่ deploy ขึ้นเน็ตจริง, chatbot ที่ตอบจากเอกสารของตัวเอง และเริ่มต้น Prompt Library ของทีม

---

### 🧪 Lab 3.1 - สร้าง Web App/UI ด้วย Prompt แล้ว Deploy จริง

**โจทย์:** สร้างหน้าเว็บ "เครื่องมือภายใน" อย่างง่าย (เลือกเอง เช่น หน้าคำนวณดอกเบี้ยเงินฝาก, หน้า Dashboard สรุปข้อมูล, หรือ Landing page ของทีม)

```text
ขั้นที่ 1  ใช้ AI สร้าง UI ด้วย HTML + Tailwind (หรือ v0/Bolt)
           ระบุโทนสี layout responsive และข้อมูลตัวอย่างให้ชัด
ขั้นที่ 2  เปิดดูในเครื่อง ปรับแต่งจนพอใจ (ตรวจ checklist หัวข้อ 8.4)
ขั้นที่ 3  push ขึ้น GitHub แล้วเปิด GitHub Pages / Vercel
ขั้นที่ 4  ได้ URL สาธารณะ ทดสอบเปิดจากมือถือ
```

> ✅ **ผลลัพธ์ที่คาดหวัง:** มี URL เว็บที่คลิกดูได้จริง และเข้าใจว่าจาก prompt ถึง production ใช้เวลาไม่ถึงชั่วโมง

### 🧪 Lab 3.2 - สร้าง RAG Chatbot เบื้องต้น

**โจทย์:** สร้าง FAQ Bot ตอบจากเอกสารชุดเล็ก (เช่น คู่มือพนักงานจำลอง, coding standard ของทีม, หรือเอกสารที่วิทยากรแจก)

```text
ขั้นที่ 1  รวบรวมเอกสาร 3-5 ไฟล์ (ข้อมูลจำลอง ไม่ใช่ข้อมูลจริงของธนาคาร)
ขั้นที่ 2  อัปโหลดเข้า Claude Project / Custom GPT
ขั้นที่ 3  ตั้ง System Prompt ให้ตอบเฉพาะจากเอกสาร + อ้างอิงแหล่ง (หัวข้อ 9.3)
ขั้นที่ 4  ทดสอบถาม: คำถามที่มีคำตอบ, คำถามที่ไม่มีคำตอบ (ต้องตอบว่าไม่พบ),
           คำถามกำกวม สังเกตว่ามัน hallucinate ไหม
```

> 💡 **จุดสังเกต:** บันทึกว่า bot ตอบผิด/มั่วตรงไหน เพื่อเข้าใจว่าทำไมพรุ่งนี้เราต้องคุม chunking, retrieval และ citation เองด้วยโค้ด

### 🛠️ Workshop หลัก - เริ่มต้น Prompt/Context Library ของทีม

รวบรวม Prompt ที่ใช้ได้ผลจากวันที่ 1-3 เป็นไลบรารีตามโครงหัวข้อ 11.5 อย่างน้อย 4 ไฟล์:

```text
[ ] code-review.md   - พร้อม checklist ความรุนแรง
[ ] write-tests.md   - ครอบ edge case + ห้ามแก้ต้นฉบับ
[ ] refactor.md      - เปลี่ยนโครงสร้างไม่เปลี่ยนพฤติกรรม
[ ] design-api.md    - ออกแบบ API + OpenAPI + diagram
```

แต่ละไฟล์ควรมี: จุดประสงค์, ตัว prompt, ตัวอย่าง input/output ที่ดี, และข้อควรระวัง

### 🧩 ความท้าทายเสริม (ถ้าทำเสร็จก่อนเวลา)

- เพิ่ม Spec-driven ลงงานจริง: เขียนสเปกฟังก์ชันหนึ่ง แล้วให้ AI สร้างโค้ด+test ตามสเปก
- ทดลองให้ AI เขียน GitHub Actions workflow ง่าย ๆ ที่รัน test อัตโนมัติเมื่อ push
- เติมส่วน "AI Usage Policy" สั้น ๆ ลงใน `AGENTS.md` ตามหลัก Governance หัวข้อ 11.4

---

## 📝 สรุปประจำวันที่ 3

| หัวข้อ | สิ่งที่ทำได้แล้ว |
| --- | --- |
| Module 8 - Prototyping/UI | สร้าง UI จาก prompt และ deploy ขึ้น hosting จริง |
| Module 9 - RAG เบื้องต้น | เข้าใจ RAG และทำ FAQ Bot ตอบจากเอกสาร + อ้างอิง |
| Module 10 - Testing/Spec | ใช้ AI เขียน test, ทำ Spec-driven และเชื่อม CI/CD |
| Module 11 - Best Practices | เข้าใจ Security, License และ AI Governance |
| ★ Workshop Day 3 | Web App ขึ้นเน็ต, RAG Chatbot และ Prompt Library ของทีม |

### ✅ ตรวจสอบความพร้อมก่อนวันพรุ่งนี้ (สำคัญ - วันที่ 4 เขียนโค้ด Python)

> ให้แน่ใจว่า:
>
> - ติดตั้ง **Python 3.11+** และตรวจด้วย `python --version` (หรือ `python3 --version`)
> - มี **API Key** อย่างน้อยหนึ่งค่าย (Anthropic / OpenAI / Gemini) พร้อมใช้
> - รู้จักการสร้าง virtual environment (`python -m venv`) และ `pip install`
> - เข้าใจแนวคิด RAG ระดับภาพรวมแล้ว (พรุ่งนี้ลงมือเขียนเอง)
> - มี Prompt Library เริ่มต้นและ `AGENTS.md` ที่ใช้ได้จริง

---

**💡 คำคมประจำวัน:**

> "AI ทำให้สร้างของได้เร็วขึ้นสิบเท่า แต่ความเร็วที่ไม่มีเทสต์และไม่มีธรรมาภิบาล คือหนี้ทางเทคนิคที่วิ่งเร็วขึ้นสิบเท่าเช่นกัน"

---

## 📖 References วันที่ 3

- Vercel v0: https://v0.dev/
- Lovable: https://lovable.dev/
- Bolt (StackBlitz): https://bolt.new/
- Tailwind CSS: https://tailwindcss.com/docs
- GitHub Pages: https://pages.github.com/
- Vercel Docs: https://vercel.com/docs
- Anthropic - Building Effective Agents: https://www.anthropic.com/research/building-effective-agents
- OWASP - Top 10 for LLM Applications: https://genai.owasp.org/

---

_เอกสารจัดทำโดย: อาจารย์สามิตร โกยม | IT Genius Engineering Co., Ltd._
_สำหรับการอบรม: ธนาคาร BCEL (สปป.ลาว)_
_หลักสูตร Generative AI for Software Developer (ฉบับ 5 วัน 2026) - วันที่ 3 จาก 5_
