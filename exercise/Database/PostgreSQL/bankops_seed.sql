--
-- bankops_seed.sql
-- ฐานข้อมูลธนาคารจำลองสำหรับ Day 5 - Lab 3 (Capstone: Auto Report to LINE)
-- ใช้กับ PostgreSQL 14 ขึ้นไป
--
-- วิธีใช้:
--   psql -U postgres -c "CREATE DATABASE bankops;"
--   psql -U postgres -d bankops -f bankops_seed.sql
--
-- หมายเหตุ: ข้อมูลธุรกรรมสร้างแบบสุ่มย้อนหลัง 30 วันนับจากวันที่รันไฟล์นี้
-- ดังนั้น import วันไหน ข้อมูลก็ "สด" เสมอ เหมาะกับการสอนเรื่อง Daily Report
--

SELECT setseed(0.42);

DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS loans CASCADE;
DROP TABLE IF EXISTS accounts CASCADE;
DROP TABLE IF EXISTS exchange_rates CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS branches CASCADE;

-- =========================================================
-- 1) สาขาธนาคาร
-- =========================================================
CREATE TABLE branches (
    id       SERIAL PRIMARY KEY,
    code     VARCHAR(10) UNIQUE NOT NULL,
    name     VARCHAR(100) NOT NULL,
    province VARCHAR(100) NOT NULL
);

INSERT INTO branches (code, name, province) VALUES
('HQ01',  'สำนักงานใหญ่ นครหลวงเวียงจันทน์', 'Vientiane Capital'),
('VTE02', 'สาขาตลาดเช้า',                    'Vientiane Capital'),
('LPB01', 'สาขาหลวงพระบาง',                  'Luang Prabang'),
('SVK01', 'สาขาสะหวันนะเขต',                 'Savannakhet'),
('PKE01', 'สาขาปากเซ',                       'Champasak'),
('ODX01', 'สาขาอุดมไซ',                      'Oudomxay');

-- =========================================================
-- 2) ลูกค้า 50 ราย (retail / sme / corporate)
-- =========================================================
CREATE TABLE customers (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(150) NOT NULL,
    phone      VARCHAR(20),
    segment    VARCHAR(20) NOT NULL DEFAULT 'retail',
    created_at TIMESTAMPTZ DEFAULT now()
);

INSERT INTO customers (name, phone, segment)
SELECT
    (ARRAY['สมจัน','คำหล้า','บุญมี','จันทะสุก','วิไลวัน','สุกสะหวัน','พอนสะหวัน','แก้วมะนี','อนุสอน','ดาววอน'])[1 + (g % 10)]
    || ' ' ||
    (ARRAY['วงสะหวัน','พมมะจัน','สีสะหวาด','จันทะวง','ไซยะวง'])[1 + (g % 5)],
    '020' || lpad((5550000 + g)::text, 7, '0'),
    CASE
        WHEN g % 10 = 0 THEN 'corporate'
        WHEN g % 5  = 0 THEN 'sme'
        ELSE 'retail'
    END
FROM generate_series(1, 50) AS g;

-- =========================================================
-- 3) บัญชีเงินฝาก 80 บัญชี (savings / current / fixed)
--    ยอดคงเหลือหน่วยเป็น LAK
-- =========================================================
CREATE TABLE accounts (
    id           SERIAL PRIMARY KEY,
    account_no   VARCHAR(20) UNIQUE NOT NULL,
    customer_id  INT NOT NULL REFERENCES customers(id),
    branch_id    INT NOT NULL REFERENCES branches(id),
    account_type VARCHAR(20) NOT NULL,
    balance      NUMERIC(15,2) NOT NULL DEFAULT 0,
    opened_at    DATE NOT NULL
);

INSERT INTO accounts (account_no, customer_id, branch_id, account_type, balance, opened_at)
SELECT
    '110-' || lpad(g::text, 8, '0'),
    1 + ((g - 1) % 50),
    1 + (g % 6),
    (ARRAY['savings','savings','savings','current','fixed'])[1 + (g % 5)],
    round((random() * 90000000 + 500000)::numeric, 2),
    CURRENT_DATE - (random() * 1000)::int
FROM generate_series(1, 80) AS g;

-- =========================================================
-- 4) ธุรกรรม 600 รายการ ย้อนหลัง 30 วันนับจากวันที่ import
--    txn_type: deposit / withdraw / transfer_in / transfer_out / fee
--    channel : mobile_app / atm / branch (ถ่วงน้ำหนักให้ mobile เยอะสุด)
--    จำนวนเงินปัดเป็นหลักพัน LAK
-- =========================================================
CREATE TABLE transactions (
    id         SERIAL PRIMARY KEY,
    account_id INT NOT NULL REFERENCES accounts(id),
    branch_id  INT NOT NULL REFERENCES branches(id),
    txn_type   VARCHAR(20) NOT NULL,
    channel    VARCHAR(20) NOT NULL,
    amount     NUMERIC(15,2) NOT NULL,
    txn_at     TIMESTAMPTZ NOT NULL
);

INSERT INTO transactions (account_id, branch_id, txn_type, channel, amount, txn_at)
SELECT
    1 + (random() * 79)::int,
    1 + (random() * 5)::int,
    (ARRAY['deposit','withdraw','transfer_in','transfer_out','deposit','withdraw','fee'])[1 + (random() * 6)::int],
    (ARRAY['mobile_app','mobile_app','mobile_app','atm','atm','branch'])[1 + (random() * 5)::int],
    round((random() * 4900000 + 100000)::numeric / 1000) * 1000,
    now() - ((random() * 29)::int || ' days')::interval
          - ((random() * 13)::int || ' hours')::interval
          - ((random() * 59)::int || ' minutes')::interval
FROM generate_series(1, 600) AS g;

-- ธุรกรรมผิดปกติ (มูลค่าสูงมาก) 3 รายการเมื่อวานนี้ ไว้สอนเรื่อง Anomaly Detection
INSERT INTO transactions (account_id, branch_id, txn_type, channel, amount, txn_at) VALUES
(5,  1, 'withdraw',     'branch', 480000000.00, now() - interval '1 day' - interval '2 hours'),
(12, 3, 'transfer_out', 'branch', 350000000.00, now() - interval '1 day' - interval '5 hours'),
(33, 1, 'deposit',      'branch', 620000000.00, now() - interval '1 day' - interval '7 hours');

CREATE INDEX idx_transactions_txn_at    ON transactions (txn_at);
CREATE INDEX idx_transactions_branch    ON transactions (branch_id, txn_at);
CREATE INDEX idx_transactions_account   ON transactions (account_id);

-- =========================================================
-- 5) สินเชื่อ 40 สัญญา (home / auto / sme / personal)
--    principal หน่วย LAK ปัดเป็นหลักล้าน
-- =========================================================
CREATE TABLE loans (
    id            SERIAL PRIMARY KEY,
    customer_id   INT NOT NULL REFERENCES customers(id),
    branch_id     INT NOT NULL REFERENCES branches(id),
    loan_type     VARCHAR(30) NOT NULL,
    principal     NUMERIC(15,2) NOT NULL,
    interest_rate NUMERIC(5,2) NOT NULL,
    status        VARCHAR(20) NOT NULL,
    start_date    DATE NOT NULL
);

INSERT INTO loans (customer_id, branch_id, loan_type, principal, interest_rate, status, start_date)
SELECT
    1 + (random() * 49)::int,
    1 + (random() * 5)::int,
    (ARRAY['home','auto','sme','personal'])[1 + (random() * 3)::int],
    round((random() * 900000000 + 50000000)::numeric / 1000000) * 1000000,
    round((7 + random() * 6)::numeric, 2),
    (ARRAY['active','active','active','active','closed','overdue'])[1 + (random() * 5)::int],
    CURRENT_DATE - (random() * 700)::int
FROM generate_series(1, 40) AS g;

-- =========================================================
-- 6) อัตราแลกเปลี่ยน 3 สกุล (THB/USD/CNY เทียบ LAK) ย้อนหลัง 30 วัน
-- =========================================================
CREATE TABLE exchange_rates (
    id        SERIAL PRIMARY KEY,
    currency  VARCHAR(3) NOT NULL,
    buy_rate  NUMERIC(12,2) NOT NULL,
    sell_rate NUMERIC(12,2) NOT NULL,
    rate_date DATE NOT NULL,
    UNIQUE (currency, rate_date)
);

INSERT INTO exchange_rates (currency, buy_rate, sell_rate, rate_date)
SELECT
    t.cur,
    t.buy,
    round((t.buy * 1.015)::numeric, 2),
    t.d::date
FROM (
    SELECT
        c.cur,
        round((c.base * (0.98 + random() * 0.04))::numeric, 2) AS buy,
        d
    FROM (VALUES ('THB', 640.0), ('USD', 21800.0), ('CNY', 3000.0)) AS c(cur, base)
    CROSS JOIN generate_series(CURRENT_DATE - 29, CURRENT_DATE, interval '1 day') AS d
) t;

-- =========================================================
-- ตรวจสอบผลการ import (รันดูได้)
-- =========================================================
-- SELECT 'branches' t, count(*) FROM branches
-- UNION ALL SELECT 'customers', count(*) FROM customers
-- UNION ALL SELECT 'accounts', count(*) FROM accounts
-- UNION ALL SELECT 'transactions', count(*) FROM transactions
-- UNION ALL SELECT 'loans', count(*) FROM loans
-- UNION ALL SELECT 'exchange_rates', count(*) FROM exchange_rates;
--
-- ยอดธุรกรรมของเมื่อวาน แยกตามสาขา:
-- SELECT b.name, count(*) AS txn_count, sum(t.amount) AS total_amount
-- FROM transactions t JOIN branches b ON b.id = t.branch_id
-- WHERE t.txn_at::date = CURRENT_DATE - 1
-- GROUP BY b.name ORDER BY total_amount DESC;
