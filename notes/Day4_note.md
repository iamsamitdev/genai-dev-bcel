# Generative AI for Software Developer - วันที่ 4: AI Engineering - Building AI-Powered Applications

**หลักสูตรอบรมเชิงปฏิบัติการ: Generative AI for Software Developer (ฉบับ 5 วัน ปี 2026)**
**จัดอบรมให้: ธนาคารการค้าต่างประเทศลาว มหาชน (BCEL)**
**วันที่ 4: เขียนโปรแกรมเรียก LLM, RAG ระดับ Production, AI Agent และสร้าง MCP Server เอง**
วันที่: 23 กรกฎาคม 2569 (2026) | เวลา 09:30-16:30 น. | Onsite Workshop
ผู้สอน: อ.สามิตร โกยม | IT Genius Engineering Co., Ltd.

---

> **⚙️ วันนี้เขียนโค้ดจริงด้วย Python** เราจะก้าวจาก "ผู้ใช้ AI ช่วยพัฒนา" สู่ "ผู้สร้างแอปพลิเคชันที่มี AI เป็นแกนหลัก" โค้ดตัวอย่างทั้งหมดใช้ Python (ตามที่ตกลง) และรันได้จริงในเครื่องผู้เรียน

---

## 🎯 วัตถุประสงค์การเรียนรู้ประจำวัน

เมื่อจบการอบรมวันที่ 4 ผู้เรียนจะสามารถ:

1. เรียกใช้ LLM ผ่าน API (Anthropic/OpenAI/Gemini) จัดการพารามิเตอร์สำคัญ และดึง Structured Output (JSON) ได้
2. จัดการ Streaming, Error Handling, Rate Limit และควบคุมต้นทุน (Token Cost) ในแอปจริง
3. สร้างระบบ RAG ระดับ Production ครบวงจร Ingest → Chunk → Embed → Store → Retrieve → Generate พร้อม Citation
4. ใช้ Tool/Function Calling ให้ LLM เรียกฟังก์ชัน/API/ฐานข้อมูล และประกอบเป็น AI Agent ที่วางแผน-ใช้เครื่องมือ-วนซ้ำได้
5. อธิบายรูปแบบสถาปัตยกรรม Agent (Single/Multi-agent, Workflow) และรู้จัก Framework หลัก (LangChain, LlamaIndex, LangGraph)
6. พัฒนา MCP Server ของตัวเองที่เปิด Tools/Resources/Prompts ให้ AI Agent เรียกใช้ พร้อมแนวทางความปลอดภัย
7. ลงมือเขียนโค้ด: เรียก LLM API + Structured Output, สร้าง Mini-RAG, สร้าง AI Agent และ MCP Server (Workshop Day 4)

---

## 🧭 กำหนดการวันที่ 4 (โดยสังเขป)

| เวลา | หัวข้อ |
| ----------- | ------------------------------------------------------------ |
| 09:30-09:45 | ทบทวนวันที่ 3 + ตั้งค่า Environment (venv + API Key) |
| 09:45-11:00 | **Module 12** LLM API & Application Integration |
| 11:00-11:15 | พักเบรก |
| 11:15-12:00 | **Module 13 (ตอนที่ 1)** RAG ระดับ Production |
| 12:00-13:00 | พักกลางวัน |
| 13:00-13:45 | **Module 13 (ตอนที่ 2)** Vector DB + Retrieval คุณภาพ |
| 13:45-14:45 | **Module 14** Tool/Function Calling & การสร้าง AI Agent |
| 14:45-15:00 | พักเบรก |
| 15:00-15:45 | **Module 15** สร้าง MCP Server ของตัวเอง |
| 15:45-16:30 | **Workshop Day 4** ประกอบ LLM API + RAG + Agent + MCP |

---

## 🔧 ตั้งค่า Environment ก่อนเริ่ม (09:30-09:45)

```bash
# 1) สร้างโฟลเดอร์โปรเจกต์และ virtual environment
mkdir ai-engineering-day4 && cd ai-engineering-day4
python -m venv .venv

# 2) เปิดใช้งาน venv
#   macOS/Linux:
source .venv/bin/activate
#   Windows (PowerShell):
#   .venv\Scripts\Activate.ps1

# 3) ติดตั้ง package ที่ใช้ทั้งวัน
pip install anthropic openai python-dotenv pydantic \
            chromadb sentence-transformers "mcp[cli]" httpx
```

สร้างไฟล์ `.env` (และใส่ `.env` ใน `.gitignore` ทันที):

```bash
# .env  - ห้าม commit ไฟล์นี้เด็ดขาด
ANTHROPIC_API_KEY=sk-ant-xxxxxxxx
OPENAI_API_KEY=sk-xxxxxxxx
```

> ⚠️ **กฎเหล็กด้านความปลอดภัย:** API Key คือความลับ โหลดผ่าน environment variable เสมอ ห้าม hardcode ในโค้ด ห้าม commit ลง Git และห้ามวางในแชตสาธารณะ

---

## 📚 Module 12: LLM API & Application Integration

### เวลา 09:45-11:00 น.

> 💡 **หัวใจของ Module นี้:** การเรียก LLM ผ่าน API คือ "การส่งข้อความไปแล้วรับข้อความกลับ" ผ่าน HTTP ธรรมดา แต่การทำให้มัน "พร้อม production" ต้องจัดการ พารามิเตอร์, JSON output, streaming, error, rate limit และ cost ให้ครบ

---

### 12.1 การเรียก LLM ครั้งแรก

```python
# hello_llm.py
import os
from anthropic import Anthropic
from dotenv import load_dotenv

load_dotenv()
client = Anthropic(api_key=os.environ["ANTHROPIC_API_KEY"])

response = client.messages.create(
    model="claude-sonnet-4-6",          # เลือกโมเดลตามงาน (ดูวันที่ 1)
    max_tokens=1024,
    system="คุณคือผู้ช่วยนักพัฒนา ตอบกระชับ ตรงประเด็น",
    messages=[
        {"role": "user", "content": "อธิบาย idempotency ใน REST API สั้น ๆ"}
    ],
)

print(response.content[0].text)
print("ใช้ token:", response.usage.input_tokens, "+", response.usage.output_tokens)
```

โครงสร้างการเรียกเหมือนกันแทบทุกค่าย ต่างที่ชื่อ field เล็กน้อย:

```python
# เทียบกับ OpenAI
from openai import OpenAI
client = OpenAI()
resp = client.chat.completions.create(
    model="gpt-5.5",
    messages=[
        {"role": "system", "content": "คุณคือผู้ช่วยนักพัฒนา"},
        {"role": "user", "content": "อธิบาย idempotency สั้น ๆ"},
    ],
)
print(resp.choices[0].message.content)
```

### 12.2 พารามิเตอร์สำคัญที่ต้องเข้าใจ

| พารามิเตอร์ | ความหมาย | แนวทางตั้งค่า |
| --- | --- | --- |
| **model** | เลือกโมเดล | งานยากใช้ flagship, งาน bulk ใช้ตัวเล็ก |
| **max_tokens** | จำกัดความยาวคำตอบ | ตั้งพอดีงาน คุมต้นทุน |
| **temperature** | ความสุ่ม/สร้างสรรค์ (0-1) | งานโค้ด/สกัดข้อมูล ตั้งต่ำ (0-0.3), งานเขียนสร้างสรรค์ ตั้งสูง |
| **system** | บทบาท/กติกาถาวร | กำหนด persona และข้อจำกัด |
| **stop / stop_sequences** | ให้หยุดเมื่อเจอสตริง | คุมรูปแบบ output |

> 💡 **สำหรับงาน Dev ส่วนใหญ่ ตั้ง temperature ต่ำ** เพราะเราต้องการคำตอบที่แม่นและทำซ้ำได้ ไม่ใช่ความหลากหลาย

### 12.3 Structured Output (JSON Mode) - หัวใจของการต่อ AI เข้าระบบ

แอปจริงต้องการ "ข้อมูลที่ parse ได้" ไม่ใช่ข้อความอิสระ เราบังคับให้ LLM คืน JSON ตาม schema แล้ว validate ด้วย **Pydantic**

```python
# structured_output.py
import os, json
from anthropic import Anthropic
from pydantic import BaseModel, ValidationError
from dotenv import load_dotenv

load_dotenv()
client = Anthropic()

# 1) นิยาม schema ที่เราต้องการ
class Ticket(BaseModel):
    category: str        # bug | feature | question
    priority: str        # low | medium | high
    summary: str
    needs_human: bool

# 2) สั่ง LLM ให้ตอบเป็น JSON ตาม schema
prompt = """จัดหมวดข้อความสนับสนุนนี้ แล้วตอบเป็น JSON เท่านั้น
ตามคีย์: category, priority, summary, needs_human
ข้อความ: "แอปโอนเงินค้างที่หน้ายืนยัน กดแล้วไม่ไปต่อ เกิดตั้งแต่เช้า" """

resp = client.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=512,
    messages=[{"role": "user", "content": prompt}],
)

# 3) parse + validate
raw = resp.content[0].text
try:
    ticket = Ticket.model_validate_json(raw)
    print("ผ่าน validation:", ticket)
except ValidationError as e:
    print("LLM คืน JSON ไม่ตรง schema:", e)
```

> ✅ **แนวปฏิบัติที่ดี:** อย่าเชื่อว่า LLM คืน JSON ถูกเสมอ ต้อง validate ด้วย schema จริง (Pydantic) และมี fallback เมื่อผิดรูป หลายค่ายมีโหมด "tool use / JSON schema" ที่บังคับรูปแบบได้แน่นกว่า prompt เปล่า

### 12.4 Streaming - แสดงผลทีละส่วนให้ UX ดีขึ้น

```python
# streaming.py
from anthropic import Anthropic
client = Anthropic()

with client.messages.stream(
    model="claude-sonnet-4-6",
    max_tokens=1024,
    messages=[{"role": "user", "content": "เขียนบทความสั้นเรื่อง RAG"}],
) as stream:
    for text in stream.text_stream:
        print(text, end="", flush=True)   # พิมพ์ทีละ token ทันทีที่มา
```

### 12.5 Error Handling, Rate Limit และ Retry

```python
# robust_call.py
import time
from anthropic import Anthropic, APIError, RateLimitError, APITimeoutError

client = Anthropic()

def call_with_retry(messages, max_retries=3):
    for attempt in range(max_retries):
        try:
            return client.messages.create(
                model="claude-sonnet-4-6",
                max_tokens=512,
                messages=messages,
                timeout=30,
            )
        except RateLimitError:
            wait = 2 ** attempt          # exponential backoff: 1, 2, 4 วินาที
            print(f"โดน rate limit รอ {wait}s แล้วลองใหม่")
            time.sleep(wait)
        except APITimeoutError:
            print("timeout ลองใหม่")
        except APIError as e:
            print(f"API error: {e}")
            raise
    raise RuntimeError("ล้มเหลวหลังจากลองครบแล้ว")
```

| ปัญหาที่ต้องรับมือ | วิธีจัดการ |
| --- | --- |
| Rate limit (429) | Exponential backoff + retry |
| Timeout | ตั้ง timeout + retry |
| Network error | try/except + fallback |
| Output ผิดรูป | validate + retry ด้วย prompt ที่ชัดขึ้น |

### 12.6 การจัดการต้นทุน (Token Cost)

```python
# cost_estimate.py
# ราคาเป็นตัวอย่างเชิงสาธิต - ตรวจราคาจริงจากเว็บผู้ให้บริการเสมอ
PRICE_PER_MTOK = {"input": 3.0, "output": 15.0}   # ดอลลาร์ต่อ 1 ล้าน token

def estimate_cost(input_tokens, output_tokens):
    cost = (input_tokens / 1_000_000) * PRICE_PER_MTOK["input"]
    cost += (output_tokens / 1_000_000) * PRICE_PER_MTOK["output"]
    return round(cost, 6)

print(estimate_cost(1200, 400), "USD")
```

เทคนิคลดต้นทุนที่ใช้บ่อย: เลือกโมเดลให้พอดีงาน, ตัด context ที่ไม่จำเป็น, ใช้ **prompt caching** สำหรับบริบทที่ซ้ำ, และตั้ง `max_tokens` พอดี (เจาะลึกเรื่องนี้อีกครั้งในวันที่ 5 หัวข้อ LLMOps)

---

## 📚 Module 13: RAG ระดับ Production

### เวลา 11:15-12:00 น. และ 13:00-13:45 น.

> 💡 **หัวใจของ Module นี้:** เมื่อวานเราทำ RAG แบบ no-code วันนี้เราเปิดฝากระโปรงเขียนเองทุกขั้น เพื่อ "ควบคุมคุณภาพและ citation ได้จริง" ซึ่งเป็นสิ่งที่ระบบ production ต้องการ

---

### 13.1 สถาปัตยกรรม RAG แบบเต็ม

```text
━━━━━━━━━ Indexing (ทำครั้งเดียว/เป็นระยะ) ━━━━━━━━━
[Ingest]    โหลดเอกสาร (PDF, MD, HTML, DB)
   │
[Chunk]     ตัดเป็นชิ้นขนาดพอดี + overlap
   │
[Embed]     แปลงแต่ละชิ้นเป็นเวกเตอร์ (Embedding)
   │
[Store]     เก็บเวกเตอร์ + เนื้อหา + metadata ใน Vector DB

━━━━━━━━━ Query (ตอน runtime) ━━━━━━━━━
[Embed]     แปลงคำถามเป็นเวกเตอร์
   │
[Retrieve]  ค้นชิ้นที่คล้ายที่สุด k ชิ้น (semantic search)
   │
[Generate]  ส่งคำถาม + ชิ้นที่เจอ ให้ LLM ตอบ + อ้างอิงแหล่ง
```

### 13.2 Embeddings และ Vector Database

**Embedding** คือการแปลง "ความหมาย" ของข้อความเป็นเวกเตอร์ตัวเลข ข้อความที่ความหมายใกล้กันจะมีเวกเตอร์ใกล้กันในปริภูมิ ทำให้ "ค้นด้วยความหมาย" ได้ ไม่ใช่แค่ match คำ

| Vector DB | ลักษณะ | เหมาะกับ |
| --- | --- | --- |
| **Chroma** | ฝังในแอป ใช้ง่าย | เรียนรู้/prototype (เราใช้วันนี้) |
| **pgvector** | ส่วนขยายของ PostgreSQL | ทีมที่มี Postgres อยู่แล้ว |
| **Qdrant** | เร็ว scale ดี | production ขนาดกลาง-ใหญ่ |
| **Pinecone** | managed service | ไม่อยากดูแล infra เอง |

### 13.3 สร้าง RAG ด้วย Python (ครบวงจร)

**ขั้นที่ 1 - Chunk เอกสาร**

```python
# rag_chunk.py
def chunk_text(text, chunk_size=500, overlap=50):
    """ตัดข้อความเป็นชิ้น พร้อม overlap กันความหมายขาดตอน"""
    chunks = []
    start = 0
    while start < len(text):
        end = start + chunk_size
        chunks.append(text[start:end])
        start = end - overlap          # ถอยกลับ overlap ตัวอักษร
    return chunks
```

> 💡 **Chunking Strategy สำคัญมาก:** ชิ้นเล็กไป = ขาดบริบท, ใหญ่ไป = เจือจาง/เปลือง token การมี overlap ช่วยไม่ให้ประโยคสำคัญถูกตัดขาด งานจริงมักตัดตามโครงสร้าง (หัวข้อ/ย่อหน้า) แทนการนับตัวอักษรตรง ๆ

**ขั้นที่ 2 - Embed และ Store ใน Chroma**

```python
# rag_index.py
import chromadb
from sentence_transformers import SentenceTransformer
from rag_chunk import chunk_text

embedder = SentenceTransformer("all-MiniLM-L6-v2")   # โมเดล embedding รันในเครื่อง
db = chromadb.PersistentClient(path="./rag_store")
collection = db.get_or_create_collection("handbook")

documents = {
    "leave-policy.md": "พนักงานมีสิทธิลาพักร้อน 15 วันต่อปี ...",
    "it-security.md":  "ห้ามใช้รหัสผ่านซ้ำ ต้องเปลี่ยนทุก 90 วัน ...",
}

for doc_name, content in documents.items():
    for i, chunk in enumerate(chunk_text(content)):
        vector = embedder.encode(chunk).tolist()
        collection.add(
            ids=[f"{doc_name}-{i}"],
            embeddings=[vector],
            documents=[chunk],
            metadatas=[{"source": doc_name, "chunk": i}],
        )

print("จำนวนชิ้นที่ index แล้ว:", collection.count())
```

**ขั้นที่ 3 - Retrieve + Generate พร้อม Citation**

```python
# rag_query.py
import chromadb
from anthropic import Anthropic
from sentence_transformers import SentenceTransformer

embedder = SentenceTransformer("all-MiniLM-L6-v2")
db = chromadb.PersistentClient(path="./rag_store")
collection = db.get_collection("handbook")
client = Anthropic()

def answer(question, k=3):
    # 1) ค้นชิ้นที่เกี่ยวข้อง
    q_vec = embedder.encode(question).tolist()
    results = collection.query(query_embeddings=[q_vec], n_results=k)
    chunks = results["documents"][0]
    sources = [m["source"] for m in results["metadatas"][0]]

    # 2) ประกอบ context พร้อมกำกับแหล่ง
    context = "\n\n".join(f"[{s}] {c}" for s, c in zip(sources, chunks))

    # 3) ให้ LLM ตอบเฉพาะจาก context + อ้างอิง
    prompt = f"""ตอบคำถามโดยอ้างอิง "เฉพาะ" จากบริบทด้านล่าง
ถ้าไม่มีข้อมูลให้บอกว่า "ไม่พบข้อมูลในเอกสาร" และอ้างชื่อแหล่ง [ชื่อไฟล์] ที่ใช้ตอบ

บริบท:
{context}

คำถาม: {question}"""

    resp = client.messages.create(
        model="claude-sonnet-4-6",
        max_tokens=512,
        messages=[{"role": "user", "content": prompt}],
    )
    return resp.content[0].text

print(answer("ลาพักร้อนได้กี่วันต่อปี"))
```

### 13.4 เทคนิคปรับคุณภาพการค้นคืน

| เทคนิค | ปัญหาที่แก้ | สรุปวิธี |
| --- | --- | --- |
| **Chunking ตามโครงสร้าง** | ชิ้นขาดบริบท | ตัดตามหัวข้อ/ย่อหน้า ไม่ใช่ตัวอักษร |
| **Hybrid Search** | คำเฉพาะ (ชื่อ/รหัส) หาไม่เจอ | ผสม keyword search + semantic |
| **Re-ranking** | ชิ้นที่เจอไม่เรียงตามความเกี่ยว | ให้โมเดลจัดอันดับชิ้นซ้ำอีกที |
| **Metadata filtering** | ค้นข้ามหมวดที่ไม่เกี่ยว | กรองด้วย metadata ก่อนค้น |

### 13.5 ลด Hallucination ด้วย Grounding และ Citation

หัวใจของ RAG production คือ "ตอบจากแหล่งจริงและตรวจสอบที่มาได้": บังคับให้อ้างอิง `[แหล่ง]`, สั่งให้ตอบ "ไม่พบข้อมูล" เมื่อ context ไม่มีคำตอบ, และแสดงชิ้นที่ใช้ตอบให้ผู้ใช้ตรวจได้ ทั้งหมดนี้ทำให้ระบบน่าเชื่อถือพอสำหรับงานองค์กร

> ⚠️ **สำหรับธนาคาร:** RAG ที่ตอบลูกค้า/พนักงานต้องมี citation เสมอ และต้องมี guardrail ปฏิเสธคำถามนอกขอบเขต (เชื่อมกับวันที่ 5)

---

## 📚 Module 14: Tool/Function Calling & การสร้าง AI Agent

### เวลา 13:45-14:45 น.

> 💡 **หัวใจของ Module นี้:** LLM ตอบข้อความได้อย่างเดียวไม่พอ Tool Calling ทำให้มัน "ลงมือทำ" ได้ เช่น query ข้อมูล เรียก API คำนวณ เมื่อรวมกับการวนซ้ำ(loop) มันจะกลายเป็น Agent ที่แก้ปัญหาหลายขั้นได้เอง

---

### 14.1 Tool/Function Calling ทำงานอย่างไร

```text
1) เราบอก LLM ว่า "มีเครื่องมืออะไรบ้าง" (ชื่อ + คำอธิบาย + schema พารามิเตอร์)
2) LLM ตัดสินใจว่า "ต้องใช้เครื่องมือไหน ด้วย argument อะไร" (คืนมาเป็น structured)
3) โค้ดเรา (ไม่ใช่ LLM) เป็นคนรันเครื่องมือจริง แล้วส่งผลกลับให้ LLM
4) LLM ใช้ผลนั้นตอบผู้ใช้ (หรือเรียกเครื่องมือต่อ)
```

> 📌 จุดสำคัญ: **LLM ไม่ได้รันโค้ดเอง** มันแค่ "บอกว่าจะเรียกอะไร" โค้ดเราเป็นคนรัน นี่คือจุดคุมความปลอดภัย เราเลือกได้ว่าจะให้ทำอะไรจริง

### 14.2 ตัวอย่าง Tool Calling ด้วย Python

```python
# tool_calling.py
import os, json
from anthropic import Anthropic
from dotenv import load_dotenv

load_dotenv()
client = Anthropic()

# 1) ฟังก์ชันจริงที่เราให้ LLM เรียก
def get_exchange_rate(base: str, quote: str) -> dict:
    # ในงานจริงจะเรียก API ธนาคารกลาง ที่นี่ใช้ค่าจำลอง
    rates = {("USD", "LAK"): 21500.0, ("THB", "LAK"): 600.0}
    return {"pair": f"{base}/{quote}", "rate": rates.get((base, quote), 0.0)}

# 2) ประกาศ tool schema ให้ LLM รู้จัก
tools = [{
    "name": "get_exchange_rate",
    "description": "ดึงอัตราแลกเปลี่ยนระหว่างสองสกุลเงิน",
    "input_schema": {
        "type": "object",
        "properties": {
            "base":  {"type": "string", "description": "สกุลเงินต้นทาง เช่น USD"},
            "quote": {"type": "string", "description": "สกุลเงินปลายทาง เช่น LAK"},
        },
        "required": ["base", "quote"],
    },
}]

messages = [{"role": "user", "content": "1000 ดอลลาร์เป็นกีบได้เท่าไร"}]

# 3) เรียก LLM รอบแรก - มันจะขอใช้ tool
resp = client.messages.create(
    model="claude-sonnet-4-6", max_tokens=512, tools=tools, messages=messages,
)

# 4) ถ้า LLM ขอใช้ tool ให้รันจริงแล้วส่งผลกลับ
if resp.stop_reason == "tool_use":
    tool_use = next(b for b in resp.content if b.type == "tool_use")
    result = get_exchange_rate(**tool_use.input)      # โค้ดเรารันเอง

    messages.append({"role": "assistant", "content": resp.content})
    messages.append({"role": "user", "content": [{
        "type": "tool_result",
        "tool_use_id": tool_use.id,
        "content": json.dumps(result),
    }]})

    final = client.messages.create(
        model="claude-sonnet-4-6", max_tokens=512, tools=tools, messages=messages,
    )
    print(final.content[0].text)
```

### 14.3 จาก Tool Calling สู่ AI Agent: วนซ้ำจนจบงาน

Agent คือ Tool Calling ที่ "วนซ้ำ" - LLM เรียกเครื่องมือ ดูผล ตัดสินใจเรียกต่อ จนกว่างานจะเสร็จ

```text
        ┌──────── Agent Loop ────────┐
  ผู้ใช้ ─▶ LLM ─▶ ต้องใช้ tool? ─ใช่─▶ รัน tool ─▶ ส่งผลกลับ ─┐
              ▲                                              │
              └──────────────────────────────────────────────┘
                            │ไม่
                            ▼
                       ตอบผู้ใช้ (จบ)
```

```python
# simple_agent.py  (โครงสร้าง agent loop แบบย่อ)
def run_agent(user_input, tools, tool_funcs, max_steps=5):
    messages = [{"role": "user", "content": user_input}]
    for step in range(max_steps):                  # กันวน infinite
        resp = client.messages.create(
            model="claude-sonnet-4-6", max_tokens=1024,
            tools=tools, messages=messages,
        )
        if resp.stop_reason != "tool_use":
            return resp.content[0].text             # ไม่ต้องใช้ tool แล้ว = จบ

        messages.append({"role": "assistant", "content": resp.content})
        for block in resp.content:
            if block.type == "tool_use":
                result = tool_funcs[block.name](**block.input)
                messages.append({"role": "user", "content": [{
                    "type": "tool_result",
                    "tool_use_id": block.id,
                    "content": str(result),
                }]})
    return "ถึงขีดจำกัดจำนวนขั้นแล้ว"
```

> ⚠️ **กัน Agent วนไม่จบ:** ตั้ง `max_steps` เสมอ และ log ทุกการเรียก tool เพื่อตรวจสอบย้อนหลังได้ (เชื่อมกับ Observability วันที่ 5)

### 14.4 รูปแบบสถาปัตยกรรม Agent

| รูปแบบ | ลักษณะ | เหมาะกับ |
| --- | --- | --- |
| **Single-agent** | Agent เดียวมีหลาย tool | งานทั่วไป เข้าใจง่าย เริ่มจากตรงนี้ |
| **Multi-agent** | หลาย agent เชี่ยวชาญต่างกัน ทำงานร่วม | งานซับซ้อนที่แบ่งบทบาทได้ (planner/coder/reviewer) |
| **Workflow Orchestration** | กำหนดขั้นตอนตายตัว + AI ในบางจุด | งานที่ต้องคาดเดาได้ ควบคุมสูง |

> ✅ **คำแนะนำเชิงปฏิบัติ (จาก Anthropic - Building Effective Agents):** เริ่มจากสิ่งที่ง่ายที่สุดที่ได้ผล อย่ารีบทำ multi-agent ถ้า single-agent + tool ดี ๆ ก็พอ ความซับซ้อนต้องแลกด้วยความน่าเชื่อถือที่ตรวจสอบยากขึ้น

### 14.5 ภาพรวม Framework สำหรับสร้าง Agent

| Framework | จุดเด่น | เหมาะกับ |
| --- | --- | --- |
| **LangChain** | ครบเครื่อง มี integration เยอะ | ต่อหลายเครื่องมือ/หลายแหล่งข้อมูล |
| **LlamaIndex** | เน้น RAG/data framework | ระบบค้นคืนเอกสารเป็นหลัก |
| **LangGraph** | คุม flow แบบ graph/state machine | Agent ที่ต้องการ control flow ชัดเจน |

> 📌 หลักสูตรนี้สอน "หลักการดิบ" (เขียน loop เอง) ก่อน เพื่อให้เข้าใจว่า framework ช่วยอะไร แล้วค่อยเลือกใช้ framework ตามงาน ไม่ใช่เริ่มจาก framework โดยไม่เข้าใจข้างใน

---

## 📚 Module 15: สร้าง MCP Server ของตัวเอง

### เวลา 15:00-15:45 น.

> 💡 **หัวใจของ Module นี้:** วันที่ 2 เราเป็น "ผู้ใช้" MCP Server วันนี้เราเป็น "ผู้สร้าง" เปิดเครื่องมือ/ข้อมูลขององค์กรออกมาให้ AI Agent เรียกใช้อย่างเป็นมาตรฐานและปลอดภัย

---

### 15.1 ทบทวนและยกระดับสู่การเป็นผู้สร้าง

MCP Server ที่เราสร้างจะเปิด 3 สิ่งให้ AI: **Tools** (ฟังก์ชันให้เรียก), **Resources** (ข้อมูลให้อ่าน), **Prompts** (เทมเพลตสำเร็จรูป) เมื่อสร้างเสร็จ Host ใด ๆ ที่รองรับ MCP (Claude Code, Cursor) ก็เรียกใช้ได้ทันที

### 15.2 เขียน MCP Server ด้วย Python

```python
# my_mcp_server.py
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("bank-tools")          # ชื่อ server

# --- Tool: ฟังก์ชันที่ AI เรียกได้ ---
@mcp.tool()
def calculate_loan_payment(principal: float, annual_rate: float, months: int) -> dict:
    """คำนวณค่างวดผ่อนต่อเดือน (flat-rate อย่างง่ายเพื่อการสอน)"""
    monthly_rate = annual_rate / 100 / 12
    if monthly_rate == 0:
        payment = principal / months
    else:
        payment = principal * monthly_rate / (1 - (1 + monthly_rate) ** -months)
    return {"monthly_payment": round(payment, 2), "months": months}

# --- Resource: ข้อมูลที่ AI อ่านได้ ---
@mcp.resource("config://interest-rates")
def get_rates() -> str:
    """อัตราดอกเบี้ยปัจจุบัน (ข้อมูลจำลอง)"""
    return "สินเชื่อบ้าน 6.5%, สินเชื่อส่วนบุคคล 12%, เงินฝากประจำ 3%"

# --- Prompt: เทมเพลตสำเร็จรูป ---
@mcp.prompt()
def loan_advice(income: float) -> str:
    return f"ลูกค้ารายได้ {income} ต่อเดือน ช่วยแนะนำวงเงินกู้ที่เหมาะสมและปลอดภัย"

if __name__ == "__main__":
    mcp.run()      # รันด้วย stdio transport
```

### 15.3 ทดสอบและเชื่อม MCP Server กับ Host

```bash
# ทดสอบด้วย MCP inspector (มากับ mcp[cli])
mcp dev my_mcp_server.py
```

เชื่อมกับ Host เช่น Claude Code โดยเพิ่ม config:

```json
{
  "mcpServers": {
    "bank-tools": {
      "command": "python",
      "args": ["/path/to/my_mcp_server.py"]
    }
  }
}
```

### 15.4 การออกแบบ Tools/Resources/Prompts ที่ดี

| หลักการ | เหตุผล |
| --- | --- |
| ตั้งชื่อและคำอธิบายให้ชัด | AI เลือกใช้ tool ถูกต้องขึ้นจากคำอธิบาย |
| กำหนด schema พารามิเตอร์แน่น | ลดการส่ง argument ผิด |
| tool ทำสิ่งเดียวชัดเจน | ประกอบง่าย ตรวจสอบง่าย |
| คืน error ที่อ่านเข้าใจ | AI แก้เองต่อได้ |

### 15.5 ความปลอดภัยและการจัดการสิทธิ์ของ MCP Server

```text
[ ] Least privilege - เปิดเฉพาะ tool/data ที่จำเป็น
[ ] Read-only ก่อน - ระวัง tool ที่เขียน/ลบ/โอน
[ ] Validate input - อย่าเชื่อ argument จาก LLM ดิบ ๆ
[ ] Authentication - ตรวจสิทธิ์ก่อนให้เรียก tool สำคัญ
[ ] Audit log - บันทึกทุกการเรียก tool เพื่อตรวจย้อนหลัง
[ ] Human approval - tool ที่มีผลกระทบสูงต้องให้คนยืนยัน
```

> ⚠️ **สำหรับธนาคาร:** อย่าเปิด tool ที่ "โอนเงิน/แก้ยอด" ให้ AI เรียกอัตโนมัติ ถ้าจำเป็นต้องมีขั้นยืนยันโดยมนุษย์และ audit log ครบเสมอ

---

## 🛠️ Workshop Day 4 - ประกอบระบบ AI ด้วย Python

### เวลา 15:45-16:30 น.

> **เป้าหมาย:** ให้ผู้เรียนเขียนโค้ด Python ทำงานได้จริง ครอบคลุม LLM API, RAG, Agent และ MCP Server (เลือกทำตามเวลาที่มี ผลงานนี้จะถูกต่อยอดเป็น Capstone วันที่ 5)

---

### 🧪 Lab 4.1 - LLM API + Structured Output

```text
[ ] เขียนสคริปต์เรียก LLM จัดหมวดข้อความ (bug/feature/question)
[ ] บังคับ output เป็น JSON แล้ว validate ด้วย Pydantic
[ ] เพิ่ม retry + backoff เมื่อเจอ error
[ ] พิมพ์ต้นทุน token โดยประมาณของแต่ละครั้ง
```

### 🧪 Lab 4.2 - สร้าง Mini-RAG จากเอกสารของผู้เรียน

```text
[ ] เตรียมเอกสาร 3-5 ไฟล์ (ข้อมูลจำลอง)
[ ] Chunk → Embed → Store ใน Chroma
[ ] เขียนฟังก์ชัน answer() ที่ retrieve + generate + อ้างอิงแหล่ง
[ ] ทดสอบคำถามที่มี/ไม่มีคำตอบ ตรวจว่าตอบ "ไม่พบข้อมูล" ถูกต้อง
```

### 🧪 Lab 4.3 - สร้าง AI Agent ที่ใช้เครื่องมือ

```text
[ ] สร้าง tool อย่างน้อย 2 ตัว (เช่น คำนวณ + ค้นข้อมูลจำลอง)
[ ] เขียน agent loop พร้อม max_steps กันวนไม่จบ
[ ] ให้ Agent แก้โจทย์ที่ต้องใช้หลาย tool ต่อกัน
[ ] log ทุกการเรียก tool เพื่อตรวจสอบ
```

### 🛠️ Workshop หลัก - MCP Server ของทีม + เชื่อมกับ Agent

```text
[ ] สร้าง MCP Server ที่มี tool 1-2 ตัวสำหรับงานทีม (ข้อมูลจำลอง)
[ ] เพิ่ม resource และ prompt อย่างละหนึ่ง
[ ] ทดสอบด้วย mcp dev แล้วเชื่อมกับ Host (Claude Code/Cursor)
[ ] สั่ง Agent ใช้ tool จาก MCP Server ที่เราสร้าง
[ ] ใส่ validation + audit log ตาม checklist ความปลอดภัย
```

### 🧩 ความท้าทายเสริม (ถ้าทำเสร็จก่อนเวลา)

- ต่อ RAG เข้ากับ Agent: ทำ tool ชื่อ `search_docs` ที่เรียกระบบ RAG ของ Lab 4.2
- ลองใช้ LangChain หรือ LlamaIndex ทำ RAG เดียวกัน แล้วเทียบกับที่เขียนเอง
- เพิ่ม Hybrid Search (keyword + semantic) ให้ retrieval แม่นขึ้น

---

## 📝 สรุปประจำวันที่ 4

| หัวข้อ | สิ่งที่ทำได้แล้ว |
| --- | --- |
| Module 12 - LLM API | เรียก LLM, Structured Output, streaming, error handling, cost |
| Module 13 - RAG Production | สร้าง RAG ครบวงจรด้วย Chroma + embedding + citation |
| Module 14 - Tool/Agent | Tool Calling และ agent loop ที่ใช้เครื่องมือหลายขั้น |
| Module 15 - MCP Server | สร้าง MCP Server เปิด Tools/Resources/Prompts อย่างปลอดภัย |
| ★ Workshop Day 4 | ประกอบ LLM API + RAG + Agent + MCP ด้วย Python จริง |

### ✅ ตรวจสอบความพร้อมก่อนวันพรุ่งนี้ (Capstone)

> ให้แน่ใจว่า:
>
> - มีระบบ RAG หรือ AI Agent ที่รันได้จริงจากวันนี้ (จะใช้ต่อใน Capstone)
> - เข้าใจ agent loop และ Tool Calling ระดับเขียนเองได้
> - สร้าง MCP Server ง่าย ๆ และเชื่อมกับ Host เป็น
> - โค้ดทั้งหมดเก็บใน repo เรียบร้อย (ไม่มี API Key หลุด)
> - เตรียมไอเดีย Capstone: จะสร้างแอป AI อะไร แก้ปัญหาอะไร

---

**💡 คำคมประจำวัน:**

> "เขียน RAG และ Agent เองสักครั้ง แล้วคุณจะเลิกกลัว AI และเริ่มออกแบบมันเป็น - เพราะข้างในมันคือวิศวกรรมที่เราควบคุมได้ ไม่ใช่เวทมนตร์"

---

## 📖 References วันที่ 4

- Anthropic - API Documentation (Messages): https://docs.claude.com/en/docs/build-with-claude/overview
- Anthropic - Tool Use Overview: https://docs.claude.com/en/docs/agents-and-tools/tool-use/overview
- Anthropic - Building Effective Agents: https://www.anthropic.com/research/building-effective-agents
- OpenAI - API Reference: https://platform.openai.com/docs/api-reference
- Model Context Protocol - Build a Server: https://modelcontextprotocol.io/quickstart/server
- Chroma - Documentation: https://docs.trychroma.com/
- Sentence-Transformers: https://www.sbert.net/
- LangChain: https://python.langchain.com/ | LlamaIndex: https://docs.llamaindex.ai/ | LangGraph: https://langchain-ai.github.io/langgraph/

---

_เอกสารจัดทำโดย: อาจารย์สามิตร โกยม | IT Genius Engineering Co., Ltd._
_สำหรับการอบรม: ธนาคาร BCEL (สปป.ลาว)_
_หลักสูตร Generative AI for Software Developer (ฉบับ 5 วัน 2026) - วันที่ 4 จาก 5_
