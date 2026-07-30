# plain-language-skill

An agent skill that helps LLMs write documents conforming to [ISO 24495-1:2023](https://www.iso.org/standard/78907.html) (Plain Language — Governing principles and guidelines).

The skill is tuned for internal technical writing: memos, RFCs, PRDs, design docs, runbooks, postmortems, and one-pagers. It works in any agent harness that follows the [Agent Skills standard](https://agentskills.io) — Claude Code, Cursor, Codex, Copilot, Gemini CLI, Goose, OpenCode, and around 25 others.

MIT licensed. No dependencies.

---

## Contents

- [What the skill does](#what-the-skill-does)
- [Install](#install)
- [Use without a terminal](#use-without-a-terminal)
- [The four principles](#the-four-principles)
- [Anti-patterns the skill blocks](#anti-patterns-the-skill-blocks)
- [Document types the template adapts to](#document-types-the-template-adapts-to)
- [Repository layout](#repository-layout)
- [FAQ](#faq)
- [License](#license)

---

## What the skill does

When loaded into an agent, the skill:

1. Prompts the agent to identify the readers, their purpose, their context, and the right document format before drafting.
2. Enforces a reader-first structure — the ask at the top, warnings before instructions, team-owned sections, supporting detail last.
3. Applies the language rules from ISO 24495-1:2023 clauses 5.3.2 to 5.3.8: familiar words, one idea per sentence, active voice, consistent terminology, respectful tone, cohesive drafting.
4. Runs a 40-plus-item self-review checklist before delivering the document.
5. Provides an adaptive template for common technical document types.

The skill does not push reader testing for internal memos. It is available for the rare external document that warrants it.

---

## Install

The skill is distributed through the [skills CLI](https://github.com/vercel-labs/skills).

```bash
npx skills add nikdumroese/plain-language-skill
```

The CLI detects which agents you have installed and offers to install the skill for each. To try the skill for one session without installing:

```bash
npx skills use nikdumroese/plain-language-skill@plain-language-iso-24495
```

For a harness with no skill support, use the prompt in [`prompts/system-prompt.md`](prompts/system-prompt.md). Paste it into a system prompt, `AGENTS.md`, or `.cursorrules`.

Once installed, invoke the skill by asking for a document ("draft a decision memo for X") or by asking for a rewrite ("rewrite this using plain language").

---

## Use without a terminal

### Claude.ai (paid plans)

1. Download the file at [`skills/plain-language-iso-24495/SKILL.md`](skills/plain-language-iso-24495/SKILL.md).
2. In Claude.ai, open **Settings → Capabilities** and turn on code execution.
3. Open **Settings → Customize → Skills → Upload** and upload the `SKILL.md` file.
4. Turn the skill on.

### ChatGPT, Gemini, or another chatbot

Copy the contents of [`prompts/system-prompt.md`](prompts/system-prompt.md) into the platform's custom-instruction field.

---

## The four principles

ISO 24495-1:2023 defines plain language through four principles. A document conforms if readers can:

| Principle | Reader can | The skill enforces |
|---|---|---|
| Relevant | Get what they need | Reader identification before drafting. Format check. Cut content the reader does not need. |
| Findable | Easily find what they need | The ask goes at the top. Warnings before instructions. Team-owned sections. Supplementary detail last. Scannable headings. |
| Understandable | Easily understand what they find | Short sentences. One idea per paragraph. Active voice. Familiar words. Consistent terminology. Diagrams where prose is unclear. |
| Usable | Easily use the information | Explicit response mechanism. Self-review checklist. Date, version, and author in the header. |

The full principles and guidelines are in [`skills/plain-language-iso-24495/references/principles.md`](skills/plain-language-iso-24495/references/principles.md).

---

## Anti-patterns the skill blocks

Most plain-language guidance was written for public-sector notices. This skill is tuned for the specific failure modes of internal technical documents.

### Structure

- Starting with background or context. The ask goes first.
- "TL;DR" tags. Use a plain headline.
- Rhetorical questions as headings.
- Nested lists deeper than two levels.
- Meta-content about the document ("This document will explain...").

### Attribution

- Personalising sections with names ("For Jane Doe"). People move; roles persist.
- Ownership by more than one team without a named primary owner.
- Author-centric framing ("I want to propose...", "We have been thinking...").

### Language

- Marketing verbs: leverage, synergise, empower, unlock, drive.
- Weasel words: we believe, arguably, potentially, somewhat.
- Vague timing: soon, recently, in the coming weeks. Use dates.
- Modal verbs used interchangeably. The skill follows RFC 2119 discipline: must, should, and may are defined terms.
- Chained acronyms ("SRE-owned CI/CD via IaC"). Unreadable even when each acronym is defined.
- Synonyms for the same concept in the same document.

### Content

- Stating a constraint without its reason ("we must use PostgreSQL" — why?).
- Vague success criteria ("we will monitor and iterate").
- Vague review requests ("please review and provide feedback").
- Strawman comparisons. The skill requires comparison to real alternatives.
- Missing dates, version, or author in the header.

### Tone

- Performative politeness. "Please" every paragraph and "thank you for your time" read as filler in internal memos.
- Passive-aggressive framing ("as has been repeatedly mentioned...").
- Manufactured consensus ("we all agree that...").

The full anti-pattern list is in [`skills/plain-language-iso-24495/SKILL.md`](skills/plain-language-iso-24495/SKILL.md).

---

## Document types the template adapts to

The template at [`skills/plain-language-iso-24495/assets/template.md`](skills/plain-language-iso-24495/assets/template.md) is shaped as a decision memo by default. The skill adapts it for:

- Decision memos and approval requests (default shape).
- RFCs and design docs. The "How to respond" section becomes a comment thread or decision meeting.
- Runbooks. Condition before command, warnings before instructions.
- Postmortems. Concrete times, actions, and follow-up tickets.
- One-pagers. The reader-first structure works at any length.

The skill does not attempt to produce marketing copy, brand writing, or blog voice.

---

## Repository layout

```
skills/plain-language-iso-24495/
├── SKILL.md                       # Workflow, deliverables, anti-patterns
├── references/
│   ├── principles.md              # Full ISO 24495-1:2023 principles and guidelines
│   ├── checklist.md               # 40-plus item pre-flight self-review
│   └── reader-test.md             # Reader evaluation methods for external documents
└── assets/
    └── template.md                # Adaptive starting template
```

---

## FAQ

**Does the skill produce ISO-certified output?**
No. ISO does not certify tools or output. The skill applies the principles and guidelines from ISO 24495-1:2023 as an author would apply them.

**Does the skill replace ASD-STE100 (Simplified Technical English)?**
No. ASD-STE100 is for technical procedures where a misread instruction can cause harm. ISO 24495 is for documents where readers must find, understand, and act. Use ASD-STE100 for aircraft manuals and runbooks. Use this skill for memos, RFCs, and decision documents.

**Does the skill test documents with real readers?**
The skill does not push reader testing for internal memos. Reader testing is proportionate for external documents (public terms, customer policy, regulator submissions). The file `reader-test.md` describes how to run one when it is warranted.

**Will the output sound robotic?**
Plain language is not simplified language. It is language shaped for the reader's time. The output reads like a well-written internal memo — direct, structured, and specific.

**Why not just prompt "write clearly"?**
"Clearly" is an opinion. "The ask appears in the first screen" and "one term per concept" are specifications. Models follow specifications.

---

## License

MIT. The repository paraphrases the ISO 24495-1:2023 principles for teaching purposes and reproduces no normative text. This is an unofficial project, not affiliated with or endorsed by ISO. ISO 24495-1:2023 is copyright ISO.
