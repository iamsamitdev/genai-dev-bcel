--
-- PostgreSQL database dump
--

\restrict sK4VszaS8FcbvUzV7KCOAtdyvJOuEgXO04neuuOLufin4ujZ6vh6v7H5gZhdobk

-- Dumped from database version 18.2
-- Dumped by pg_dump version 18.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO postgres;

--
-- Name: hr; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA hr;


ALTER SCHEMA hr OWNER TO postgres;

--
-- Name: inventory; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA inventory;


ALTER SCHEMA inventory OWNER TO postgres;

--
-- Name: sales; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA sales;


ALTER SCHEMA sales OWNER TO postgres;

--
-- Name: store; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA store;


ALTER SCHEMA store OWNER TO postgres;

--
-- Name: tools; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tools;


ALTER SCHEMA tools OWNER TO postgres;

--
-- Name: set_updated_at(); Type: FUNCTION; Schema: tools; Owner: postgres
--

CREATE FUNCTION tools.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$;


ALTER FUNCTION tools.set_updated_at() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: users; Type: TABLE; Schema: auth; Owner: postgres
--

CREATE TABLE auth.users (
    id integer NOT NULL,
    username character varying(100) NOT NULL,
    password character varying(255) NOT NULL,
    role character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE auth.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: auth; Owner: postgres
--

CREATE SEQUENCE auth.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: postgres
--

ALTER SEQUENCE auth.users_id_seq OWNED BY auth.users.id;


--
-- Name: employees; Type: TABLE; Schema: hr; Owner: postgres
--

CREATE TABLE hr.employees (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    "position" character varying(100),
    email character varying(100),
    phone character varying(50),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    deleted_at timestamp without time zone
);


ALTER TABLE hr.employees OWNER TO postgres;

--
-- Name: employees_id_seq; Type: SEQUENCE; Schema: hr; Owner: postgres
--

CREATE SEQUENCE hr.employees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE hr.employees_id_seq OWNER TO postgres;

--
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: hr; Owner: postgres
--

ALTER SEQUENCE hr.employees_id_seq OWNED BY hr.employees.id;


--
-- Name: stock_movements; Type: TABLE; Schema: inventory; Owner: postgres
--

CREATE TABLE inventory.stock_movements (
    id integer NOT NULL,
    product_id integer,
    movement_date timestamp without time zone DEFAULT now(),
    change_quantity integer NOT NULL,
    note text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    deleted_at timestamp without time zone
);


ALTER TABLE inventory.stock_movements OWNER TO postgres;

--
-- Name: stock_movements_id_seq; Type: SEQUENCE; Schema: inventory; Owner: postgres
--

CREATE SEQUENCE inventory.stock_movements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventory.stock_movements_id_seq OWNER TO postgres;

--
-- Name: stock_movements_id_seq; Type: SEQUENCE OWNED BY; Schema: inventory; Owner: postgres
--

ALTER SEQUENCE inventory.stock_movements_id_seq OWNED BY inventory.stock_movements.id;


--
-- Name: stocks; Type: TABLE; Schema: inventory; Owner: postgres
--

CREATE TABLE inventory.stocks (
    id integer NOT NULL,
    product_id integer,
    quantity integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    deleted_at timestamp without time zone
);


ALTER TABLE inventory.stocks OWNER TO postgres;

--
-- Name: stocks_id_seq; Type: SEQUENCE; Schema: inventory; Owner: postgres
--

CREATE SEQUENCE inventory.stocks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE inventory.stocks_id_seq OWNER TO postgres;

--
-- Name: stocks_id_seq; Type: SEQUENCE OWNED BY; Schema: inventory; Owner: postgres
--

ALTER SEQUENCE inventory.stocks_id_seq OWNED BY inventory.stocks.id;


--
-- Name: customers; Type: TABLE; Schema: sales; Owner: postgres
--

CREATE TABLE sales.customers (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    email character varying(100),
    phone character varying(50),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    deleted_at timestamp without time zone
);


ALTER TABLE sales.customers OWNER TO postgres;

--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: sales; Owner: postgres
--

CREATE SEQUENCE sales.customers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sales.customers_id_seq OWNER TO postgres;

--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: postgres
--

ALTER SEQUENCE sales.customers_id_seq OWNED BY sales.customers.id;


--
-- Name: order_items; Type: TABLE; Schema: sales; Owner: postgres
--

CREATE TABLE sales.order_items (
    id integer NOT NULL,
    order_id integer,
    product_id integer,
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    deleted_at timestamp without time zone
);


ALTER TABLE sales.order_items OWNER TO postgres;

--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: sales; Owner: postgres
--

CREATE SEQUENCE sales.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sales.order_items_id_seq OWNER TO postgres;

--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: postgres
--

ALTER SEQUENCE sales.order_items_id_seq OWNED BY sales.order_items.id;


--
-- Name: orders; Type: TABLE; Schema: sales; Owner: postgres
--

CREATE TABLE sales.orders (
    id integer NOT NULL,
    customer_id integer,
    order_date timestamp without time zone DEFAULT now(),
    total_amount numeric(12,2) NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    deleted_at timestamp without time zone
);


ALTER TABLE sales.orders OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: sales; Owner: postgres
--

CREATE SEQUENCE sales.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE sales.orders_id_seq OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: sales; Owner: postgres
--

ALTER SEQUENCE sales.orders_id_seq OWNED BY sales.orders.id;


--
-- Name: categories; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store.categories (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    deleted_at timestamp without time zone
);


ALTER TABLE store.categories OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: store; Owner: postgres
--

CREATE SEQUENCE store.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE store.categories_id_seq OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: store; Owner: postgres
--

ALTER SEQUENCE store.categories_id_seq OWNED BY store.categories.id;


--
-- Name: products; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store.products (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    category_id integer,
    supplier_id integer,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    deleted_at timestamp without time zone
);


ALTER TABLE store.products OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: store; Owner: postgres
--

CREATE SEQUENCE store.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE store.products_id_seq OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: store; Owner: postgres
--

ALTER SEQUENCE store.products_id_seq OWNED BY store.products.id;


--
-- Name: suppliers; Type: TABLE; Schema: store; Owner: postgres
--

CREATE TABLE store.suppliers (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    contact_info text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    deleted_at timestamp without time zone
);


ALTER TABLE store.suppliers OWNER TO postgres;

--
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: store; Owner: postgres
--

CREATE SEQUENCE store.suppliers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE store.suppliers_id_seq OWNER TO postgres;

--
-- Name: suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: store; Owner: postgres
--

ALTER SEQUENCE store.suppliers_id_seq OWNED BY store.suppliers.id;


--
-- Name: users id; Type: DEFAULT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.users ALTER COLUMN id SET DEFAULT nextval('auth.users_id_seq'::regclass);


--
-- Name: employees id; Type: DEFAULT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.employees ALTER COLUMN id SET DEFAULT nextval('hr.employees_id_seq'::regclass);


--
-- Name: stock_movements id; Type: DEFAULT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY inventory.stock_movements ALTER COLUMN id SET DEFAULT nextval('inventory.stock_movements_id_seq'::regclass);


--
-- Name: stocks id; Type: DEFAULT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY inventory.stocks ALTER COLUMN id SET DEFAULT nextval('inventory.stocks_id_seq'::regclass);


--
-- Name: customers id; Type: DEFAULT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.customers ALTER COLUMN id SET DEFAULT nextval('sales.customers_id_seq'::regclass);


--
-- Name: order_items id; Type: DEFAULT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.order_items ALTER COLUMN id SET DEFAULT nextval('sales.order_items_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.orders ALTER COLUMN id SET DEFAULT nextval('sales.orders_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.categories ALTER COLUMN id SET DEFAULT nextval('store.categories_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.products ALTER COLUMN id SET DEFAULT nextval('store.products_id_seq'::regclass);


--
-- Name: suppliers id; Type: DEFAULT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.suppliers ALTER COLUMN id SET DEFAULT nextval('store.suppliers_id_seq'::regclass);


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: postgres
--

COPY auth.users (id, username, password, role, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: hr; Owner: postgres
--

COPY hr.employees (id, name, "position", email, phone, created_at, updated_at, deleted_at) FROM stdin;
1	Alice Morgan	Manager	alice@example.com	123111111	2025-04-21 00:55:20.175726	2025-04-21 00:55:20.175726	\N
2	Bob Taylor	Cashier	bob@example.com	223222222	2025-04-21 00:55:20.175726	2025-04-21 00:55:20.175726	\N
3	Charlie Brown	Stock Keeper	charlie@example.com	323333333	2025-04-21 00:55:20.175726	2025-04-21 00:55:20.175726	\N
4	David Green	Sales Rep	david@example.com	423444444	2025-04-21 00:55:20.175726	2025-04-21 00:55:20.175726	\N
5	Eva White	Accountant	eva@example.com	523555555	2025-04-21 00:55:20.175726	2025-04-21 00:55:20.175726	\N
6	Frank Black	Delivery	frank@example.com	623666666	2025-04-21 00:55:20.175726	2025-04-21 00:55:20.175726	\N
7	Grace Lee	Customer Support	grace@example.com	723777777	2025-04-21 00:55:20.175726	2025-04-21 00:55:20.175726	\N
8	Hank Hill	Warehouse Manager	hank@example.com	823888888	2025-04-21 00:55:20.175726	2025-04-21 00:55:20.175726	\N
9	Isabel Cruz	Logistics	isabel@example.com	923999999	2025-04-21 00:55:20.175726	2025-04-21 00:55:20.175726	\N
10	Jackie Chan	Security	jackie@example.com	1010101010	2025-04-21 00:55:20.175726	2025-04-21 00:55:20.175726	\N
\.


--
-- Data for Name: stock_movements; Type: TABLE DATA; Schema: inventory; Owner: postgres
--

COPY inventory.stock_movements (id, product_id, movement_date, change_quantity, note, created_at, updated_at, deleted_at) FROM stdin;
1	1	2025-04-21 00:55:13.854802	50	Initial stock	2025-04-21 00:55:13.854802	2025-04-21 00:55:13.854802	\N
2	2	2025-04-21 00:55:13.854802	40	Initial stock	2025-04-21 00:55:13.854802	2025-04-21 00:55:13.854802	\N
3	3	2025-04-21 00:55:13.854802	100	Initial stock	2025-04-21 00:55:13.854802	2025-04-21 00:55:13.854802	\N
4	4	2025-04-21 00:55:13.854802	70	Initial stock	2025-04-21 00:55:13.854802	2025-04-21 00:55:13.854802	\N
5	5	2025-04-21 00:55:13.854802	60	Initial stock	2025-04-21 00:55:13.854802	2025-04-21 00:55:13.854802	\N
6	6	2025-04-21 00:55:13.854802	80	Initial stock	2025-04-21 00:55:13.854802	2025-04-21 00:55:13.854802	\N
7	7	2025-04-21 00:55:13.854802	150	Initial stock	2025-04-21 00:55:13.854802	2025-04-21 00:55:13.854802	\N
8	8	2025-04-21 00:55:13.854802	30	Initial stock	2025-04-21 00:55:13.854802	2025-04-21 00:55:13.854802	\N
9	9	2025-04-21 00:55:13.854802	90	Initial stock	2025-04-21 00:55:13.854802	2025-04-21 00:55:13.854802	\N
10	10	2025-04-21 00:55:13.854802	120	Initial stock	2025-04-21 00:55:13.854802	2025-04-21 00:55:13.854802	\N
\.


--
-- Data for Name: stocks; Type: TABLE DATA; Schema: inventory; Owner: postgres
--

COPY inventory.stocks (id, product_id, quantity, created_at, updated_at, deleted_at) FROM stdin;
1	1	50	2025-04-21 00:55:12.433782	2025-04-21 00:55:12.433782	\N
2	2	40	2025-04-21 00:55:12.433782	2025-04-21 00:55:12.433782	\N
3	3	100	2025-04-21 00:55:12.433782	2025-04-21 00:55:12.433782	\N
4	4	70	2025-04-21 00:55:12.433782	2025-04-21 00:55:12.433782	\N
5	5	60	2025-04-21 00:55:12.433782	2025-04-21 00:55:12.433782	\N
6	6	80	2025-04-21 00:55:12.433782	2025-04-21 00:55:12.433782	\N
7	7	150	2025-04-21 00:55:12.433782	2025-04-21 00:55:12.433782	\N
8	8	30	2025-04-21 00:55:12.433782	2025-04-21 00:55:12.433782	\N
9	9	90	2025-04-21 00:55:12.433782	2025-04-21 00:55:12.433782	\N
10	10	120	2025-04-21 00:55:12.433782	2025-04-21 00:55:12.433782	\N
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: sales; Owner: postgres
--

COPY sales.customers (id, name, email, phone, created_at, updated_at, deleted_at) FROM stdin;
1	John Doe	john@example.com	123456789	2025-04-21 00:55:15.33634	2025-04-21 00:55:15.33634	\N
2	Jane Smith	jane@example.com	987654321	2025-04-21 00:55:15.33634	2025-04-21 00:55:15.33634	\N
3	Mark Lee	mark@example.com	1122334455	2025-04-21 00:55:15.33634	2025-04-21 00:55:15.33634	\N
4	Sara Kim	sara@example.com	2233445566	2025-04-21 00:55:15.33634	2025-04-21 00:55:15.33634	\N
5	Tom Hanks	tom@example.com	3344556677	2025-04-21 00:55:15.33634	2025-04-21 00:55:15.33634	\N
6	Lisa Ray	lisa@example.com	4455667788	2025-04-21 00:55:15.33634	2025-04-21 00:55:15.33634	\N
7	Peter Wong	peter@example.com	5566778899	2025-04-21 00:55:15.33634	2025-04-21 00:55:15.33634	\N
8	Emily Clark	emily@example.com	6677889900	2025-04-21 00:55:15.33634	2025-04-21 00:55:15.33634	\N
9	Chris Evans	chris@example.com	7788990011	2025-04-21 00:55:15.33634	2025-04-21 00:55:15.33634	\N
10	Anna Belle	anna@example.com	8899001122	2025-04-21 00:55:15.33634	2025-04-21 00:55:15.33634	\N
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: sales; Owner: postgres
--

COPY sales.order_items (id, order_id, product_id, quantity, unit_price, created_at, updated_at, deleted_at) FROM stdin;
1	1	1	2	250.00	2025-04-21 00:55:18.942067	2025-04-21 00:55:18.942067	\N
2	1	3	1	180.00	2025-04-21 00:55:18.942067	2025-04-21 00:55:18.942067	\N
3	2	5	3	150.00	2025-04-21 00:55:18.942067	2025-04-21 00:55:18.942067	\N
4	3	2	2	300.00	2025-04-21 00:55:18.942067	2025-04-21 00:55:18.942067	\N
5	3	4	1	220.00	2025-04-21 00:55:18.942067	2025-04-21 00:55:18.942067	\N
6	4	7	4	50.00	2025-04-21 00:55:18.942067	2025-04-21 00:55:18.942067	\N
7	5	8	2	200.00	2025-04-21 00:55:18.942067	2025-04-21 00:55:18.942067	\N
8	6	3	5	180.00	2025-04-21 00:55:18.942067	2025-04-21 00:55:18.942067	\N
9	7	10	6	80.00	2025-04-21 00:55:18.942067	2025-04-21 00:55:18.942067	\N
10	8	9	4	120.00	2025-04-21 00:55:18.942067	2025-04-21 00:55:18.942067	\N
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: sales; Owner: postgres
--

COPY sales.orders (id, customer_id, order_date, total_amount, created_at, updated_at, deleted_at) FROM stdin;
1	1	2025-04-21 00:55:17.486106	750.00	2025-04-21 00:55:17.486106	2025-04-21 00:55:17.486106	\N
2	2	2025-04-21 00:55:17.486106	450.00	2025-04-21 00:55:17.486106	2025-04-21 00:55:17.486106	\N
3	3	2025-04-21 00:55:17.486106	1200.00	2025-04-21 00:55:17.486106	2025-04-21 00:55:17.486106	\N
4	4	2025-04-21 00:55:17.486106	300.00	2025-04-21 00:55:17.486106	2025-04-21 00:55:17.486106	\N
5	5	2025-04-21 00:55:17.486106	680.00	2025-04-21 00:55:17.486106	2025-04-21 00:55:17.486106	\N
6	6	2025-04-21 00:55:17.486106	900.00	2025-04-21 00:55:17.486106	2025-04-21 00:55:17.486106	\N
7	7	2025-04-21 00:55:17.486106	450.00	2025-04-21 00:55:17.486106	2025-04-21 00:55:17.486106	\N
8	8	2025-04-21 00:55:17.486106	520.00	2025-04-21 00:55:17.486106	2025-04-21 00:55:17.486106	\N
9	9	2025-04-21 00:55:17.486106	810.00	2025-04-21 00:55:17.486106	2025-04-21 00:55:17.486106	\N
10	10	2025-04-21 00:55:17.486106	1100.00	2025-04-21 00:55:17.486106	2025-04-21 00:55:17.486106	\N
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store.categories (id, name, created_at, updated_at, deleted_at) FROM stdin;
1	Fish	2025-04-21 00:54:45.677259	2025-04-21 00:54:45.677259	\N
2	Shellfish	2025-04-21 00:54:45.677259	2025-04-21 00:54:45.677259	\N
3	Crustaceans	2025-04-21 00:54:45.677259	2025-04-21 00:54:45.677259	\N
4	Mollusks	2025-04-21 00:54:45.677259	2025-04-21 00:54:45.677259	\N
5	Seaweed	2025-04-21 00:54:45.677259	2025-04-21 00:54:45.677259	\N
6	Squid/Octopus	2025-04-21 00:54:45.677259	2025-04-21 00:54:45.677259	\N
7	Processed	2025-04-21 00:54:45.677259	2025-04-21 00:54:45.677259	\N
8	Frozen	2025-04-21 00:54:45.677259	2025-04-21 00:54:45.677259	\N
9	Freshwater	2025-04-21 00:54:45.677259	2025-04-21 00:54:45.677259	\N
10	Other	2025-04-21 00:54:45.677259	2025-04-21 00:54:45.677259	\N
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store.products (id, name, description, price, category_id, supplier_id, created_at, updated_at, deleted_at) FROM stdin;
1	Salmon Fillet	Fresh Atlantic salmon fillet	250.00	1	1	2025-04-21 00:55:10.661239	2025-04-21 00:55:10.661239	\N
2	Tuna Steak	High-quality tuna steak	300.00	1	2	2025-04-21 00:55:10.661239	2025-04-21 00:55:10.661239	\N
3	Shrimp (Large)	Large-sized shrimp	180.00	3	3	2025-04-21 00:55:10.661239	2025-04-21 00:55:10.661239	\N
4	Blue Crab	Fresh blue crab	220.00	3	4	2025-04-21 00:55:10.661239	2025-04-21 00:55:10.661239	\N
5	Squid Rings	Cleaned squid rings	150.00	6	5	2025-04-21 00:55:10.661239	2025-04-21 00:55:10.661239	\N
6	Mussels	Fresh mussels	90.00	2	6	2025-04-21 00:55:10.661239	2025-04-21 00:55:10.661239	\N
7	Dried Seaweed	Premium seaweed sheets	50.00	5	7	2025-04-21 00:55:10.661239	2025-04-21 00:55:10.661239	\N
8	Frozen Scallops	Frozen scallops (500g)	200.00	8	8	2025-04-21 00:55:10.661239	2025-04-21 00:55:10.661239	\N
9	Tilapia Fillet	Freshwater tilapia fillet	120.00	9	9	2025-04-21 00:55:10.661239	2025-04-21 00:55:10.661239	\N
10	Canned Tuna	Canned tuna in brine	80.00	7	10	2025-04-21 00:55:10.661239	2025-04-21 00:55:10.661239	\N
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: store; Owner: postgres
--

COPY store.suppliers (id, name, contact_info, created_at, updated_at, deleted_at) FROM stdin;
1	Ocean Fresh Co.	oceanfresh@example.com	2025-04-21 00:55:08.3552	2025-04-21 00:55:08.3552	\N
2	Marine Traders Ltd.	marine@example.com	2025-04-21 00:55:08.3552	2025-04-21 00:55:08.3552	\N
3	Deep Sea Foods	deepsea@example.com	2025-04-21 00:55:08.3552	2025-04-21 00:55:08.3552	\N
4	Global Seafood	global@example.com	2025-04-21 00:55:08.3552	2025-04-21 00:55:08.3552	\N
5	Coastal Catchers	coastal@example.com	2025-04-21 00:55:08.3552	2025-04-21 00:55:08.3552	\N
6	Bluewater Supplies	bluewater@example.com	2025-04-21 00:55:08.3552	2025-04-21 00:55:08.3552	\N
7	Aqua Harvesters	aqua@example.com	2025-04-21 00:55:08.3552	2025-04-21 00:55:08.3552	\N
8	Northern Fish Inc.	northern@example.com	2025-04-21 00:55:08.3552	2025-04-21 00:55:08.3552	\N
9	Seaside Partners	seaside@example.com	2025-04-21 00:55:08.3552	2025-04-21 00:55:08.3552	\N
10	Pacific Seafoods	pacific@example.com	2025-04-21 00:55:08.3552	2025-04-21 00:55:08.3552	\N
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: postgres
--

SELECT pg_catalog.setval('auth.users_id_seq', 1, false);


--
-- Name: employees_id_seq; Type: SEQUENCE SET; Schema: hr; Owner: postgres
--

SELECT pg_catalog.setval('hr.employees_id_seq', 10, true);


--
-- Name: stock_movements_id_seq; Type: SEQUENCE SET; Schema: inventory; Owner: postgres
--

SELECT pg_catalog.setval('inventory.stock_movements_id_seq', 10, true);


--
-- Name: stocks_id_seq; Type: SEQUENCE SET; Schema: inventory; Owner: postgres
--

SELECT pg_catalog.setval('inventory.stocks_id_seq', 10, true);


--
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: sales; Owner: postgres
--

SELECT pg_catalog.setval('sales.customers_id_seq', 10, true);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: sales; Owner: postgres
--

SELECT pg_catalog.setval('sales.order_items_id_seq', 10, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: sales; Owner: postgres
--

SELECT pg_catalog.setval('sales.orders_id_seq', 10, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: store; Owner: postgres
--

SELECT pg_catalog.setval('store.categories_id_seq', 10, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: store; Owner: postgres
--

SELECT pg_catalog.setval('store.products_id_seq', 10, true);


--
-- Name: suppliers_id_seq; Type: SEQUENCE SET; Schema: store; Owner: postgres
--

SELECT pg_catalog.setval('store.suppliers_id_seq', 10, true);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: auth; Owner: postgres
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: hr; Owner: postgres
--

ALTER TABLE ONLY hr.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: stock_movements stock_movements_pkey; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY inventory.stock_movements
    ADD CONSTRAINT stock_movements_pkey PRIMARY KEY (id);


--
-- Name: stocks stocks_pkey; Type: CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY inventory.stocks
    ADD CONSTRAINT stocks_pkey PRIMARY KEY (id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: employees trigger_employees_updated; Type: TRIGGER; Schema: hr; Owner: postgres
--

CREATE TRIGGER trigger_employees_updated BEFORE UPDATE ON hr.employees FOR EACH ROW EXECUTE FUNCTION tools.set_updated_at();


--
-- Name: stock_movements trigger_stock_movements_updated; Type: TRIGGER; Schema: inventory; Owner: postgres
--

CREATE TRIGGER trigger_stock_movements_updated BEFORE UPDATE ON inventory.stock_movements FOR EACH ROW EXECUTE FUNCTION tools.set_updated_at();


--
-- Name: stocks trigger_stocks_updated; Type: TRIGGER; Schema: inventory; Owner: postgres
--

CREATE TRIGGER trigger_stocks_updated BEFORE UPDATE ON inventory.stocks FOR EACH ROW EXECUTE FUNCTION tools.set_updated_at();


--
-- Name: customers trigger_customers_updated; Type: TRIGGER; Schema: sales; Owner: postgres
--

CREATE TRIGGER trigger_customers_updated BEFORE UPDATE ON sales.customers FOR EACH ROW EXECUTE FUNCTION tools.set_updated_at();


--
-- Name: order_items trigger_order_items_updated; Type: TRIGGER; Schema: sales; Owner: postgres
--

CREATE TRIGGER trigger_order_items_updated BEFORE UPDATE ON sales.order_items FOR EACH ROW EXECUTE FUNCTION tools.set_updated_at();


--
-- Name: orders trigger_orders_updated; Type: TRIGGER; Schema: sales; Owner: postgres
--

CREATE TRIGGER trigger_orders_updated BEFORE UPDATE ON sales.orders FOR EACH ROW EXECUTE FUNCTION tools.set_updated_at();


--
-- Name: categories trigger_categories_updated; Type: TRIGGER; Schema: store; Owner: postgres
--

CREATE TRIGGER trigger_categories_updated BEFORE UPDATE ON store.categories FOR EACH ROW EXECUTE FUNCTION tools.set_updated_at();


--
-- Name: products trigger_products_updated; Type: TRIGGER; Schema: store; Owner: postgres
--

CREATE TRIGGER trigger_products_updated BEFORE UPDATE ON store.products FOR EACH ROW EXECUTE FUNCTION tools.set_updated_at();


--
-- Name: suppliers trigger_suppliers_updated; Type: TRIGGER; Schema: store; Owner: postgres
--

CREATE TRIGGER trigger_suppliers_updated BEFORE UPDATE ON store.suppliers FOR EACH ROW EXECUTE FUNCTION tools.set_updated_at();


--
-- Name: stock_movements stock_movements_product_id_fkey; Type: FK CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY inventory.stock_movements
    ADD CONSTRAINT stock_movements_product_id_fkey FOREIGN KEY (product_id) REFERENCES store.products(id);


--
-- Name: stocks stocks_product_id_fkey; Type: FK CONSTRAINT; Schema: inventory; Owner: postgres
--

ALTER TABLE ONLY inventory.stocks
    ADD CONSTRAINT stocks_product_id_fkey FOREIGN KEY (product_id) REFERENCES store.products(id);


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES sales.orders(id);


--
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES store.products(id);


--
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: sales; Owner: postgres
--

ALTER TABLE ONLY sales.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES sales.customers(id);


--
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES store.categories(id);


--
-- Name: products products_supplier_id_fkey; Type: FK CONSTRAINT; Schema: store; Owner: postgres
--

ALTER TABLE ONLY store.products
    ADD CONSTRAINT products_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES store.suppliers(id);


--
-- PostgreSQL database dump complete
--

\unrestrict sK4VszaS8FcbvUzV7KCOAtdyvJOuEgXO04neuuOLufin4ujZ6vh6v7H5gZhdobk

