# Day 5 - Lab 1: Claude Code ทำงานกับฐานข้อมูล MySQL/MariaDB และ PostgreSQL ผ่าน MCP

**ฐานข้อมูลตัวอย่าง:** `seafoodstore` (ระบบร้านขายอาหารทะเล)
**ไฟล์ backup:** `exercise\Database\MySQL-Mariadb\seafoodstore_backup.sql` และ `exercise\Database\PostgreSQL\seafoodstore_backup.sql`
**เป้าหมาย:** ผู้เรียนติดตั้งฐานข้อมูลทั้ง 2 ตัว, import ข้อมูล, เชื่อม Claude Code ผ่าน MCP แล้วฝึกสั่งงานตั้งแต่สำรวจโครงสร้างไปจนสร้าง Report อัตโนมัติ

---

## ทำความรู้จักฐานข้อมูล seafoodstore

ทั้ง 2 ไฟล์เป็นข้อมูลชุดเดียวกัน (10 ตาราง ตารางละประมาณ 10 แถว) แต่ออกแบบโครงสร้างต่างกัน ซึ่งเป็นประเด็นสอนที่ดีมาก:

| กลุ่มข้อมูล | MySQL/MariaDB (prefix ในชื่อตาราง) | PostgreSQL (แยกเป็น schema) |
|---|---|---|
| ผู้ใช้ระบบ | `auth_users` | `auth.users` |
| พนักงาน | `hr_employees` | `hr.employees` |
| สต็อก | `inventory_stocks`, `inventory_stock_movements` | `inventory.stocks`, `inventory.stock_movements` |
| การขาย | `sales_customers`, `sales_orders`, `sales_order_items` | `sales.customers`, `sales.orders`, `sales.order_items` |
| สินค้า | `store_products`, `store_categories`, `store_suppliers` | `store.products`, `store.categories`, `store.suppliers` |

ความสัมพันธ์หลัก: `orders` → `order_items` → `products` → `categories`/`suppliers` และ `orders` → `customers` ทุกตารางมี soft delete (`deleted_at`)

ข้อมูลทางเทคนิคของไฟล์ (ตรวจสอบแล้ว):

- ไฟล์ MySQL: dump จาก MariaDB 10.4.32 (Win64) **encoding เป็น UTF-16 LE** ต้องแปลงเป็น UTF-8 ก่อน import ด้วย command line มิฉะนั้นจะเจอ error `ASCII '\0' appeared in the statement`
- ไฟล์ PostgreSQL: dump จาก pg_dump เวอร์ชัน 18.2 มีคำสั่ง `\restrict` ที่หัวไฟล์ **ต้อง restore ด้วย psql เวอร์ชัน 16.9/17.5/18 ขึ้นไป** จึงแนะนำให้ติดตั้ง PostgreSQL 18

---

## Part A: ติดตั้งฐานข้อมูล (ก่อนเริ่มหรือช่วงแรกของคลาส)

### A1. ติดตั้ง MariaDB (เลือกทางใดทางหนึ่ง)

**ทางเลือก 1 - XAMPP (ง่ายสุด แนะนำสำหรับคลาส):**

1. ดาวน์โหลด XAMPP จาก https://www.apachefriends.org/ (มาพร้อม MariaDB 10.4.x ตรงกับไฟล์ dump)
2. ติดตั้งแล้วเปิด XAMPP Control Panel → Start โมดูล **MySQL**
3. path ของ client อยู่ที่ `C:\xampp\mysql\bin` (แนะนำเพิ่มเข้า PATH)
4. ค่าเริ่มต้น: user `root` ไม่มีรหัสผ่าน port `3306`

**ทางเลือก 2 - MariaDB MSI Installer:**

1. ดาวน์โหลดจาก https://mariadb.org/download/ (เลือก MSI สำหรับ Windows)
2. ระหว่างติดตั้งให้ตั้งรหัสผ่าน root และติ๊ก "Use UTF8 as default server's character set"

ทดสอบ:

```cmd
mysql --version
mysql -u root -p -e "SELECT VERSION();"
```

### A2. ติดตั้ง PostgreSQL 18

1. ดาวน์โหลด installer (EDB) จาก https://www.postgresql.org/download/windows/
2. ติดตั้งแบบค่าเริ่มต้น ตั้งรหัสผ่านของ user `postgres` (ในคลาสให้ใช้รหัสเดียวกันทั้งห้อง เช่น `P@ssw0rd` เพื่อลดปัญหา) port `5432`
3. เพิ่ม `C:\Program Files\PostgreSQL\18\bin` เข้า PATH

ทดสอบ:

```cmd
psql --version
psql -U postgres -c "SELECT version();"
```

### A3. สร้างฐานข้อมูลและ Import - MariaDB

**ขั้นที่ 1: แปลง encoding ไฟล์จาก UTF-16 เป็น UTF-8** (ทำครั้งเดียว เปิด PowerShell ในโฟลเดอร์ `exercise\Database\MySQL-Mariadb`)

```powershell
Get-Content .\seafoodstore_backup.sql | Set-Content -Encoding UTF8 .\seafoodstore_utf8.sql
```

**ขั้นที่ 2: สร้างฐานข้อมูลและ import** (ใช้ Command Prompt ไม่ใช่ PowerShell เพราะ PowerShell ไม่รองรับ `<` redirect)

```cmd
mysql -u root -p -e "CREATE DATABASE seafoodstore CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
mysql -u root -p seafoodstore < seafoodstore_utf8.sql
```

**ขั้นที่ 3: ตรวจสอบ**

```cmd
mysql -u root -p seafoodstore -e "SHOW TABLES; SELECT COUNT(*) AS products FROM store_products;"
```

ต้องเห็น 10 ตาราง (auth_users, hr_employees, inventory_stock_movements, inventory_stocks, sales_customers, sales_order_items, sales_orders, store_categories, store_products, store_suppliers)

### A4. สร้างฐานข้อมูลและ Import - PostgreSQL

เปิด Command Prompt ในโฟลเดอร์ `exercise\Database\PostgreSQL`

```cmd
psql -U postgres -c "CREATE DATABASE seafoodstore;"
psql -U postgres -d seafoodstore -f seafoodstore_backup.sql
```

ตรวจสอบ:

```cmd
psql -U postgres -d seafoodstore -c "\dn"
psql -U postgres -d seafoodstore -c "SELECT schemaname, tablename FROM pg_tables WHERE schemaname IN ('auth','hr','inventory','sales','store') ORDER BY 1,2;"
```

ต้องเห็น 5 schemas และ 10 ตาราง

หมายเหตุ: ถ้าเจอ error `\restrict: invalid command` แปลว่า psql เวอร์ชันเก่าเกินไป ให้อัปเดต PostgreSQL client เป็นเวอร์ชัน 18 หรือแก้ขั่วคราวโดยลบบรรทัด `\restrict ...` ที่หัวไฟล์ออก

---

## Part B: เชื่อม Claude Code เข้ากับฐานข้อมูลผ่าน MCP

### B1. แนวคิด MCP ที่ต้องอธิบายก่อน (10 นาที)

MCP (Model Context Protocol) คือมาตรฐานกลางที่ให้ AI agent ต่อกับเครื่องมือภายนอก เปรียบเหมือน "USB-C ของ AI" - Claude Code ไม่ได้ต่อฐานข้อมูลเอง แต่คุยผ่าน MCP server ที่แปลงคำขอเป็น SQL query ให้

### B2. เพิ่ม MySQL MCP Server

ใช้แพ็กเกจ `@benborla29/mcp-server-mysql` (community ที่นิยมที่สุดสำหรับ MySQL/MariaDB)

เปิด terminal ในโฟลเดอร์โปรเจกต์สำหรับ workshop (เช่น `day5-database-lab`) แล้วรัน:

```cmd
claude mcp add mysql-seafood ^
  -e MYSQL_HOST=127.0.0.1 ^
  -e MYSQL_PORT=3306 ^
  -e MYSQL_USER=root ^
  -e MYSQL_PASS=รหัสผ่านของคุณ ^
  -e MYSQL_DB=seafoodstore ^
  -- npx -y @benborla29/mcp-server-mysql
```

(ถ้าใช้ XAMPP ที่ root ไม่มีรหัสผ่าน ให้ใส่ `-e MYSQL_PASS=` ว่างไว้)

ค่าเริ่มต้นของ server ตัวนี้เป็น **read-only** (อนุญาตเฉพาะ SELECT) ซึ่งเหมาะกับการสอนมาก ถ้าต้องการให้เขียนได้ให้เพิ่ม `-e ALLOW_INSERT_OPERATION=true` เป็นต้น

### B3. เพิ่ม PostgreSQL MCP Server

```cmd
claude mcp add postgres-seafood ^
  -- npx -y @modelcontextprotocol/server-postgres postgresql://postgres:รหัสผ่าน@localhost:5432/seafoodstore
```

หมายเหตุสำหรับวิทยากร: `@modelcontextprotocol/server-postgres` เป็น reference server ที่ถูก archive แล้วแต่ยังใช้งานผ่าน npx ได้ดีและเป็น read-only โดยธรรมชาติ เหมาะกับคลาส ถ้าต้องการตัวที่ maintain ต่อเนื่องและมีความสามารถวิเคราะห์เพิ่ม แนะนำ Postgres MCP Pro (https://github.com/crystaldba/postgres-mcp) ซึ่งรันด้วย Docker หรือ pipx

### B4. ตรวจสอบการเชื่อมต่อ

```cmd
claude mcp list
```

จากนั้นเปิด `claude` แล้วพิมพ์ `/mcp` ต้องเห็น server ทั้ง 2 ตัวสถานะ connected

จุดสอน: อธิบาย scope ของ MCP config (`local` เฉพาะเครื่อง+โปรเจกต์, `project` แชร์ผ่านไฟล์ `.mcp.json`, `user` ใช้ได้ทุกโปรเจกต์) และโชว์ไฟล์ `.mcp.json` ให้ดูว่าเก็บอะไร

---

## Part C: Prompts ฝึกทำงานกับฐานข้อมูล (เรียงจากง่ายไปยาก)

### C1. สำรวจโครงสร้าง (Discovery)

```
เชื่อมต่อ MySQL แล้วสำรวจฐานข้อมูล seafoodstore ให้หน่อย
มีตารางอะไรบ้าง แต่ละตารางเก็บอะไร มีความสัมพันธ์กันอย่างไร
สรุปเป็นแผนภาพ ER แบบ text และอธิบายเป็นภาษาไทย
```

```
ทำแบบเดียวกันกับ PostgreSQL แล้วเปรียบเทียบให้ดู
ว่าการออกแบบของ 2 ฐานข้อมูลนี้ต่างกันอย่างไร
(ใบ้ให้: ฝั่ง PostgreSQL ใช้ schema แยกกลุ่มงาน)
ข้อดีข้อเสียของแต่ละแบบคืออะไร
```

จุดสอน: ผู้เรียนจะเห็นว่า Claude เรียกใช้ MCP tool เพื่อยิง query สำรวจ `information_schema` เอง โดยเราไม่ต้องเขียน SQL แม้แต่บรรทัดเดียว

### C2. Query พื้นฐานด้วยภาษาธรรมชาติ

```
สินค้าตัวไหนขายดีที่สุด 5 อันดับแรก คิดจากจำนวนชิ้นที่ขายได้
แสดงชื่อสินค้า หมวดหมู่ จำนวนชิ้น และยอดเงินรวม
```

```
ลูกค้าคนไหนมียอดซื้อสะสมสูงสุด 3 อันดับ
และแต่ละคนซื้อสินค้าหมวดไหนบ่อยที่สุด
```

```
สินค้าตัวไหนมีสต็อกต่ำกว่า 50 ชิ้น ใครเป็น supplier ของสินค้านั้น
ต้องติดต่อที่ไหน
```

จุดสอน: หลังได้คำตอบ ให้ลองถามต่อว่า "โชว์ SQL ที่ใช้ให้ดูหน่อย พร้อมอธิบายทีละท่อน" - เทคนิคใช้ Claude Code เป็นครูสอน SQL ไปในตัว

### C3. ตรวจสอบคุณภาพข้อมูล (Data Quality Audit)

```
ช่วยตรวจสุขภาพข้อมูลฐาน seafoodstore บน PostgreSQL:
1. มี order ไหนที่ total_amount ไม่ตรงกับผลรวม quantity x unit_price ใน order_items หรือไม่
2. มีสินค้าที่ไม่เคยถูกขายเลยหรือไม่
3. มี foreign key ที่ชี้ไปหาข้อมูลที่ถูก soft delete (deleted_at ไม่เป็น null) หรือไม่
สรุปผลเป็นตารางพร้อมข้อเสนอแนะ
```

### C4. เปรียบเทียบข้าม 2 ฐานข้อมูล (ใช้ MCP 2 ตัวพร้อมกัน)

```
เปรียบเทียบข้อมูลระหว่าง MySQL และ PostgreSQL ว่าตรงกันหรือไม่
นับจำนวนแถวทุกตาราง และสุ่มเทียบยอด total_amount ของ orders ทั้งหมด
รายงานเป็นตารางเปรียบเทียบ ถ้าพบความต่างให้ระบุจุดที่ต่าง
```

จุดสอน: นี่คือจุดขายของ MCP - agent เดียวคุยกับหลายฐานข้อมูลพร้อมกันได้ ใช้ทำ data migration validation ในงานจริง

### C5. เขียนข้อมูล (ทำเป็น demo โดยวิทยากร ระวังเรื่องสิทธิ์)

```
เพิ่มหมวดสินค้าใหม่ชื่อ "Imported Seafood" และสินค้าตัวอย่าง 2 รายการ
ใน MySQL แต่ก่อน INSERT ให้แสดง SQL ให้ผมตรวจก่อน อย่าเพิ่งรัน
```

จุดสอน: ย้ำแนวปฏิบัติ Human-in-the-loop - ให้ AI เสนอ SQL ก่อนเสมอเมื่อเป็นคำสั่งเขียน และอธิบายว่าเราตั้งใจตั้ง MCP เป็น read-only ตั้งแต่ต้นเพื่อความปลอดภัย

---

## Part D: ประยุกต์ - ให้ Claude Code สร้าง Report จากฐานข้อมูล

แนวคิด: Claude Code อ่านข้อมูลผ่าน MCP แล้ว "เขียนไฟล์" report ได้หลายรูปแบบ เพราะมันมีทั้งเครื่องมือ query และเครื่องมือสร้างไฟล์/รันโค้ดในตัว

### D1. Executive Summary (Markdown)

```
สร้างรายงานสรุปผู้บริหารของร้าน seafoodstore จากฐานข้อมูล PostgreSQL
บันทึกเป็นไฟล์ reports/executive-summary.md ประกอบด้วย
1. ภาพรวมยอดขายรวม จำนวนออเดอร์ ยอดเฉลี่ยต่อออเดอร์
2. Top 5 สินค้าขายดี และหมวดหมู่ที่ทำรายได้สูงสุด
3. Top 3 ลูกค้า
4. สถานะสต็อกที่ต้องเติมด่วน (ต่ำกว่า 50 ชิ้น)
5. ข้อเสนอแนะเชิงธุรกิจ 3 ข้อจากข้อมูลจริง
เขียนภาษาไทย ตัวเลขมี comma คั่นหลักพัน
```

### D2. HTML Dashboard พร้อมกราฟ

```
สร้างไฟล์ reports/dashboard.html เป็น dashboard สรุปยอดขาย seafoodstore
- การ์ดตัวเลขสำคัญ: ยอดขายรวม, จำนวนออเดอร์, จำนวนลูกค้า, จำนวนสินค้า
- กราฟแท่ง: ยอดขายแยกตามหมวดสินค้า (ใช้ Chart.js จาก CDN)
- กราฟโดนัท: สัดส่วนยอดขายของ Top 5 สินค้า
- ตารางสต็อกคงเหลือ เรียงจากน้อยไปมาก แถวที่ต่ำกว่า 50 ให้พื้นหลังสีแดงอ่อน
- ธีมสีน้ำเงินเข้ม สวยงามแบบมืออาชีพ ภาษาไทยทั้งหมด
ดึงข้อมูลจริงจาก PostgreSQL แล้วฝังเป็น static data ในไฟล์ HTML
```

### D3. Excel Report ด้วยสคริปต์

```
เขียนสคริปต์ Node.js (ไม่ใส่ semicolon) ชื่อ scripts/export-sales-report.js
ที่ต่อ PostgreSQL โดยตรงด้วย library pg แล้ว export รายงานยอดขาย
เป็นไฟล์ Excel ด้วย library exceljs มี 3 sheets:
Sheet1 "Orders" รายการออเดอร์ทั้งหมด join ชื่อลูกค้า
Sheet2 "Products" ยอดขายรายสินค้า
Sheet3 "Summary" ตัวเลขสรุป
ใส่ header สีพื้น จัด format ตัวเลขให้อ่านง่าย ติดตั้ง dependencies ให้ด้วย
เสร็จแล้วรันสคริปต์และบอกผลลัพธ์
```

จุดสอน: ชี้ความต่างระหว่าง D1/D2 (Claude query ผ่าน MCP แล้วฝังผลลัพธ์) กับ D3 (Claude เขียนโปรแกรมที่ต่อ DB เองได้ นำไปตั้ง schedule รันซ้ำได้) - งานจริงเลือกใช้ตามโจทย์

### D4. Challenge ท้ายคลาส (ให้ผู้เรียนเขียน prompt เอง)

โจทย์: "สร้างรายงานเปรียบเทียบประสิทธิภาพ supplier แต่ละราย ว่าสินค้าของใครขายดีและเหลือสต็อกน้อยที่สุด ในรูปแบบที่คุณเลือกเอง" - ประเมินจากความครบถ้วนของ prompt (ระบุแหล่งข้อมูล รูปแบบ output ภาษา และเงื่อนไข)

---

## ปัญหาที่พบบ่อย

| อาการ | สาเหตุ/วิธีแก้ |
|---|---|
| import MySQL แล้ว error `ASCII '\0' appeared` | ยังไม่ได้แปลงไฟล์เป็น UTF-8 (ดู A3 ขั้นที่ 1) |
| PowerShell ฟ้อง `<` operator is reserved | ใช้ Command Prompt แทน หรือใช้ `Get-Content file.sql | mysql ...` |
| psql ฟ้อง `\restrict: invalid command` | psql เวอร์ชันต่ำกว่า 18 ให้อัปเดต หรือลบบรรทัด \restrict ออก |
| `/mcp` ไม่เห็น server | ตรวจว่ารัน `claude mcp add` ในโฟลเดอร์โปรเจกต์เดียวกับที่เปิด claude และมี Node.js v18+ |
| MCP ต่อไม่ได้ Authentication failed | ตรวจรหัสผ่านใน connection string / env และทดสอบด้วย mysql/psql client ก่อน |
| ภาษาไทยจาก MySQL เพี้ยน | ตรวจว่าใช้ charset utf8mb4 ตอนสร้างฐานข้อมูล |

---

## เอกสารอ้างอิง

- Claude Code - Connect to MCP servers: https://docs.claude.com/en/docs/claude-code/mcp
- Model Context Protocol: https://modelcontextprotocol.io/
- MySQL MCP Server (@benborla29/mcp-server-mysql): https://github.com/benborla/mcp-server-mysql
- PostgreSQL Reference MCP Server: https://www.npmjs.com/package/@modelcontextprotocol/server-postgres
- Postgres MCP Pro (ทางเลือกที่ maintain ต่อเนื่อง): https://github.com/crystaldba/postgres-mcp
- XAMPP: https://www.apachefriends.org/
- PostgreSQL Windows Installer: https://www.postgresql.org/download/windows/
- MariaDB Import/Export: https://mariadb.com/kb/en/importing-data-into-mariadb/
