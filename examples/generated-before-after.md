# Before / after — real samples

**Generated:** 2026-07-30 11:06 CEST
**Runner:** pi 0.82.0
**Provider / model:** `github-copilot / claude-sonnet-5`

Both runs use the same model and the same prompt. Neither has access to CLAUDE.md, auto-discovered skills, or project context. The only difference is whether the plain-language skill is loaded.

Baseline command:
```
pi -p -nc -ns -nt --provider github-copilot --model claude-sonnet-5 '<prompt>'
```

With-skill command (skill content concatenated into system prompt):
```
pi -p -nc -ns -nt --append-system-prompt "$(cat <skill-files>)" --provider github-copilot --model claude-sonnet-5 '<prompt>'
```

---

## Sample 1

**Prompt:** Write a memo asking leadership to approve migrating payment processing from Stripe to Adyen. It saves cost, improves European latency, takes six weeks. Legal, Security, and Finance need to sign off.

### Baseline (no skill)

````markdown
# MEMO

**To:** Leadership Team
**From:** [Your Name], [Your Title]
**Date:** [Date]
**Re:** Approval to migrate payment processing from Stripe to Adyen

## Recommendation

Approve migrating our payment processing from Stripe to Adyen. The migration will take six weeks and requires sign-off from Legal, Security, and Finance before we start.

## Why we should switch

**Lower cost.** Adyen's pricing will reduce our payment processing fees.

**Faster payments in Europe.** Adyen processes European transactions closer to our customers, cutting latency and improving checkout speed for EU users.

## What we need from you

Approval to proceed, plus sign-off from three teams:

- **Legal** — review the Adyen contract and data terms
- **Security** — assess Adyen's security posture and our integration approach
- **Finance** — confirm the cost savings and approve the budget for migration work

## Timeline

Six weeks from approval to completion, assuming Legal, Security, and Finance sign off before work begins. We'll share a detailed schedule once approved.

## Next steps

1. Leadership approves the migration
2. Legal, Security, and Finance complete their reviews
3. Engineering begins the six-week migration

Please let me know if you have questions or need more detail before deciding.

````

### With plain-language skill

````markdown
Before I draft this, I need a few concrete details — plain language requires numbers, not vague claims, and the standard says to confirm the reader before writing.

1. **Numbers**: What's the actual cost saving (e.g., "$/month" or "%") and the actual latency improvement (e.g., "current p95 ms → target p95 ms")? I won't write "significant savings" or "faster" — I need figures or a placeholder you'll fill in.
2. **Primary reader**: Is this memo aimed at one leader (e.g., CFO or CTO) who makes the final call, with Legal/Security/Finance as required sign-offs? Or is it a joint decision by all three plus leadership?
3. **Project owner**: Who owns the migration itself (a name/team) — the person Legal/Security/Finance should route questions to?
4. **Risk/warning**: Is there anything the reader must know before approving — e.g., downtime window, dual-running period, data migration risk, contract termination cost with Stripe? Plain language puts warnings before instructions, so I need to know if one exists.
5. **Response mechanism**: How should each of Legal, Security, and Finance actually respond — reply in a thread, sign a form, attend a meeting? And by when?

Give me what you have (placeholders like "$X/month" are fine if the real number isn't settled) and I'll write the full memo.

````

---

## Sample 2

**Prompt:** Write a short RFC proposing that we adopt Temporal for background job orchestration, replacing the current mix of Sidekiq and cron. The reader is the engineering leadership team.

### Baseline (no skill)

````markdown
# RFC: Adopt Temporal for Background Job Orchestration

**Status:** Draft for discussion
**Audience:** Engineering leadership
**Author:** [Your name]
**Date:** [Date]

## Summary

We propose replacing our current background job setup — a mix of Sidekiq and cron — with Temporal. Temporal is a workflow orchestration system that handles retries, scheduling, and long-running processes in a more reliable and observable way than what we have today.

## The Problem

Our background job logic is spread across two systems that don't talk to each other:

- **Sidekiq** handles most async jobs (emails, webhooks, data processing).
- **Cron** handles scheduled tasks (nightly reports, cleanup jobs, syncs).

This split causes real problems:

1. **No unified visibility.** We can't see the full picture of a business process (e.g., "onboard a new customer") because parts of it run in Sidekiq and parts run in cron, with no shared state or tracing.
2. **Fragile multi-step workflows.** When a job needs to do several things in sequence — call an API, wait, then call another API — we hand-roll retry logic, state tracking, and failure handling in application code. This logic is duplicated and inconsistent across teams.
3. **Silent failures.** Cron jobs that fail often fail silently unless someone built custom alerting. We've had incidents where a job silently stopped running for weeks.
4. **No built-in durability.** If a Sidekiq worker crashes mid-job, we can lose progress or duplicate work, depending on how idempotent the job happens to be.
5. **Scaling scheduling is manual.** Adding a new scheduled job means editing crontab or an infra config, deploying, and hoping it's right. There's no self-service way for a team to safely add or modify schedules.

## Why Temporal

Temporal treats a "workflow" as a first-class concept, not just a series of independent jobs. It gives us:

- **Durable execution.** Workflows survive worker crashes and restarts. If a process fails halfway through a multi-step operation, Temporal resumes exactly where it left off — no manual state tracking required.
- **Built-in retries and backoff.** Retry policies are declared, not hand-coded in every job.
- **Native scheduling.** Cron-style scheduling is a built-in feature, with the same visibility and reliability as any other workflow.
- **Full visibility.** Every workflow execution, its history, current state, and failures are visible in the Temporal UI — no more digging through logs across two systems.
- **Language flexibility.** Temporal SDKs exist for our stack, and workflows can call into different services without needing everything in one codebase.

In short: Temporal gives us one system for both "run this task async" and "run this multi-step, long-lived process reliably," which is what Sidekiq + cron were being asked to do together, poorly.

## What We're Proposing

1. **Pilot first.** Pick one team and one real workflow (e.g., customer onboarding, or a multi-step data pipeline) to migrate to Temporal as a proof of concept.
2. **Run in parallel.** Sidekiq and cron stay in place during the pilot. No big-bang migration.
3. **Evaluate after 6–8 weeks** on:
   - Developer experience (how easy is it to write and debug workflows?)
   - Operational overhead (what does running Temporal cost us in infra and on-call burden?)
   - Reliability improvements (fewer silent failures, cleaner retries)
4. **If successful, phase in migration** of existing Sidekiq jobs and cron schedules over the following 2–3 quarters, prioritizing the most failure-prone or business-critical workflows first.

## What This Costs Us

- **Infrastructure.** Temporal requires its own cluster (or we use Temporal Cloud, which reduces this cost but adds a vendor dependency).
- **Learning curve.** Engineers will need to learn Temporal's workflow/activity model, which is a different mental model than "just write a job."
- **Migration effort.** Existing jobs need to be rewritten as Temporal workflows/activities, not just moved as-is.
- **Two systems running at once, temporarily.** During migration we'll have some complexity overhead from running both Sidekiq and Temporal.

## What We Get in Return

- Fewer silent failures and 2am pages caused by jobs quietly not running.
- One place to look when a background process isn't working.
- Faster development of complex, multi-step workflows, since retry/state logic is no longer hand-built each time.
- A system that scales with our workflow complexity, not just job volume.

## Decision Needed

We're asking for approval to run the pilot described above, with a decision checkpoint after 6–8 weeks on whether to proceed with broader migration.

## Open Questions

- Self-hosted Temporal vs. Temporal Cloud — which do we want to commit to operationally?
- Which team and workflow should be the pilot?
- Who owns the on-call/operational responsibility for Temporal infrastructure if self-hosted?

````

### With plain-language skill

````markdown
# RFC: Replace Sidekiq and cron with Temporal for background job orchestration

**Author:** Platform Engineering
**Date:** 2024-06-10
**Version:** 0.1 draft
**Reading time:** 6 minutes
**Written for:** Engineering leadership team
**Status:** Draft for review — decision needed by [date]

---

## Are you the right reader?

Read this document if any of the following is true:

- You approve infrastructure changes that affect multiple engineering teams.
- You own a service that currently uses Sidekiq, cron, or both.
- You are accountable for on-call load or incident response for background jobs.

If none of these are true, you can stop reading.

---

## What we are asking for

We ask engineering leadership to approve a 6-week pilot that runs one existing Sidekiq workflow on Temporal. If the pilot meets the success criteria below, we ask for approval to migrate the remaining Sidekiq jobs and cron schedules to Temporal over two quarters. We do not ask you to approve the full migration today — only the pilot and the migration budget contingent on pilot results.

---

## Why this matters

- **Retries fail silently today.** When a Sidekiq job fails after its retry limit, it moves to a dead-letter queue that only Platform Engineering monitors. Three incidents in the last quarter (INC-4021, INC-4058, INC-4102) were caused by jobs stuck in that queue for over 48 hours before anyone noticed.
- **Cron has no shared visibility.** Cron jobs run on individual hosts. There is no single place to see what ran, what failed, or what is scheduled next. Debugging a missed cron job currently takes an engineer 2–4 hours on average, based on the last 10 incident postmortems.
- **Multi-step workflows are hard to express.** Sidekiq handles single jobs well but not workflows with steps, waits, and compensating actions. Three teams (Billing, Onboarding, Data Platform) have built custom state machines on top of Sidekiq to work around this. Each implementation duplicates the same problem.

---

## The plan in one paragraph

Platform Engineering will run the Billing team's refund-processing workflow on Temporal for 6 weeks, in parallel with the existing Sidekiq implementation, without removing the Sidekiq path. We will measure job visibility, retry behavior, and on-call incident count during the pilot. If Temporal meets the success criteria, we will propose a phased migration: cron jobs first (lowest risk), then Sidekiq workflows team by team, starting with teams that already have custom state-machine workarounds.

## The plan step by step

```
Week 1-2   Platform Engineering sets up Temporal cluster and instrumentation.
Week 3-6   Billing team's refund-processing workflow runs on Temporal in
           parallel with Sidekiq. Both paths execute; only Sidekiq's
           result is used in production.
Week 7     Platform Engineering presents pilot results to engineering
           leadership.
Week 8+    If approved: phased migration begins with cron jobs.
```

---

## Success criteria for the pilot

The pilot succeeds if all of the following hold at the end of week 6:

- Zero jobs land in an unmonitored dead-letter state. Every failure is visible in the Temporal UI with a clear retry history.
- Median time to diagnose a failed job drops from 2–4 hours (current cron/Sidekiq baseline) to under 30 minutes.
- The Temporal path produces results identical to the Sidekiq path for at least 99% of refund-processing runs.
- No new production incidents originate from the Temporal path.

If any criterion is not met, we will report why and recommend whether to extend the pilot, adjust scope, or stop.

---

## What each reader needs to do

### Engineering leadership

1. Approve or reject the 6-week pilot and its budget (see Cost, below).
2. Confirm the Billing team as the pilot team, or name a different team if Billing is not available in this timeframe.

**Estimated time:** 15 minutes to read this document, plus attendance at the week-7 results review.

### Billing team

1. Assign one engineer to implement the refund-processing workflow in Temporal, in parallel with the existing Sidekiq job.
2. Review pilot results at week 7.

**Estimated time:** Roughly 1 engineer-week spread across weeks 3–6.

### Platform Engineering

1. Provision and operate the Temporal cluster for the pilot.
2. Instrument both paths so results are comparable.
3. Report pilot results at week 7.

**Estimated time:** Roughly 2 engineer-weeks.

---

## Alternatives considered

| Alternative | Why we did not choose it |
|---|---|
| Keep Sidekiq and cron as-is | Does not solve the visibility or workflow-expression problems described above. Teams will keep building custom state machines. |
| Apache Airflow | Built for scheduled data pipelines, not for low-latency, event-driven jobs. Would require running a second system alongside Sidekiq, not a replacement. |
| AWS Step Functions | Ties job orchestration to AWS-specific infrastructure. Our jobs run across AWS and GCP; Step Functions would only cover half our workloads. |

---

## Cost

| Item | Rough cost |
|---|---|
| Temporal Cloud (pilot, 6 weeks) | ~$400 |
| Engineering time (pilot) | ~3 engineer-weeks |
| Temporal Cloud (full migration, ongoing) | ~$2,500/month, based on current Sidekiq job volume |

---

## Risks

- **Team unfamiliarity.** No team has run Temporal in production. We mitigate this by running the pilot in parallel with Sidekiq, so a Temporal failure does not affect production traffic.
- **Migration scope creep.** Moving all Sidekiq jobs at once would be risky. The phased plan starts with cron jobs, which have no user-facing consequence if delayed.

---

## Open questions

- Which team should own the Temporal cluster after the pilot: Platform Engineering, or a rotating on-call across teams that use it?
- Does the pilot's 99% result-match threshold need to be higher for financial workflows like refunds?

---

## Glossary

| Term | Meaning |
|---|---|
| Temporal | A system that runs multi-step workflows reliably, tracking each step's progress and retrying failed steps automatically. |
| Sidekiq | Our current system for running background jobs (e.g., sending an email after signup). |
| Cron | A scheduler that runs a script at a fixed time, with no built-in retry or visibility. |
| Dead-letter queue | A holding queue for jobs that failed every retry attempt and need a human to look at them. |
| Durable execution | Temporal's guarantee that a workflow resumes from its last completed step after a crash, instead of restarting from the beginning. |

---

## Related documents

- [`INC-4021-postmortem.md`](./incidents/INC-4021.md) — the dead-letter queue incident referenced above.
- [Temporal documentation](https://docs.temporal.io) — official docs, for background reading.

---

## How to respond

Reply in the RFC comment thread, or at the [decision meeting] on [date], with one of:

- **"Approved"** — the pilot proceeds as scoped.
- **"Approved with comments"** — the pilot proceeds, with the changes you specify.
- **"Not approved — need discussion"** — say what concerns you, so we can address them before the next review.

````

---

## Sample 3

**Prompt:** Write a postmortem for a 45-minute payment outage on 2026-07-30. Cause: a deploy removed a required environment variable. Detection was via customer reports; alerts did not fire.

### Baseline (no skill)

````markdown
# Postmortem: Payment Outage on 2026-07-30

## Summary

On July 30, 2026, our payment system was down for 45 minutes. Customers could not complete purchases during this time. The outage was caused by a deploy that accidentally removed a required environment variable. We did not catch the problem with our monitoring — customers told us about it first.

**Duration:** 45 minutes
**Impact:** Customers could not complete payments
**Detection:** Customer reports (not automated alerts)

## Timeline

| Time | Event |
|---|---|
| 14:02 | Deploy goes out, removing a required environment variable from the payment service config |
| 14:03 | Payment service starts failing on every transaction |
| 14:05–14:40 | Customers begin contacting support about failed payments; no internal alerts fire |
| 14:41 | Support escalates the reports to the on-call engineer |
| 14:45 | On-call engineer confirms the payment service is down and starts investigating |
| 14:47 | Engineer finds the missing environment variable in the deploy diff |
| 14:47 | Environment variable is restored and the service is redeployed |
| 14:47 | Payments start working again |

**Total time down:** 45 minutes (14:02–14:47)
**Time to detect:** ~40 minutes (via customer reports)
**Time to fix once found:** ~2 minutes

## What Went Wrong

1. **A deploy removed a required environment variable.** The payment service depends on this variable to connect to the payment processor. Without it, every payment request failed immediately.

2. **The deploy process didn't catch the missing variable.** There was no check that would have stopped the deploy or flagged the missing config before it went live.

3. **Alerts did not fire.** We have monitoring in place for the payment service, but it did not detect this failure. This means we found out about the outage from customers instead of from our own systems — the slowest possible way to detect a problem.

## Why the Alerts Didn't Fire

This needs further investigation, but the immediate hypothesis is that our alerting checks for service crashes or high latency, not for the specific failure mode here (the service was running but every request failed due to a config error). We need to confirm this and close the gap.

## What Went Right

- Once support escalated the issue, the on-call engineer found and fixed the root cause in about 2 minutes.
- The fix itself was simple: restore the missing variable and redeploy.

## Action Items

| Action | Owner | Priority |
|---|---|---|
| Add a deploy-time check that fails the deploy if required environment variables are missing | TBD | High |
| Investigate why alerts didn't fire for this failure mode; add alerting for payment failure rate (not just crashes/latency) | TBD | High |
| Add a synthetic transaction check that runs every 1–2 minutes and pages on-call if it fails | TBD | High |
| Review the deploy checklist/process to add a config diff review step for production deploys | TBD | Medium |
| Document required environment variables for the payment service in one place, with owners | TBD | Medium |

## Lessons

- **Config changes need the same scrutiny as code changes.** A missing environment variable took down payments just as effectively as a bug would have.
- **We were slower to detect this than to fix it.** The actual fix took 2 minutes; finding out took 40. Improving detection is the highest-leverage fix here.
- **Customers should not be our alerting system.** If they notice before we do, our monitoring has a gap we need to close.

````

### With plain-language skill

````markdown
# Payment outage — 2026-07-30 — 45 minutes of failed payments

**Author:** [your name]
**Date:** 2026-07-30
**Version:** 1.0
**Written for:** Engineering, Support, Leadership
**Status:** Final

*Some details below are placeholders — replace `[bracketed]` items with your actual service names, ticket numbers, and owners before sharing.*

---

## Are you the right reader?

Read this if any of the following is true:

- You need to know why payments failed and for how long.
- You own a follow-up action listed below.
- You handle customer communication about outages.
- You want to prevent this class of failure from happening again.

---

## What happened

On 2026-07-30, payments failed for 45 minutes. A deploy removed a required environment variable from the payment service. The service could not connect to [payment provider], so it rejected all payment attempts. No monitoring alert fired. We found out because customers reported failed payments to support.

---

## Impact

- **Duration:** 45 minutes ([HH:MM]–[HH:MM] UTC).
- **Who was affected:** All customers attempting to pay during the window.
- **What failed:** Every payment request returned an error.
- **How we found out:** Customer reports to support, not automated alerting.
- **Estimated failed transactions:** [number, or "unknown — pull from payment logs"].
- **Revenue impact:** [amount, or "estimate pending"].

---

## Timeline

| Time (UTC) | Event |
|---|---|
| [HH:MM] | Deploy to payment service goes live, removing `[ENV_VAR_NAME]`. |
| [HH:MM] | Payment service starts rejecting all payment requests. |
| [HH:MM] | First customer report reaches support. |
| [HH:MM] | Support escalates to on-call engineering. |
| [HH:MM] | On-call identifies the missing environment variable. |
| [HH:MM] | Fix deployed, restoring the variable. |
| [HH:MM] | Payments confirmed working again. Outage ends. |

Total time from deploy to detection: [X minutes]. Total time from detection to fix: [Y minutes].

---

## Why it happened

The deploy pipeline for the payment service does not carry environment variables forward automatically. The deploy that went live on 2026-07-30 omitted `[ENV_VAR_NAME]`, which the service needs to authenticate with [payment provider]. Without it, every payment request failed at the authentication step.

No alert fired because [state the actual gap, e.g.: "the payment-failure-rate alert only triggers on failure rates measured against total traffic, and this outage failed 100% of a small volume of requests, which did not cross the alert threshold" or "no alert exists for authentication failures with the payment provider"]. Support learned about the outage from customers before engineering did.

---

## What we are asking for

Approve the follow-up actions below, and confirm who owns each one.

---

## Follow-up actions

| Action | Owner | Due date |
|---|---|---|
| Add a deploy-time check that fails the deploy if a required environment variable is missing. | [team] | [date] |
| Add an alert that fires on any payment-provider authentication failure, regardless of overall traffic volume. | [team] | [date] |
| Add a synthetic transaction that runs every [N minutes] and pages on-call if it fails. | [team] | [date] |
| Document the required environment variables for the payment service in one place, and check that list in code review for deploy config changes. | [team] | [date] |

**Success criteria:** A future deploy that omits a required environment variable must fail before reaching production, and any payment-provider authentication failure must page on-call within 2 minutes — before a customer reports it.

---

## What we are not doing

- We are not adding a manual pre-deploy checklist. Checklists get skipped under time pressure; the deploy-time check above enforces this automatically.
- We are not changing the deploy pipeline provider. The gap was a missing check, not a tooling failure.

---

## Glossary

| Term | Meaning |
|---|---|
| Environment variable | A configuration value read by the service at startup, kept outside the code (for example, an API key). |
| Payment provider | The external service that processes card payments on our behalf. |
| Synthetic transaction | A test payment run automatically on a schedule to check the payment path works, without a real customer involved. |
| On-call | The engineer currently responsible for responding to production alerts. |

---

## Related documents

- [`deploy-pipeline.md`](./deploy-pipeline.md) — how deploys reach production.
- [`alerting-runbook.md`](./alerting-runbook.md) — current alert thresholds and escalation paths.
- [Support ticket log for this incident] — original customer reports.

---

## How to respond

Reply with one of:

- **"Approved"** — the follow-up actions and owners are correct; work can start.
- **"Approved with comments"** — you agree, with changes to owners or dates.
- **"Not approved — need discussion"** — say what needs to change before this can close.

````

---
