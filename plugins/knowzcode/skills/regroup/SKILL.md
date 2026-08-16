---
name: regroup
description: "Create a local KnowzCode handoff before clearing context. Use when the user wants to pause, wrap up, step away, clear context, or resume an active WorkGroup later without losing workflow state."
---

# /knowzcode:regroup — Local workflow handoff

**Purpose**: Preserve local workflow continuity before the user clears context. Regroup writes operational state to KnowzCode local files. It does not store session handoffs in Knowz vaults.

Knowz MCP is optional and never blocks regroup.

## Ownership boundary

- KnowzCode owns workflow state: active WorkGroup, phase, branch, dirty files, blockers, next steps, autonomy mode, and resume instructions.
- Knowz owns durable knowledge: decisions, patterns, workarounds, conventions, architecture findings, audit findings, and completion records.
- Do not write the handoff itself to Knowz. If durable learnings are discovered, list them as extraction candidates or route them through `/knowz-save`.

## Instructions

### Step 1: Prerequisite check

1. Check that `knowzcode/` exists.
2. Check for `knowzcode/knowzcode_tracker.md`.
3. If missing, stop and suggest `/knowzcode:setup`.

### Step 2: Resolve WorkGroup

1. If the user supplied a WorkGroup ID or path, use it.
2. Else read `knowzcode/knowzcode_tracker.md` for active `[WIP]` entries.
3. If one active WorkGroup exists, use it.
4. If multiple active WorkGroups exist, choose the one clearly referenced by the current session; otherwise ask the user to choose.
5. If none exist, create a standalone handoff with `WorkGroupID: none` and point the user toward `/knowzcode:work` after resume.

Read the selected WorkGroup file when available: `knowzcode/workgroups/{WorkGroupID}.md`.

### Step 3: Collect local resume state

Keep it dense and actionable:

- Goal and current phase
- Completed work or findings
- Current blockers and unresolved questions
- Next step from the user's argument, if supplied
- Active autonomy mode: `Active` | `Inactive` | `Unspecified`
- Important files, commands, and references
- Current branch, commit, and dirty-file summary from `git branch --show-current`, `git rev-parse --short HEAD`, and `git status --short`

Do not paste raw transcript text.

### Step 4: Write handoff file

Create `knowzcode/handoffs/` if it does not exist. Write:

```text
knowzcode/handoffs/{YYYYMMDD-HHMM}-{slug}.md
```

Use a 2-5 word kebab-case slug from the goal or WorkGroup. If a file already exists, append `-2`, `-3`, etc.

```markdown
# KnowzCode Handoff: {short goal}

**Created:** {ISO timestamp}
**WorkGroupID:** {id or none}
**WorkGroup File:** {path or none}
**Current Phase:** {phase or unknown}
**Autonomous Mode:** {Active|Inactive|Unspecified}
**Branch:** {branch}
**Commit:** {short sha}
**Status:** Active

## Goal
{exact goal to resume}

## Session Summary
{<=100 words}

## Current State
{completed work, current status, blockers; <=180 words}

## Next Step
{immediate next actions; <=80 words}

## Dirty Files
{git status --short summary; omit generated noise unless relevant}

## References
- file:{path} | {why useful}
- cmd:{command} | {why useful}
- kz:{knowledge-id} | {title} | {why useful}
- url:{href} | {why useful}

## Durable Learning Candidates
{Only decisions, patterns, workarounds, conventions, architecture findings, audit findings, or completion records that may belong in Knowz. Use "None" if there are no durable learnings.}

## Fresh Context Prompt
Resume this KnowzCode work.

Read:
- {handoff path}
- {WorkGroup file or "no active WorkGroup"}
- knowzcode/knowzcode_loop.md

Goal: {goal}
Continue from the saved state. Preserve Autonomous Mode only if the user confirms it in the new session.
```

### Step 5: Link from WorkGroup

If an active WorkGroup file exists, append or update a `## Handoffs` section with:

```markdown
- {timestamp}: `knowzcode/handoffs/{file}.md` - {next step summary}
```

### Step 6: Durable knowledge extraction

Do not save the whole handoff to Knowz.

For `## Durable Learning Candidates`:

- Include only durable learnings that should survive outside this local workflow.
- If no capture path is active, leave candidates in the handoff for Phase 3 capture or explicit `/knowz-save`.
- If MCP is unavailable, do not block regroup. The local handoff is the primary artifact.

### Step 7: Report

```markdown
KnowzCode handoff saved.

Path: {handoff path}
WorkGroup: {id or none}
Next: {next step}
Autonomous Mode: {Active|Inactive|Unspecified}
```

Then provide the `Fresh Context Prompt` from the file for copy/paste.

## Related skills

- `/knowzcode:continue` — Load the latest handoff or active WorkGroup and resume
- `/knowzcode:work` — Start a WorkGroup if there is no active workflow
- `/knowz-save` — Capture durable learnings, not workflow handoffs (requires the Knowz plugin)
