---
name: start-work
description: "Route implementation intent into KnowzCode workflow mode. Use for 'start building', 'go ahead', 'implement this plan', or 'build this now' requests."
---

# KnowzCode Start Work — Intent router

Use this as a lightweight router into `/knowzcode:work`.

## Instructions

1. Trigger only when the user's message clearly expresses implementation intent such as "implement this plan", "go ahead", "start work", "build this now".
2. Do not trigger for questions, hypotheticals, or pure discussion.
3. Recover the best available goal from:
   - the user's current message
   - a recently discussed plan or investigation in the thread
   - an active WorkGroup in `knowzcode/workgroups/`
4. Summarize the goal in one sentence and hand off to `/knowzcode:work` using the contract below.
5. If there is not enough context to identify the goal safely, ask the user what should be implemented.

## Handoff payload

When invoking `/knowzcode:work`, pass a structured payload so the workflow can skip re-discovery:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `goal` | string | yes | One-sentence imperative summary of what to build |
| `source_path` | string | no | Path to the plan or investigation file the goal came from |
| `tier` | `"micro" \| "light" \| "full"` | no | Pre-classified scope hint; `/knowzcode:work` may override |
| `flags` | string | no | Pass-through flags such as `--autonomous` or `--tier full` |
| `prior_findings_summary` | string | no | 2-3 sentences summarizing key constraints/decisions from the source |

Always include `goal`. Include `source_path` whenever a plan/investigation was the trigger.
