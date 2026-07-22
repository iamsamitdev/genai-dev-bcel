# Workshop วันที่ 4: พัฒนา Mobile App ด้วย Claude Code + React Native (Expo)

**แอพที่สร้าง:** BCEL SaveGoal - แอพตั้งเป้าหมายออมเงิน (Savings Goal Tracker)
**ระยะเวลา:** ครึ่งวัน 3 ชั่วโมง (09:00 - 12:00)
**เทคโนโลยี:** React Native + Expo SDK 57, Expo Router, TypeScript, Mock Data (ไม่เชื่อมฐานข้อมูล)
**แนวคิดหลัก:** Design First ด้วย Claude Design → แปลง Design เป็น Spec → Build ด้วย Claude Code → ทดสอบบนมือถือจริงผ่าน Expo Go

---

## ภาพรวมแอพ BCEL SaveGoal

แอพออมเงินตามเป้าหมายขนาดเล็ก ใช้ brand BCEL (Navy `#202063`, Red `#EC1C24`, Gold `#FFDA00`) ประกอบด้วย 4 หน้าจอ:

| หน้าจอ | หน้าที่ |
|---|---|
| 1. Dashboard | ยอดออมรวมทั้งหมด + รายการเป้าหมายพร้อม Progress bar |
| 2. Add Goal | ฟอร์มสร้างเป้าหมายใหม่ (ชื่อ, จำนวนเงินเป้าหมาย, วันที่ครบกำหนด, ไอคอน) |
| 3. Goal Detail | รายละเอียดเป้าหมาย + ประวัติการฝากออม |
| 4. Add Deposit | ฟอร์มบันทึกยอดออมเข้าเป้าหมาย |

เหตุผลที่เลือกแอพนี้: ครอบคลุมแนวคิดสำคัญของ Mobile Dev ครบในเวลาจำกัด ได้แก่ Navigation หลายหน้า, Form input, List rendering, State management, การคำนวณและแสดงผล Progress โดยไม่ต้องยุ่งกับ Backend

---

## สิ่งที่ต้องเตรียมก่อนเริ่ม (แจ้งผู้เรียนล่วงหน้า)

1. Node.js LTS (แนะนำ v20 ขึ้นไป) - ตรวจสอบด้วย `node -v`
2. Claude Code ติดตั้งและ login แล้ว (ใช้มาแล้วจากวันที่ 3)
3. ติดตั้งแอพ **Expo Go** บนมือถือผู้เรียน (App Store / Play Store)
4. **สำคัญมาก:** คอมพิวเตอร์และมือถือต้องอยู่ใน Wi-Fi วงเดียวกัน (ถ้าติด Firewall องค์กร ให้เตรียม Hotspot สำรอง หรือใช้โหมด `--tunnel`)
5. VS Code (ไว้เปิดดูโค้ดที่ Claude สร้าง)

คำสั่งทดสอบความพร้อม (ให้ผู้เรียนรันก่อนเริ่ม):

```bash
node -v
npx expo --version
claude --version
```

---

## ตารางเวลา Workshop

| เวลา | กิจกรรม | เครื่องมือ |
|---|---|---|
| 09:00 - 09:15 (15 นาที) | Session 1: ภาพรวม React Native + Expo และ Workflow "Design → Spec → Build" | สไลด์/บรรยาย |
| 09:15 - 09:50 (35 นาที) | Session 2: ออกแบบ UI ทั้ง 4 หน้าจอด้วย Claude Design (BCEL brand) | Claude Design |
| 09:50 - 10:05 (15 นาที) | Session 3: แปลง Design เป็น DESIGN_SPEC.md + สร้าง CLAUDE.md | Claude |
| 10:05 - 10:15 (10 นาที) | พักเบรก | - |
| 10:15 - 10:30 (15 นาที) | Session 4: Scaffold โปรเจกต์ Expo + รันบน Expo Go ครั้งแรก | Terminal + Expo Go |
| 10:30 - 11:30 (60 นาที) | Session 5: Build แอพด้วย Claude Code (Prompt ทีละขั้น P1 - P4) | Claude Code |
| 11:30 - 11:50 (20 นาที) | Session 6: ทดสอบ ปรับแต่ง และ Challenge เสริม | Expo Go + Claude Code |
| 11:50 - 12:00 (10 นาที) | สรุปบทเรียน + Q&A | - |

---

## Session 1 (15 นาที): ภาพรวมและแนวคิด

ประเด็นที่บรรยาย:

1. React Native คืออะไร - เขียน React แล้วได้แอพ Native ทั้ง iOS และ Android จาก Codebase เดียว (ต่อยอดจากวันที่ 3 ที่เรียน React.js มาแล้ว - เน้นว่า concept เดียวกัน แต่เปลี่ยนจาก `<div>` เป็น `<View>`, `<p>` เป็น `<Text>`)
2. Expo คืออะไร - Framework และเครื่องมือที่ทำให้พัฒนา React Native ง่ายขึ้นมาก ไม่ต้องติดตั้ง Xcode/Android Studio ทดสอบผ่านแอพ Expo Go ได้ทันที (ปัจจุบันคือ Expo SDK 57 ใช้ React Native 0.86)
3. Workflow ของวันนี้: **Design First** - ออกแบบด้วย Claude Design ให้เห็นภาพก่อน → สรุปเป็น Spec เอกสาร → ให้ Claude Code สร้างตาม Spec → ทดสอบบนมือถือจริง
4. จุดขายของ workflow นี้: ลดการ "prompt มั่ว" เพราะมี Spec ชัดเจน Claude Code ทำงานแม่นยำขึ้นมาก

---

## Session 2 (35 นาที): ออกแบบ UI ด้วย Claude Design

### ขั้นตอน

1. เปิด Claude (Desktop/Web) ที่มี skill `bcel-design`
2. ใช้ Prompt D1 สร้าง mockup ทั้ง 4 หน้าจอ
3. ให้ผู้เรียนดูผลลัพธ์ แล้วฝึก iterate ด้วย Prompt D2 (ปรับแก้ design)
4. Export/Screenshot design เก็บไว้ใช้ต่อใน Session 3

### Prompt D1 - สร้าง Mockup (ให้ผู้เรียน copy ไปใช้)

```
ใช้ skill bcel-design ออกแบบ mockup แอพมือถือชื่อ "BCEL SaveGoal"
เป็นแอพตั้งเป้าหมายออมเงินของธนาคาร BCEL

สร้างเป็น HTML artifact แสดง 4 หน้าจอมือถือ (ขนาด 390x844) เรียงต่อกันในหน้าเดียว:

1. หน้า Dashboard
   - Header สี Navy มีโลโก้ BCEL ข้อความทักทาย และยอดออมรวมทุกเป้าหมาย (สกุลเงิน LAK)
   - รายการเป้าหมายออมเป็น Card แต่ละใบมี ไอคอน ชื่อเป้าหมาย
     ยอดปัจจุบัน/ยอดเป้าหมาย Progress bar สี Gold และจำนวนวันที่เหลือ
   - ปุ่ม Floating Action Button สี Red สำหรับเพิ่มเป้าหมายใหม่

2. หน้า Add Goal
   - ฟอร์ม: ชื่อเป้าหมาย, จำนวนเงินเป้าหมาย (LAK), วันที่ครบกำหนด,
     เลือกไอคอน (โทรศัพท์ รถ บ้าน เรียนต่อ ท่องเที่ยว ฉุกเฉิน)
   - ปุ่มบันทึกสี Navy เต็มความกว้าง

3. หน้า Goal Detail
   - แสดงเป้าหมายที่เลือก มี Progress วงกลมใหญ่ตรงกลาง เปอร์เซ็นต์ความคืบหน้า
   - ยอดปัจจุบัน ยอดเป้าหมาย ยอดคงเหลือที่ต้องออม
   - รายการประวัติการฝากออม (วันที่ + จำนวนเงิน)
   - ปุ่ม "ฝากออม" สี Red

4. หน้า Add Deposit
   - แสดงชื่อเป้าหมายที่กำลังฝาก
   - ช่องกรอกจำนวนเงิน ตัวเลขใหญ่ตรงกลาง
   - ปุ่มลัดจำนวนเงิน 50,000 / 100,000 / 500,000 LAK
   - ปุ่มยืนยันสี Navy

ใช้ mock data สมจริง เช่น เป้าหมาย "ซื้อ iPhone" "ท่องเที่ยวเวียงจันทน์" "เงินฉุกเฉิน"
ตัวเลขเป็นสกุลเงิน LAK มี comma คั่นหลักพัน
```

### Prompt D2 - ตัวอย่างการ Iterate (ให้ผู้เรียนลองปรับเอง 5-10 นาที)

```
ปรับ design ดังนี้
1. หน้า Dashboard เพิ่มการ์ดสรุปด้านบน แสดงจำนวนเป้าหมายทั้งหมดและเป้าหมายที่สำเร็จแล้ว
2. Progress bar ถ้าเกิน 80% ให้เปลี่ยนเป็นสีเขียว แสดงว่าใกล้สำเร็จ
3. หน้า Goal Detail เพิ่มข้อความให้กำลังใจใต้วงกลม Progress เช่น "อีกนิดเดียวก็ถึงเป้าแล้ว!"
```

จุดสอน (Teaching Point): เน้นให้ผู้เรียนเห็นว่าการ iterate design ตอนนี้ "ถูกมาก" เทียบกับไป iterate ตอนเขียนโค้ดแล้ว

---

## Session 3 (15 นาที): แปลง Design เป็น Spec

แนวคิด: Claude Code ทำงานได้ดีที่สุดเมื่อมีเอกสารกำกับ 2 ไฟล์ คือ `DESIGN_SPEC.md` (สเปคหน้าจอ) และ `CLAUDE.md` (กติกาของโปรเจกต์)

### Prompt D3 - สร้าง DESIGN_SPEC.md (พิมพ์ต่อในแชท Claude Design เดิม)

```
จาก mockup ที่ออกแบบเสร็จแล้ว ช่วยสรุปเป็นไฟล์ DESIGN_SPEC.md
สำหรับส่งต่อให้ AI coding agent นำไปสร้างแอพ React Native Expo โดยระบุ:

1. Design Tokens: สี (hex ทุกสี), ฟอนต์, ขนาดตัวอักษร, border radius, spacing
2. โครงสร้างข้อมูล (Data Model) ของ Goal และ Deposit เป็น TypeScript interface
3. รายละเอียดแต่ละหน้าจอ: components ที่ใช้, layout, การจัดวาง, behavior
4. Navigation flow ระหว่างหน้าจอ
5. Mock data ตัวอย่างอย่างน้อย 3 เป้าหมาย

เขียนเป็นภาษาอังกฤษ เพราะจะใช้เป็น technical spec
```

ให้ผู้เรียนบันทึกผลลัพธ์เป็นไฟล์ `DESIGN_SPEC.md` เตรียมไว้ (เดี๋ยวนำไปวางในโปรเจกต์หลัง scaffold เสร็จ)

จุดสอน: นี่คือหัวใจของ workshop - "Design ที่ดี + Spec ที่ชัด = Prompt ที่สั้นลงและผลลัพธ์ที่แม่นยำขึ้น"

---

## Session 4 (15 นาที): Scaffold โปรเจกต์ Expo

### ขั้นตอน (ทำพร้อมกันทั้งห้อง)

```bash
# 1. สร้างโปรเจกต์ (เลือก template default ซึ่งเป็น TypeScript + Expo Router อยู่แล้ว)
npx create-expo-app@latest bcel-savegoal

cd bcel-savegoal

# 2. ล้างโค้ดตัวอย่างออกให้เหลือโครงเปล่า (คำสั่งของ Expo เอง)
npm run reset-project

# 3. รัน dev server
npx expo start
```

4. เปิดแอพ Expo Go บนมือถือ → สแกน QR Code จาก Terminal → ต้องเห็นหน้าจอเปล่าของแอพ

### ปัญหาที่พบบ่อย (เตรียมรับมือ)

| อาการ | วิธีแก้ |
|---|---|
| มือถือสแกน QR แล้วเชื่อมไม่ได้ | ตรวจว่าอยู่ Wi-Fi เดียวกัน ถ้าไม่ได้ให้รัน `npx expo start --tunnel` |
| Expo Go แจ้ง SDK version ไม่ตรงกัน | อัปเดตแอพ Expo Go ให้เป็นเวอร์ชันล่าสุด (รองรับ SDK 57) |
| แก้โค้ดแล้วหน้าจอไม่เปลี่ยน | กด `r` ใน Terminal เพื่อ reload หรือรัน `npx expo start -c` ล้าง cache |

### วางไฟล์ Spec เข้าโปรเจกต์

ให้ผู้เรียนนำ `DESIGN_SPEC.md` จาก Session 3 มาวางไว้ที่ root ของโปรเจกต์ `bcel-savegoal/`

---

## Session 5 (60 นาที): Build ด้วย Claude Code

เปิด Claude Code ในโฟลเดอร์โปรเจกต์:

```bash
cd bcel-savegoal
claude
```

### Prompt P0 - สร้าง CLAUDE.md (5 นาที)

```
สร้างไฟล์ CLAUDE.md สำหรับโปรเจกต์นี้ โดยมีกติกาดังนี้

- แอพนี้คือ BCEL SaveGoal แอพตั้งเป้าหมายออมเงิน อ่านรายละเอียดทั้งหมดจาก DESIGN_SPEC.md
- ใช้ TypeScript ทั้งหมด และไม่ต้องใส่ semicolon
- ใช้ Expo Router (file-based routing ในโฟลเดอร์ app/)
- ใช้เฉพาะ component พื้นฐานของ React Native ไม่ติดตั้ง UI library เพิ่ม
- ใช้ React Context + useState สำหรับ state ไม่ใช้ state library อื่น
- ข้อมูลเป็น mock data ในหน่วยความจำ ไม่เชื่อมต่อ API หรือฐานข้อมูล
- สี ฟอนต์ ขนาดต่างๆ ให้อ้างจาก Design Tokens ใน DESIGN_SPEC.md เท่านั้น
  ห้าม hardcode สีกระจายตามไฟล์ ให้รวมไว้ที่ constants/theme.ts
- ตัวเลขเงินแสดงสกุล LAK มี comma คั่นหลักพัน สร้าง helper formatCurrency ไว้ใช้ร่วมกัน
- โค้ดทุกไฟล์ต้องมี comment ภาษาไทยอธิบายส่วนสำคัญ เพราะใช้ในการเรียนการสอน
```

จุดสอน: อธิบายว่า CLAUDE.md คือ "กติกาประจำโปรเจกต์" ที่ Claude Code อ่านทุกครั้งก่อนทำงาน เหมือน brief ที่ให้ทีมพัฒนา

### Prompt P1 - Theme + Data Layer (10 นาที)

```
อ่าน DESIGN_SPEC.md แล้วทำขั้นแรก 3 อย่าง

1. สร้าง constants/theme.ts รวม Design Tokens ทั้งหมด (สี ฟอนต์ spacing radius)
2. สร้าง types/goal.ts ตาม Data Model ใน spec
3. สร้าง context/GoalContext.tsx เก็บ state ของเป้าหมายทั้งหมด
   พร้อม mock data 3 เป้าหมายจาก spec และฟังก์ชัน addGoal, addDeposit
   แล้ว wrap Provider ใน app/_layout.tsx

ยังไม่ต้องสร้างหน้าจอ ทำแค่นี้ก่อน เสร็จแล้วอธิบายสั้นๆ ว่าสร้างไฟล์อะไรบ้าง
```

จุดสอน: ชี้ให้เห็นเทคนิค "แบ่ง prompt เป็นชั้น" - วาง foundation ก่อนแล้วค่อยสร้างหน้าจอ ผลลัพธ์เสถียรกว่าสั่งทำทั้งแอพใน prompt เดียว

### Prompt P2 - หน้า Dashboard (15 นาที)

```
สร้างหน้า Dashboard ที่ app/index.tsx ตาม DESIGN_SPEC.md

- Header สี Navy: ข้อความทักทาย + ยอดออมรวมทุกเป้าหมาย
- การ์ดสรุป: จำนวนเป้าหมายทั้งหมด / สำเร็จแล้ว
- FlatList แสดงการ์ดเป้าหมาย แยกเป็น component components/GoalCard.tsx
  แต่ละใบมี ไอคอน ชื่อ ยอดปัจจุบัน/เป้าหมาย Progress bar และวันที่เหลือ
  Progress เกิน 80% เปลี่ยนสีเป็นเขียว
- กดการ์ดแล้วไปหน้า /goal/[id]
- FAB สี Red มุมขวาล่าง กดแล้วไปหน้า /add-goal
- มี Empty state กรณีไม่มีเป้าหมาย

เสร็จแล้วบอกด้วยว่าต้อง reload อย่างไรเพื่อดูผลบนมือถือ
```

Checkpoint: ทุกคนต้องเห็นหน้า Dashboard พร้อม mock data บนมือถือของตัวเองก่อนไปต่อ

### Prompt P3 - Add Goal + Goal Detail (20 นาที)

```
สร้างอีก 2 หน้าตาม DESIGN_SPEC.md

1. app/add-goal.tsx - ฟอร์มสร้างเป้าหมาย
   - ชื่อเป้าหมาย, จำนวนเงินเป้าหมาย (คีย์บอร์ดตัวเลข), วันที่ครบกำหนด,
     ตัวเลือกไอคอน 6 แบบเป็นปุ่มกด
   - validate: ชื่อห้ามว่าง จำนวนเงินต้องมากกว่า 0
   - บันทึกแล้วกลับหน้า Dashboard และเห็นเป้าหมายใหม่ทันที

2. app/goal/[id].tsx - รายละเอียดเป้าหมาย
   - Progress วงกลมตรงกลาง แสดงเปอร์เซ็นต์ (วาดด้วย react-native-svg
     ถ้าต้องติดตั้งเพิ่มให้ใช้ npx expo install)
   - ยอดปัจจุบัน ยอดเป้าหมาย ยอดที่ยังขาด
   - ข้อความให้กำลังใจตามระดับ progress
   - รายการประวัติฝากออม เรียงล่าสุดขึ้นก่อน
   - ปุ่ม "ฝากออม" ไปหน้า /goal/[id]/deposit
```

### Prompt P4 - Add Deposit + เก็บรายละเอียด (10 นาที)

```
สร้างหน้าสุดท้าย app/goal/[id]/deposit.tsx

- แสดงชื่อเป้าหมาย ช่องกรอกจำนวนเงินตัวเลขใหญ่กลางจอ
- ปุ่มลัด 50,000 / 100,000 / 500,000 LAK กดแล้วบวกเพิ่มเข้าไปในช่อง
- ปุ่มยืนยัน: บันทึก deposit แล้วพากลับหน้า Goal Detail เห็นยอดอัปเดตทันที
- ถ้ายอดถึงเป้าหมาย ให้แสดง Alert แสดงความยินดี

จากนั้นตรวจทั้งแอพอีกรอบ: จัด spacing ให้ตรง DESIGN_SPEC.md,
ตรวจว่า formatCurrency ถูกใช้ทุกจุดที่แสดงตัวเลขเงิน
```

### Prompt Debug ตัวอย่าง (สอนแทรกเมื่อเจอปัญหาจริง)

```
เปิดแอพแล้วเจอ error นี้บนหน้าจอ Expo Go
[วาง error message]
ช่วยวิเคราะห์สาเหตุและแก้ไขให้
```

จุดสอน: ให้ผู้เรียนเห็นว่าการ debug คือการ "ส่งต่อ error ให้ Claude Code" ไม่ต้องกลัว error สีแดง

---

## Session 6 (20 นาที): ทดสอบ + Challenge เสริม

ให้ผู้เรียนทดสอบ flow ครบวงจร: สร้างเป้าหมายใหม่ → ฝากออม → ดูยอดอัปเดตบน Dashboard

### Challenge สำหรับคนที่เสร็จเร็ว (เลือกทำ 1 ข้อ ให้เขียน prompt เอง)

1. **Persist data** - ให้ข้อมูลไม่หายเมื่อปิดแอพ ด้วย `@react-native-async-storage/async-storage`
2. **Dark Mode** - สลับธีมมืด/สว่างตามการตั้งค่าเครื่อง
3. **แปลงภาษา** - เพิ่มปุ่มสลับภาษา ลาว/อังกฤษ
4. **Haptic + Animation** - สั่นเบาๆ เมื่อฝากเงินสำเร็จ และ animate progress bar

ตัวอย่าง prompt ของ Challenge 1 (เฉลยไว้ให้วิทยากร):

```
เพิ่มการบันทึกข้อมูลถาวรด้วย AsyncStorage
- ติดตั้งด้วย npx expo install @react-native-async-storage/async-storage
- ปรับ GoalContext ให้ load ข้อมูลตอนเปิดแอพ และ save ทุกครั้งที่ข้อมูลเปลี่ยน
- ถ้ายังไม่เคยมีข้อมูล ให้ seed ด้วย mock data เดิม
```

---

## สรุปบทเรียน (10 นาที)

ประเด็นที่ควรย้ำตอนปิด workshop:

1. Workflow "Design First → Spec → Build" ใช้ได้กับทุกโปรเจกต์ ไม่ใช่แค่ mobile
2. CLAUDE.md + DESIGN_SPEC.md คือเครื่องมือควบคุมคุณภาพงานของ AI
3. การแบ่ง prompt เป็นขั้น (foundation → หน้าจอ → polish) ได้ผลดีกว่า prompt เดียวจบ
4. ความรู้ React จากวันที่ 3 นำมาใช้ต่อได้เกือบทั้งหมด ต่างแค่ component พื้นฐานและ navigation
5. ขั้นต่อไปหากพัฒนาจริง: เชื่อม API, EAS Build เพื่อสร้างไฟล์ติดตั้งจริง, ขึ้น Store

---

## เอกสารอ้างอิง

- Expo Documentation - Get Started: https://docs.expo.dev/get-started/introduction/
- create-expo-app: https://docs.expo.dev/more/create-expo/
- Expo Router (file-based routing): https://docs.expo.dev/router/introduction/
- Expo SDK 57 Changelog: https://expo.dev/changelog
- React Native Core Components: https://reactnative.dev/docs/components-and-apis
- Claude Code Best Practices: https://www.anthropic.com/engineering/claude-code-best-practices
- Claude Code - Memory (CLAUDE.md): https://docs.claude.com/en/docs/claude-code/memory
- AsyncStorage: https://react-native-async-storage.github.io/async-storage/

