---
name: plain-language-iso-24495
description: Write documents that conform to ISO 24495-1:2023 (Plain Language — Governing principles and guidelines). Use when the user asks for a document, memo, proposal, RFC, PRD, design doc, runbook, postmortem, one-pager, or explanation to be written in "plain language", "clear language", "accessible language", or "ISO 24495"; when they ask a document to be understandable by a mixed or non-specialist audience; when they ask to make an existing document clearer, more readable, or easier to scan; when they mention audiences like legal, executive, or cross-functional stakeholders who need to skim and decide; or when they ask to reduce jargon.
---

# Plain language (ISO 24495-1:2023)

This skill helps you write documents that conform to ISO 24495-1:2023. The standard defines plain language as communication in which wording, structure, and design are so clear that the intended readers can easily **find**, **understand**, and **use** the information.

## When to use

Use this skill when the user asks for any of:

- A plain-language version of a document.
- A document that a mixed audience (legal, executive, engineering, non-technical) can read and act on.
- Simplification of an existing document.
- A decision memo, approval request, or proposal aimed at busy readers.
- Conformance with ISO 24495 specifically.

## The four governing principles

Every document produced with this skill must satisfy all four:

1. **Relevant** — Readers get what they need.
2. **Findable** — Readers can easily find what they need.
3. **Understandable** — Readers can easily understand what they find.
4. **Usable** — Readers can easily use the information.

## Workflow

### Step 1 — Identify the readers and pick the format (Principle 1)

Before drafting, gather from the user or infer from context:

- **Who** are the intended readers? Name roles or teams. If there are several audiences, identify the **primary** audience — their needs come first when needs conflict.
- **What** do they need to do after reading? Decide, approve, act, learn, refer back?
- **What** do they already know? Adjust vocabulary and background accordingly.
- **How** will they read it? Skim on phone in a Slack link? Deep-read in Notion? Print for a meeting?
- **How much time** do they realistically have?
- **Which language** do they read in? Confirm before drafting in English if the reader group includes non-English speakers.
- **Is a document the right format at all?** A short video, a form, a dashboard, an FAQ, or a slide can sometimes serve the reader better. Consider before defaulting to prose.

Content selection ethics apply from step 1: be accurate, do not mislead, do not hide content the reader needs.

If the user has not provided this, ask one focused question before drafting. Do not skip this step.

### Step 2 — Structure for findability (Principle 2)

Load `references/principles.md` for the detailed rules. Key structural moves:

- **Put the most important message at the top.** The reader must know the ask, the decision needed, or the answer within the first screen.
- **Group content by reader.** If there are multiple audiences, give each a labelled section they can jump to.
- **Warnings before instructions.** If failing to follow a step causes harm, warn first.
- **Chronological order for processes.** Steps in the order they happen.
- **Headings must predict content.** A reader scanning only the headings should be able to reconstruct the argument.
- **Supplementary detail goes at the end** in a clearly labelled section.
- **Apply information design.** Use prominence (bold, callouts), proximity (group related things), and similarity (same shape for same function). Use white space to separate ideas.

### Step 3 — Write for understandability (Principle 3)

- **Familiar words** over specialised ones. Keep a technical term only when the everyday word would be less accurate.
- **One idea per sentence.** Aim for an average of 15–20 words.
- **One idea per paragraph.** Front-load each paragraph with the main point.
- **Active voice.** Name the actor.
- **Direct address.** Use "you" for the reader.
- **Respectful tone.** Direct requests, not demands. No scolding, no condescension, no performative politeness ("please" and "thank you" every paragraph). In internal company writing, plain direct verbs work better than filler courtesy.
- **Include a diagram** when the content is spatial, temporal, or relational.
- **Define technical terms** on first use or in a glossary at the end.
- **Cohesion.** Same term for the same concept throughout. No synonyms.

### Step 4 — Make it usable (Principle 4)

For internal company memos, usability testing with real readers is overkill. What matters is that the reader can act on the document. Cover this by:

- **Self-reviewing with the checklist** at `references/checklist.md` before delivering.
- **Making the response mechanism explicit.** For an approval memo: "Reply with 'Approved', 'Approved with comments', or 'Not approved — need discussion'." For an RFC: point to the comment thread or decision meeting. For a runbook: name who to page.
- **Planning for revision, not testing.** If a reader comes back confused, that is the signal to revise.

For high-stakes external documents (public terms, customer-facing policy, regulator submissions), reader testing is worth it. In that case, load `references/reader-test.md`.

## Deliverable

Every document produced with this skill must include:

1. **A reader-facing headline** at the top that states what the document is and what it asks for.
2. **A "Who this is for" or "Are you the right reader?" section** listing the reader groups. If not applicable (single-audience doc), skip.
3. **The main content** grouped by reader need, not by the author's mental hierarchy.
4. **Any warnings** before the instructions they warn about.
5. **A glossary** or inline definitions for any technical term the primary reader might not know.
6. **A "Related documents" or "Where to go next" section** at the end.

## Anti-patterns to avoid

Do not do the following unless the user overrides you:

### Structure

- Do not start with background, history, or context. Start with the ask.
- Do not bury the decision needed inside a wall of text.
- Do not include meta-content about the document ("This document will explain…", "The purpose of this section is…"). Just do the thing.
- Do not use rhetorical questions as headings or openings ("Why do we need this?"). Make the statement.
- Do not nest lists more than two levels deep. Use a table instead.

### Attribution and ownership

- Do not personalise sections with specific names ("For Jane Doe") unless the user has confirmed the POC. Address by team or role — people move, roles persist. If the POC is known and stable, put the name in an ownership table, not in the section heading.
- Do not attribute ownership to more than one team without naming a primary. "Owned by Data, Analytics, and Engineering" means owned by nobody.
- Do not use author-centric framing ("I want to propose…", "We’ve been thinking…"). Lead with what the reader needs.

### Language

- Do not use synonyms for the same concept in the same document.
- Do not use passive voice when active would be shorter and clearer.
- Do not use jargon without defining it.
- Do not chain acronyms ("SRE-owned CI/CD via IaC"). Even if each is defined, the sentence becomes unreadable.
- Do not add a "TL;DR" tag — use "Summary" or a plain headline instead.
- Do not use contractions in a document meant for non-native English readers, unless the user has confirmed the audience prefers them.
- Do not add filler such as "In today’s fast-paced world" or "It goes without saying".
- Do not use marketing verbs ("leverage", "synergise", "empower", "unlock value", "drive"). Say the concrete action.
- Do not use weasel words that hide uncertainty ("we believe", "it seems", "arguably", "somewhat", "potentially"). Either state it, or state what you do not yet know.
- Do not use vague quantifiers ("a lot", "many", "significant", "recently", "soon"). Use numbers and dates.
- Do not mix modal verbs. Follow RFC 2119 discipline: "must" for requirements, "should" for strong recommendations, "may" for optional. Do not use "must", "should", "could", "would" as if they mean the same thing.

### Content

- Do not include content that is not directly relevant to the primary reader’s decision or task.
- Do not state a constraint ("we must use PostgreSQL") without the reason. The reader needs the reason to accept or challenge it.
- Do not leave success criteria vague ("we’ll monitor and iterate"). State what good looks like.
- Do not leave review requests vague ("please review and provide feedback"). State what kind of feedback and by when.
- Do not compare to strawmen. Compare to real alternatives the reader might already prefer.
- Do not use false precision. "~$50/month" is fine; "up to 40% faster" without a baseline is not.
- Do not omit dates, version, or author from the document header. Readers need to know how current the doc is.
- Do not cross-reference other documents without a link or clear identifier. "As discussed in the Q2 review" is not a reference.

### Tone

- Do not scold, condescend, or lecture.
- Do not use passive-aggressive framing ("as has been repeatedly mentioned…").
- Do not manufacture consensus ("we all agree that…"). Either it is agreed and documented, or it is not.

## Self-review before delivering

Before you present the document, run through `references/checklist.md` against it. If any item fails, revise before delivering.

## After delivering

Offer the user a revision pass if any reader comes back confused. Do not push reader testing for internal memos.

## The workflow is not sequential

The four principles are interdependent. If new reader information appears at step 3, return to step 1 and revise. Treat the workflow as a loop, not a checklist to complete once.
## Reference files

- `references/principles.md` — full detail of the four principles and their guidelines.
- `references/checklist.md` — pre-flight self-review checklist.
- `references/reader-test.md` — how to run reader evaluation. Only for high-stakes external documents; skip for internal memos.
- `assets/template.md` — a starting template you can adapt.
