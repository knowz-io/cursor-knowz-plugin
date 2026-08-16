---
name: status
description: "Check KnowzCode project health, active work, and pending captures. Use for status, setup verification, or troubleshooting. Knowz MCP is optional."
---

# /knowzcode:status — Project status

Report local KnowzCode health without starting or resuming work. Knowz MCP is optional and never blocks this report.

## Instructions

1. Check whether `knowzcode/` exists and whether the core files are present.
2. Inspect `knowzcode/knowzcode_tracker.md` for `[WIP]`, `[VERIFIED]`, and planned work.
3. Count active and completed WorkGroups in `knowzcode/workgroups/` if that directory exists.
4. Count queued items in the project-root `knowz-pending.md` when present. If legacy `knowzcode/pending_captures.md` exists, report it separately as migration input; do not count it as a second active queue.
5. If Knowz MCP is available, call `mcp__knowz__list_vaults` with `includeStats: true` and report vault availability. If not, report that Knowz enhancement is unavailable and the local workflow still works. Do not tell the user to paste an API key or run `/knowz setup <api-key>`.
6. End with one practical action: initialize, continue work, flush captures, or (only if they want vaults) open Grok Bot Plugins / Cursor Marketplace → search **Knowz** → **Add** → **Authorize**.

## Output format

```text
## KnowzCode Status

Framework: {Initialized | Not initialized}
  Core files: {N}/4 present (loop, tracker, project, architecture)
Tracker: {W} WIP, {V} verified, {P} planned
WorkGroups: {A} active, {C} completed
Pending captures: {Q} queued
MCP & vaults: {Connected — N vault(s) | Not connected (optional — workflow still works)}

Next: {one concrete suggested action}
```

Omit non-applicable lines. Keep secrets out of the report.
