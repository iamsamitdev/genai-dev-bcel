# Generative AI for Software Developer (2026 Edition — 5-Day Version)

> **IT GENIUS ENGINEERING CO., LTD.**
> Tel: 02-570-8449 | Mobile: 088-807-9770 | Line ID: @itgenius
> www.itgenius.co.th | contact@itgenius.co.th

---

## Course Overview

The year 2026 marks a turning point for software development, shifting from the era of "AI code autocomplete" to the era of **Agentic Software Engineering**, where AI can plan, write, modify, test, and deliver features semi-autonomously under a developer's supervision. Modern developers no longer compete on "how fast they can type code," but on their ability to **communicate intent**, **engineer context (Context Engineering)**, and **direct AI agents** to work correctly, safely, and with high quality.

This 5-day edition of the **"Generative AI for Software Developer"** course extends the 3-day edition by adding **two in-depth days on AI Engineering and bringing AI systems to Production (LLMOps)**. It is ideal for those who want to move from "using AI to assist development" to "building real AI-powered applications." It covers LLM fundamentals, Prompt/Context Engineering techniques, using AI Coding Agents, connecting via MCP, building AI-core applications (RAG, Tool Calling, AI Agents), through to evaluation, setting up Guardrails/Security, and deploying to production — concluded with a **Capstone Project** in which learners build a real system from start to finish.

---

## Course Objectives

- Understand the fundamentals of Generative AI, LLMs, Transformers, and Reasoning Models, along with the capabilities and limitations of 2026-era models
- Compare and select leading models appropriately for each task (Claude, GPT, Gemini, and open-source models)
- Advance from **Prompt Engineering** to **Context Engineering** to instruct AI to design, write, analyze, and modify code accurately
- Use **AI Coding Agents** in a real development workflow — from planning, writing code, refactoring, and writing tests, to code review
- Connect AI to organizational tools and data sources via **MCP (Model Context Protocol)**
- **Build AI-powered applications** using RAG, Tool/Function Calling, and composing AI Agents
- **Evaluate, test, and bring AI systems to production** with LLMOps, Evaluation, Observability, and Guardrails
- Understand best practices for security, reliability, and governance when using AI in real software development

---

## Course Highlights

- **Updated for 2026**, covering the latest models such as Claude Opus 4.8 / Sonnet 4.6, GPT-5.5, and Gemini 3.5, as well as Agentic Coding tools used in the industry
- **In-depth 5-day edition** adding two days on **AI Engineering** and **Production/LLMOps** that take learners from "AI users" to "AI system builders"
- Elevates content from "AI helps write code" to **"Agentic Software Engineering"**, reflecting how modern development teams work
- Important new topics: **AI Coding Agents**, **MCP**, **AI Code Review**, **Production-grade RAG**, **AI Agents**, **LLMOps**, **Evaluation**, and **AI Security/Guardrails**
- Learn through real tools: Claude (Claude Code), ChatGPT, Gemini, GitHub Copilot Agent Mode, Cursor, Windsurf, MCP Servers, Vector Databases, and AI Orchestration Frameworks
- Hands-on workshops every day, concluding with a **Capstone Project** that builds a real AI system from design to deployment

---

## Target Audience

- Software Developers
- Full Stack / Backend / Frontend Developers
- DevOps Engineers and Software Architects
- Those who want to move into the **AI Engineer / AI Application Developer** track
- AI Enthusiasts and Technical Leads
- Programmers transitioning into the AI-first era
- App developers or freelancers who want to reduce development time and cost
- Instructors / Trainers / Mentors in Software Development

---

## Prerequisites

- Basic English at a read-and-write level (fluency not required)
- Prior programming experience, e.g., Python, JavaScript, TypeScript, Java, or any language (for Days 4-5, familiarity with Python or Node.js is recommended)
- Understanding of basic software principles such as MVC, API, Database, Git
- Experience using VS Code or other IDEs for development
- Familiarity with operating systems such as Windows, macOS, or Linux

---

## Training Details

| Item | Details |
|---|---|
| **Duration** | 30 hours (5 days) |
| **Course Price** | _______ THB / person (please specify — or a negotiated flat rate) |
| **Instructor** | Mr. Samit Koyom |
| **Recommended Prerequisite Course** | None |
| **Recommended Follow-up Course** | None |

---

## Course Content

### Day 1 — Foundations: Generative AI, LLM & Context Engineering (6 hours)

#### Section 1: Generative AI & LLM Landscape in 2026
- The concept of Generative AI and its role in the Software Development Life Cycle (SDLC)
- 2026 model market overview: Claude (Opus 4.8 / Sonnet 4.6 / Haiku 4.5), GPT-5.5, Gemini 3.5, and open-source models
- Differences between Rule-based, LLM-based, and **Reasoning/Agentic Models**
- Choosing the right model for the job: capability, cost (cost/token), speed, context window, and data privacy

#### Section 2: Understanding LLMs and Transformers in Depth
- The architecture behind LLMs: Transformer, Tokenization, and Context Window
- What are Reasoning Models and "Thinking," and how do they differ from previous generations
- RLHF and Post-training: how they make AI follow instructions and become safer
- Understanding Hallucination and the technical reasons AI gives wrong answers

#### Section 3: From Prompt Engineering to Context Engineering for Developers
- Principles of good prompts: Clear, Specific, Role-based, Few-shot
- **Context Engineering**: managing context, knowledge files, and system prompts so AI understands the project
- Prompt structures for dev tasks: Coding, Debugging, Explain Code, Refactor, Unit Test
- Writing standard context files such as `AGENTS.md` and `CLAUDE.md` to set ground rules for AI agents

**Hands-on Labs:**
- Set up tools: ChatGPT, Claude, Gemini, and API keys
- Try basic prompts: Generate, Refactor, Explain, Translate Code
- Compare results from multiple models on the same problem, and write your first `AGENTS.md` file

---

### Day 2 — Agentic Coding, MCP & Software Design (6 hours)

#### Section 4: AI Coding Assistant & Agentic Coding
- Three forms of AI coding tools: Inline Suggestion → Chat Assistant → **Autonomous Agent**
- Introduction to 2026 Agentic Coding tools: **Claude Code**, **Cursor**, **GitHub Copilot Agent Mode**, **Windsurf**, **OpenAI Codex**
- Using an agent to plan and build features end-to-end (Plan → Edit → Run → Verify)
- Techniques for directing agents: providing context, reviewing changes (diffs), and controlling scope

#### Section 5: MCP — Connecting AI to Real Tools and Data
- What is the **Model Context Protocol (MCP)**, and why it's called "the USB-C of the AI world"
- MCP architecture: Host, Client, Server, and communication via JSON-RPC
- Connecting AI to GitHub, databases, file systems, and internal organizational tools via MCP Servers
- Security and access-control practices when letting AI connect to real data

#### Section 6: AI for Software Design & System Architecture
- Generate UML, ERD, Sequence, and Architecture Diagrams from prompts (including Mermaid/PlantUML)
- Use AI to design APIs with RESTful / GraphQL approaches and draft OpenAPI specs
- Techniques to craft prompts so AI helps design system structure and databases
- Using AI to evaluate architectural options (Trade-off Analysis)

#### Section 7: Legacy Code, Refactoring & AI Code Review
- Have AI explain old code (Explain Code) and perform reverse engineering
- Refactor / Simplify / add comments and documentation to undocumented code
- **AI Code Review**: use AI to detect bugs, security vulnerabilities, and code-quality issues before merge
- Use case: reading and improving undocumented Java / Python / TypeScript code

**Hands-on Labs:**
- Direct an AI agent to build an API + Database Schema + Diagram system end-to-end
- Install and try an MCP Server (e.g., GitHub / Filesystem) with an AI agent
- Workshop: have an agent read legacy code, summarize its behavior, refactor it, and perform code review

---

### Day 3 — AI Prototyping, Automation, Testing & Best Practices (6 hours)

#### Section 8: AI Prototyping & UI Generation
- Use AI to build UIs with HTML, Tailwind CSS, and ready-made components
- 2026 web/UI generation tools from prompts: v0, Lovable, Bolt, Framer AI, and others
- Generate static/full-stack web apps and deploy on GitHub Pages / Vercel / Netlify
- Refining and extending AI-generated code for real use

#### Section 9: AI-powered Chatbot, RAG & Assistant (Introduction)
- The concept of **RAG (Retrieval-Augmented Generation)** and why it's needed for enterprise chatbots
- Build a chatbot that answers questions from documents/internal knowledge bases
- Use Claude / ChatGPT to build a FAQ Bot and Coding Assistant
- Overview of extending with a Vector Database and Embeddings (laying the groundwork for Day 4)

#### Section 10: AI Testing, Automation & Spec-driven Development
- Use AI to write Unit Tests, Integration Tests, and generate test data
- **Spec-driven Development**: write clear specs/requirements, then have AI build and verify work against the spec
- Connecting AI to CI/CD and automation systems
- Measuring the quality and correctness of AI-generated work

#### Section 11: Best Practices, Security & Governance (for Developers)
- How to integrate AI into the Dev Lifecycle: Plan → Build → Test → Review → Deploy
- Cautions: Security, Hallucination, Data Privacy, Copyright, and code licensing
- AI governance in organizations and developer responsibility
- Building a personal and team Prompt/Context Library for reuse

**Hands-on Labs:**
- Build a web app or UI from a prompt and put it on real hosting
- Try building a basic RAG chatbot per the workshop brief
- Summarize working prompts/contexts into a personal Prompt Library

---

### Day 4 — AI Engineering: Building AI-Powered Applications (6 hours)

> **Goal of the day:** Move from "using AI to assist development" to "building applications with AI at their core" — by programmatically calling LLMs, implementing production-grade RAG, enabling AI to use tools, and composing your own AI agent.

#### Section 12: LLM API & Application Integration
- Fundamentals of calling LLMs via API: Anthropic, OpenAI, and Gemini
- Key parameters: Temperature, Max Tokens, System Prompt, Structured Output (JSON Mode)
- Designing prompt templates and managing the context window efficiently
- Streaming, Error Handling, Rate Limits, and managing token cost in real applications

#### Section 13: Production-grade RAG (Retrieval-Augmented Generation)
- The full RAG architecture: Ingest → Chunk → Embed → Store → Retrieve → Generate
- **Embeddings** and **Vector Databases** (e.g., pgvector, Qdrant, Pinecone, Chroma)
- Techniques to improve retrieval quality: chunking strategy, hybrid search, re-ranking
- Reducing hallucination through source citation/grounding

#### Section 14: Tool/Function Calling & Building AI Agents
- **Tool / Function Calling**: enabling LLMs to call functions, APIs, and databases
- The AI Agent concept: planning, tool use, and looping
- Agent architecture patterns: single-agent, multi-agent, and workflow orchestration
- Overview of frameworks for building agents (e.g., LangChain, LlamaIndex, LangGraph)

#### Section 15: Building Your Own MCP Server
- Review MCP architecture and step up from "user" to "builder"
- Developing an MCP Server to expose your organization's tools/data to AI agents
- Designing Tools, Resources, and Prompts within an MCP Server
- Security and authorization practices for MCP Servers

**Hands-on Labs:**
- Write a program that calls an LLM API with Structured Output
- Build a small RAG system that answers questions from learners' own documents
- Build an AI agent that calls tools (e.g., search / calculate / call an API)
- Develop a simple MCP Server and connect it to an AI agent

---

### Day 5 — Production, LLMOps, Evaluation & Capstone (6 hours)

> **Goal of the day:** Bring the AI systems you built into real use reliably, safely, and cost-effectively — covering evaluation, monitoring, guardrails, and deployment — concluding with a Capstone Project.

#### Section 16: Evaluation & Testing of AI Systems
- Why AI systems are harder to test than ordinary programs (non-deterministic)
- Designing evaluation sets (eval sets) and metrics for LLM/RAG
- **LLM-as-a-Judge** and automated evaluation
- Regression testing when changing models or prompts

#### Section 17: LLMOps & Observability
- The LLMOps lifecycle: Prompt/Model versioning, deployment, and monitoring
- Tracking cost, latency, and answer quality in production
- Logging, tracing, and observability for LLM-powered apps
- Techniques to reduce cost and improve performance: caching, routing, model selection

#### Section 18: AI Security, Guardrails & Responsible AI
- LLM-specific threats: **Prompt Injection**, Jailbreak, Data Leakage (referencing OWASP Top 10 for LLM)
- Implementing **Guardrails**: input/output validation, content filtering, and policy
- Data privacy and handling sensitive data (PII)
- Responsible AI principles: bias, transparency, and accountability in deployment

#### Section 19: Deployment & Capstone Project
- Approaches to deploying AI systems: Serverless, Container, and Managed Platform
- Designing AI app architecture for scalability and reliability
- Delivering and maintaining AI systems after go-live
- Wrap-up lessons and a self-development path toward becoming an AI Engineer

**Hands-on Labs & Capstone:**
- Build an eval set and evaluate the quality of the RAG/Agent built on Day 4
- Attempt a Prompt Injection attack and implement guardrails to defend against it
- **Capstone Project:** build an AI-powered application end-to-end (design → build RAG/Agent → evaluate → add guardrails → deploy) and present the result

---

## Summary of Changes from the 2025 Version and the 3-Day Edition

| Aspect | 2025 Version (Original) | 2026 Edition (5-Day) |
|---|---|---|
| Main theme | AI helps write code (prompt-based) | Agentic Software Engineering + **AI Engineering & Production** |
| Duration | 18 hours (3 days) | **30 hours (5 days)** |
| Reference models | GPT-4o, Claude 3, Copilot Workspace | Claude Opus 4.8 / Sonnet 4.6, GPT-5.5, Gemini 3.5 |
| Core skill | Prompt Engineering | Prompt + Context Engineering + **AI Application Development** |
| Tools | ChatGPT, Claude, GitHub Copilot | + Claude Code, Cursor, Copilot Agent, Windsurf, MCP, Vector DB, AI Framework |
| New topics | — | MCP, AI Code Review, Spec-driven Dev, **Production RAG, AI Agents, LLMOps, Evaluation, AI Security** |
| Structure | 10 Sections | **19 Sections + Capstone Project** |

---

## References and Further Learning

Models and Tools:

- Anthropic — Claude Models Overview: https://platform.claude.com/docs/en/about-claude/models/overview
- OpenAI — Introducing GPT-5.5: https://openai.com/index/introducing-gpt-5-5/
- Google — Gemini Release Notes: https://gemini.google/release-notes/

Agentic Coding & Best Practices:

- Anthropic — Claude Code Documentation: https://docs.claude.com/en/docs/claude-code/overview
- GitHub — Copilot Documentation: https://docs.github.com/en/copilot
- Cursor — Documentation: https://docs.cursor.com/

Model Context Protocol (MCP):

- Model Context Protocol — Official Site: https://modelcontextprotocol.io/
- Model Context Protocol — Specification: https://modelcontextprotocol.io/specification/2025-11-25
- Model Context Protocol — Wikipedia: https://en.wikipedia.org/wiki/Model_Context_Protocol

AI Engineering & RAG / Agents:

- Anthropic — Building Effective Agents: https://www.anthropic.com/research/building-effective-agents
- Anthropic — API Documentation (Tool Use): https://docs.claude.com/en/docs/agents-and-tools/tool-use/overview
- LangChain — Documentation: https://python.langchain.com/
- LlamaIndex — Documentation: https://docs.llamaindex.ai/

Evaluation, LLMOps & Security:

- OpenAI — Evaluation (Evals) Guide: https://platform.openai.com/docs/guides/evals
- OWASP — Top 10 for Large Language Model Applications: https://genai.owasp.org/

> Note: Model, tool, and framework versions change rapidly. We recommend verifying the latest versions from official websites before each training session.

---

*Prepared by IT Genius Engineering Co., Ltd. — Content updated for 2026 (5-Day Edition)*
