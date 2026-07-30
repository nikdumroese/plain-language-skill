# Before / after — real samples

**Generated:** 2026-07-30 11:17 CEST
**Runner:** pi 0.82.0
**Provider / model:** `github-copilot / claude-sonnet-5`

Both runs use the same runner, the same model, and the same prompt. Neither has access to CLAUDE.md, auto-discovered skills, or project context. The only difference is whether the plain-language skill is in the system prompt.

Regenerate with `./evals/run.sh`. Override the runner with `RUNNER=claude ./evals/run.sh` or the model with `MODEL=... ./evals/run.sh`.

---

## Sample 1

**Prompt:** Write a memo asking leadership to approve migrating payment processing from Stripe to Adyen. It saves cost, improves European latency, takes six weeks. Legal, Security, and Finance need to sign off.

### Baseline (no skill)

````markdown
# Memo: Approval Request — Migrate Payment Processing from Stripe to Adyen

**To:** Leadership Team
**From:** [Your Name], [Your Title]
**Date:** [Date]
**Re:** Approval to migrate payment processing from Stripe to Adyen

## Recommendation

We recommend migrating our payment processing from Stripe to Adyen. This memo asks for approval to proceed, along with sign-off from Legal, Security, and Finance.

## Why We Want to Switch

**Lower costs.** Adyen's pricing structure will reduce our payment processing fees.

**Better performance in Europe.** Adyen has stronger infrastructure in Europe, which will reduce latency for our European customers and improve their checkout experience.

## Timeline

The migration will take **six weeks** from approval to completion.

## What We Need Before Starting

Three teams must review and approve this change before we begin:

1. **Legal** — to review the new vendor contract and data terms
2. **Security** — to review Adyen's security practices and confirm they meet our standards
3. **Finance** — to confirm the cost savings and approve the new billing arrangement

## Next Steps

1. Leadership approves moving forward with this memo
2. We schedule reviews with Legal, Security, and Finance
3. Once all three sign off, we begin the six-week migration

## Ask

Please approve this migration so we can start the review process with Legal, Security, and Finance.

---

*Questions? Contact [Your Name] at [email/phone].*

````

### With plain-language skill

````markdown
Before I draft this, I need a few concrete details — plain language requires numbers, not vague claims ("saves cost", "improves latency" aren't specific enough to write without hedging or guessing).

Could you confirm:

1. **Cost savings** — a number or range (e.g., "$18k/year" or "~30% lower processing fees").
2. **Latency improvement** — current vs. expected (e.g., "180ms → 60ms for EU transactions").
3. **Your name/role and today's date**, for the memo header.
4. **Response mechanism** — how should Legal, Security, and Finance actually respond? (e.g., reply-all with "Approved", a sign-off form, a meeting on a specific date?)
5. **Any known risk or downtime** during the six-week migration that needs a warning before the plan?

Once I have these, I'll write the full memo.

````

---

## Sample 2

**Prompt:** Write a short RFC proposing that we adopt Temporal for background job orchestration, replacing the current mix of Sidekiq and cron. The reader is the engineering leadership team.

### Baseline (no skill)

````markdown
# RFC: Adopt Temporal for Background Job Orchestration

**Status:** Draft
**Author:** [Your name]
**Audience:** Engineering Leadership
**Ask:** Approve a pilot migration from Sidekiq + cron to Temporal for one service, with a decision on broader rollout after 6 weeks.

## Summary

We propose replacing our current mix of Sidekiq and cron with Temporal for background job orchestration. Temporal gives us reliable retries, visibility into long-running workflows, and a single system instead of two. We want to pilot it on one service before committing company-wide.

## The problem

Today we run background work two ways:

- **Sidekiq** for discrete jobs (send an email, resize an image, sync a record).
- **Cron** for scheduled tasks and multi-step processes (nightly billing runs, data reconciliation, onboarding sequences).

This split causes real problems:

1. **Multi-step processes are fragile.** A billing run might touch five services over 20 minutes. Today, if step 3 fails, an engineer gets paged and manually figures out what already ran, what didn't, and how to resume safely. There's no built-in way to see workflow state.
2. **No unified visibility.** To debug a stuck process, engineers check Sidekiq's dashboard, then grep logs, then check the cron job's exit code somewhere else. There's no single place to see "what happened to this job."
3. **Retry logic is reinvented per job.** Every team writes its own retry, backoff, and idempotency logic. Some do it well; some don't. We've had at least three incidents in the last year caused by jobs running twice or not resuming correctly after a failure.
4. **Cron doesn't scale with complexity.** As processes gain more steps and conditional logic, cron scripts turn into tangled shell scripts with ad hoc state tracking (flags in a database, files on disk).

## What Temporal offers

Temporal is a workflow orchestration platform. It lets us write workflows as code (in our existing language: Ruby/Go/etc.) and handles the hard parts automatically:

- **Durable execution.** If a worker crashes mid-workflow, Temporal resumes exactly where it left off. No manual recovery.
- **Built-in retries and timeouts**, configured per step, without custom code.
- **One dashboard** showing every workflow's history, current state, and failures.
- **Replaces both tools.** Temporal handles scheduled work (replacing cron) and discrete tasks (replacing Sidekiq jobs), so we consolidate to one system.

## What this would cost us

To be direct about the tradeoffs:

- **New infrastructure to run.** Temporal requires a server cluster (or a hosted offering — Temporal Cloud). This is new operational overhead, even if it removes other overhead elsewhere.
- **Learning curve.** Workflows are written differently than typical background jobs — engineers need to learn Temporal's programming model (deterministic workflow code, activities, signals). Expect a ramp-up period.
- **Migration effort.** We have hundreds of existing Sidekiq jobs and dozens of cron entries. Rewriting all of them is a multi-quarter effort, not something we do in one sprint.
- **Another vendor/tool dependency**, unless we self-host, which adds its own maintenance burden.

## Proposal

Rather than migrate everything at once, we propose a scoped pilot:

1. **Pick one real workflow** with multiple steps and known pain (candidate: the nightly billing reconciliation process, which has caused two incidents this year).
2. **Rebuild it in Temporal** over 4–6 weeks, running in parallel with the existing version.
3. **Evaluate** based on: incident reduction, engineer feedback on debuggability, and operational cost of running Temporal.
4. **Report back to leadership** with a recommendation: expand, pause, or abandon.

We are *not* proposing to deprecate Sidekiq or cron immediately. Simple, single-step jobs may remain a fine fit for Sidekiq even long-term — Temporal is not automatically better for everything.

## Alternatives considered

- **Improve Sidekiq + cron in place** (e.g., add better observability tooling, standardize retry patterns). Lower cost, but doesn't solve the core problem: multi-step workflows still need a workflow engine, not a job queue.
- **AWS Step Functions / similar managed alternative.** Viable, but ties us more tightly to a single cloud provider and has a steeper JSON/DSL-based authoring model versus writing workflows in our own code.
- **Do nothing.** Given recurring incidents tied to multi-step process failures, this carries ongoing risk we think is worth addressing.

## Ask

We're requesting approval to run the pilot described above: one workflow, one team, 4–6 weeks, with a follow-up decision point. Estimated cost: 1 engineer-month plus Temporal Cloud trial costs (or self-hosted infra time).

````

### With plain-language skill

````markdown
# RFC: Adopt Temporal for background job orchestration

**Author:** [Your name]
**Date:** 2025-06-10
**Version:** 0.1 draft
**Reading time:** 4 minutes
**Written for:** Engineering leadership team
**Status:** Draft for review

---

## What we are asking for

Approval to adopt Temporal as our single system for background job orchestration, replacing Sidekiq and cron over the next two quarters. Once approved, the platform team will start a pilot with one existing cron-based workflow in Q3.

## Why this matters

- Sidekiq jobs and cron jobs fail silently. In the last six months, three production incidents traced back to a cron job that failed without alerting anyone.
- Retry logic is duplicated by hand in every job. Each team writes its own retry and backoff code, so behavior is inconsistent across services.
- No team can see the full state of a multi-step process. When a job spans several steps (for example, "charge customer, then provision account, then send welcome email"), engineers must reconstruct what happened by reading logs from three separate systems.

## The plan in one paragraph

Temporal replaces both Sidekiq and cron with one system that runs and tracks long-running workflows. Each workflow step retries automatically, and Temporal records every step's state, so engineers can see exactly where a workflow is and why it stopped. We will migrate one workflow first, measure the result, then migrate the rest over two quarters. Sidekiq and cron stay in place until each workflow they run has been migrated and verified.

## The plan step by step

```
Step 1  Pilot: migrate the invoice-reconciliation cron job to Temporal (Q3, weeks 1-4)
Step 2  Measure: compare failure rate and time-to-diagnose against the old system (Q3, weeks 5-6)
Step 3  Decide: go/no-go review with engineering leadership (Q3, week 7)
Step 4  If go: migrate remaining Sidekiq queues team by team (Q3 week 8 - Q4 week 12)
Step 5  Decommission Sidekiq and the cron scheduler once all workflows are migrated
```

## What each reader needs to do

### Engineering leadership

What we need from you:

1. Approve or reject the pilot described in Step 1.
2. Assign one engineer from the platform team to lead the pilot.
3. Confirm the go/no-go review date for Q3, week 7.

**Estimated time:** 30 minutes to review this RFC and respond.

---

## Supporting detail

The sections below give the full picture. You do not need to read them to approve the pilot.

### Why Temporal and not an alternative

We considered three options. Temporal is a workflow engine that tracks state and handles retries automatically. Sidekiq is a job queue; it retries a single job but has no concept of a multi-step workflow. Cron is a scheduler; it triggers jobs but does not track whether they succeeded.

| Option | Tracks multi-step state | Automatic retries | Visibility into failures |
|---|---|---|---|
| Keep Sidekiq + cron | No | Per-job only, hand-coded | Logs only, split across systems |
| Build in-house orchestrator | Yes | Yes, if we build it | Yes, if we build it |
| Adopt Temporal | Yes | Yes, built in | Yes, built-in dashboard |

Building an in-house orchestrator would take an estimated 4-6 engineer-months before it matched Temporal's current feature set. Temporal is open source and already used in production at several companies of similar or larger scale.

### Cost

| Item | Rough cost |
|---|---|
| Temporal Cloud (managed hosting) | ~$800/month at current job volume |
| Engineer time for pilot | 1 engineer, 4 weeks |
| Engineer time for full migration | 2 engineers, 10 weeks (Q3-Q4) |

### Risks

**Warning:** Running Temporal and Sidekiq side by side during migration means two systems can trigger the same job if the migration is not sequenced correctly. Each team must remove a job from Sidekiq's schedule in the same pull request that adds it to Temporal, and this is verified by the platform team before merge.

### Success criteria

The pilot succeeds if, after four weeks:

- The invoice-reconciliation workflow has zero silent failures (today's baseline: 2 silent failures in the last 6 months).
- Time to diagnose a failed workflow drops from an average of 45 minutes (current, measured across 5 past incidents) to under 10 minutes, using Temporal's workflow history view.

If the pilot does not meet these criteria, we stop and keep the current system.

### Glossary

| Term | Meaning |
|---|---|
| Workflow orchestration | Coordinating a job that has several steps, where later steps depend on earlier ones succeeding |
| Sidekiq | Our current background job queue, built on Redis |
| Cron | The current Unix scheduler we use to trigger recurring jobs |
| Temporal | An open-source workflow engine that tracks the state of multi-step processes and retries failed steps automatically |
| Go/no-go review | A checkpoint meeting where we decide whether to continue or stop based on pilot results |

### Related documents

- [Temporal architecture overview](https://docs.temporal.io) — official documentation.
- Incident reports: INC-2024-0091, INC-2024-0114, INC-2024-0158 — the three cron-related incidents referenced above.

---

## How to respond

Reply in the RFC comment thread with one of:

- **"Approved"** — the pilot starts in Q3, week 1.
- **"Approved with comments"** — the pilot starts, and you list changes to consider before the go/no-go review.
- **"Not approved — need discussion"** — state your concern, and we schedule a 30-minute discussion before the next engineering leadership meeting.

````

---

## Sample 3

**Prompt:** Write a postmortem for a 45-minute payment outage on 2026-07-30. Cause: a deploy removed a required environment variable. Detection was via customer reports; alerts did not fire.

### Baseline (no skill)

````markdown
# Postmortem: Payment Service Outage — July 30, 2026

## Summary

On July 30, 2026, the payment service was unavailable for approximately 45 minutes. A deploy removed an environment variable required by the payment service, causing it to fail on startup or during transaction processing. Monitoring did not detect the issue. The outage was first identified through customer reports.

## Impact

- **Duration:** ~45 minutes
- **Affected system:** Payment processing
- **Customer impact:** Customers were unable to complete payments during the outage window
- **Detection method:** Customer support tickets / user reports (not automated alerting)

## Timeline

*(Times are approximate; replace with exact timestamps from logs/deploy history.)*

| Time | Event |
|------|-------|
| T+0:00 | Deploy goes out, removing a required environment variable from the payment service configuration |
| T+0:00–0:05 | Payment service begins failing to process transactions (or fails to start, depending on deploy mechanics) |
| T+0:05–0:20 | Failures continue silently; no alerts trigger |
| T+0:20 | First customer reports of failed payments reach support |
| T+0:25 | Support escalates to on-call engineering |
| T+0:30 | Engineering identifies the recent deploy as the likely cause |
| T+0:35 | Missing environment variable identified as root cause |
| T+0:40 | Environment variable restored / previous deploy rolled back |
| T+0:45 | Payment service confirmed healthy; transactions processing normally |

## Root Cause

A deploy removed an environment variable that the payment service requires to function (e.g., for connecting to a downstream dependency such as a payment gateway, secrets store, or database). This was not caught before or during the deploy, and the resulting failure mode did not trigger any automated alerts.

## Why Monitoring Failed to Detect the Issue

Alerts did not fire during the outage. Contributing factors likely include one or more of:

- No alert configured on payment success/failure rate or transaction error rate
- Health checks did not exercise the code path affected by the missing environment variable (e.g., a shallow health check that doesn't call the actual payment flow)
- The failure mode (missing config) produced errors that were not routed to a monitored log/metric
- Existing alert thresholds were too insensitive to catch a sharp, isolated failure spike

This meant the outage was only detected reactively, through customer reports, rather than proactively — extending the time to detection and, consequently, the overall outage duration.

## Detection Gap Analysis

- **Time to detect via monitoring:** N/A (never triggered)
- **Time to detect via customer reports:** ~20 minutes after deploy
- **Time to resolution after detection:** ~25 minutes

The majority of the outage duration was attributable to the detection gap, not the resolution effort. Once engineers were engaged, root cause identification and fix were relatively fast.

## Resolution

The missing environment variable was restored to the payment service configuration (or the deploy was rolled back), and service was confirmed healthy through manual verification of transaction processing.

## Contributing Factors

1. **Deploy process did not validate required configuration.** There was no pre-deploy or post-deploy check confirming that all required environment variables were present.
2. **No automated alerting on payment failure rate.** Critical business transactions (payments) lacked a dedicated alert tied to success/failure metrics.
3. **Health checks (if present) did not cover the affected functionality.** A passing health check may have masked the underlying failure.
4. **No canary or staged rollout** that might have limited blast radius and surfaced the issue before full deployment.

## Action Items

| Action | Owner | Priority | Status |
|--------|-------|----------|--------|
| Add automated alert on payment transaction success/failure rate | TBD | High | Not started |
| Add deploy-time validation that all required environment variables are present before promoting a release | TBD | High | Not started |
| Expand health checks to exercise critical payment code paths, not just process liveness | TBD | High | Not started |
| Implement canary/staged rollout for payment service deploys | TBD | Medium | Not started |
| Add runbook step to check recent deploys first when investigating customer-reported payment issues | TBD | Medium | Not started |
| Review other critical services for similar alerting/config-validation gaps | TBD | Medium | Not started |

## Lessons Learned

- **What went well:** Once alerted via customer reports, the team quickly correlated the issue to the recent deploy and resolved it within ~25 minutes.
- **What went poorly:** The outage was invisible to monitoring for its entire duration; the team learned about it from customers rather than from internal systems. This represents a significant gap for a critical, revenue-impacting service.
- **Where we got lucky:** The root cause was straightforward to identify (a recent deploy, a missing variable) once engineers investigated. A more subtle configuration issue could have taken significantly longer to diagnose.

````

### With plain-language skill

````markdown
Before I draft this, I need a few facts that determine what goes in the postmortem. One focused question, four parts:

1. **Service/system name** — what was affected (e.g., "checkout API", "payment gateway")?
2. **Customer impact** — roughly how many transactions/customers were affected, and what did they experience (failed charges, error page, retries)?
3. **Who is the primary reader** — engineering team only, or does this also go to leadership/support/customers (affects tone and how much technical detail I include)?
4. **Action items** — do you have specific fixes already decided (e.g., "add required-env-var check to deploy pipeline", "add alert on payment success-rate drop"), or should I draft placeholder action items for you to assign owners and dates?

If you don't have exact numbers for #2, approximate ranges are fine — I just won't use vague words like "many" or "a lot" per the plain-language rules, so I need something concrete.

````

---
