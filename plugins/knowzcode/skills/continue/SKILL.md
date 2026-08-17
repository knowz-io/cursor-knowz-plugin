---
name: continue
description: "Resume an interrupted KnowzCode workflow, including Grok-host process relay. Use when the user wants to continue an active WorkGroup, load the latest local handoff, resume schema-2 or legacy schema-1 relay state, or advance the next pending phase."
---

# continue — Resume workflow

Resume the most relevant active KnowzCode WorkGroup from local files. Knowz MCP is optional and never blocks resume. Relay state on disk takes precedence over generic phase inference.

## Instructions

1. Check `knowzcode/handoffs/*.md`.
   - If the user supplied a handoff path or slug, load that handoff.
   - If no explicit path was supplied, find the newest handoff by filename timestamp.
   - Handoffs are local operational state. Do not search Knowz vaults for workflow handoffs.
2. Read `knowzcode/knowzcode_tracker.md` and locate active `[WIP]` work.
3. If multiple active WorkGroups exist, ask the user which one to resume unless the selected handoff clearly names a WorkGroup.
4. Read the selected WorkGroup file and check for `knowzcode/workgroups/{wgid}-relay/state.md` before choosing a generic phase action.
5. If a handoff was loaded, parse `## Goal`, `## Current State`, `## Next Step`, `## References`, and `## Durable Learning Candidates`. Use the handoff as the freshest local state. Do not run `cmd:` references automatically.
6. If the WorkGroup file contains `**Autonomous Mode**: Active`, restore `AUTONOMOUS_MODE = true` and announce it. Read `relay*` config keys only when a `## Relay` section exists; configuration must not re-resolve or change the recorded host/target.
7. If no relay state exists, resume at the next ordinary step:
   - unfinished Change Set
   - spec drafting or approval
   - implementation
   - read-only audit
   - finalization
8. Keep the workflow aligned with `knowzcode/knowzcode_loop.md` and do not skip quality gates unless the user explicitly asked for autonomous execution.
9. Hand off execution to the same contract as `work` for the current phase.

## Relay State Loading

If the WorkGroup file contains a `## Relay` section, or `{wgid}-relay/state.md` exists, read both:

- `knowzcode/workgroups/{wgid}-relay/state.md` — authoritative state
- `../work/references/relay-execution.md` — provider-neutral state machine and target adapters

Resume the recorded relay instead of entering native Phase 2A. Do not infer a new target from the current prompt or current project configuration: the state file's host/target pair is fixed for the WorkGroup. Do not treat a Grok-host WorkGroup as `RELAY_HOST=claude`. When relaunching a detect/resume, prepend `$HOME/.local/bin` and `/home/box/.local/bin` to `PATH`.

### Schema 2

Parse and validate these fields:

```text
Schema: 2
Host: grok
Target: claude|codex
State: INIT|PLANNED|TARGET_IMPLEMENTING|TARGET_FAILED|TARGET_DONE|
       REVIEWING|FIX_ROUND|HOST_TAKEOVER|FINALIZING|DONE|ABORTED
Session ID: provider thread/session identifier
```

Also restore Round, Max Fix Rounds, target-specific model/effort/permission or sandbox settings, Branch, checkpoints, and artifact paths.

This package creates `Host: grok` with `Target: claude` or `Target: codex`. Reject malformed schema-2 state or a same-host pair (`Host` equals `Target`, or `Target: grok`). If schema-2 names `Host: claude` or `Host: codex`, do not reinterpret it as a Grok relay; report that it belongs to a different host package and stop rather than silently reversing it, unless the user explicitly requests Grok `HOST_TAKEOVER`.

### Legacy schema-1 compatibility

When `Schema` is absent and `Mode: codex` is present, interpret the state in memory as `Host: claude`, `Target: codex`, map `Thread ID` (also tolerate `Codex Thread ID`) to `Session ID`, and map states as follows:

| Legacy state | Schema-2 meaning |
|--------------|------------------|
| `INIT` | `INIT` |
| `PLANNED` | `PLANNED` |
| `CODEX_IMPLEMENTING` | `TARGET_IMPLEMENTING` |
| `CODEX_FAILED` | `TARGET_FAILED` |
| `CODEX_DONE` | `TARGET_DONE` |
| `REVIEWING` / `CLAUDE_REVIEWING` | `REVIEWING` |
| `FIX_ROUND` | `FIX_ROUND` |
| `CLAUDE_TAKEOVER` | `HOST_TAKEOVER` |
| `FINALIZING` | `FINALIZING` |
| `DONE` | `DONE` |
| `ABORTED` | `ABORTED` |

Continue recognizing legacy `codex-log-r{N}.jsonl`, `codex-last-r{N}.md`, and `codex-err-r{N}.log` artifacts. Do not rewrite a legacy state file merely because it was read. Legacy Claude-host state is not a Grok-host relay; preserve it and explain that it must be resumed from Claude Code unless the user explicitly requests a Grok takeover. After the next successful transition on a Grok-owned relay, persist schema 2 with `Host: grok`, role-based state, `Session ID`, and target-qualified artifact names; update the WorkGroup snapshot at the same time.

### Dead-process reconciliation

After a context clear, a recorded `TARGET_IMPLEMENTING` subprocess is no longer assumed live. Dispatch evidence checks through the recorded target adapter:

- Codex target: require the round JSONL completion event and target final-message artifact described by the Codex adapter.
- Claude target: require a final stream-JSON `result` with `subtype: success` and the target final-message artifact described by the Claude adapter.

Complete evidence maps to `TARGET_DONE` and the host commits the missing checkpoint if necessary. Incomplete or unsuccessful evidence maps to `TARGET_FAILED`: attempt the one provider-specific resume allowed by the relay protocol using the persisted Session ID, then enter `HOST_TAKEOVER` if resume fails or the retry is exhausted. Never apply Codex JSONL selectors, `$CODEX_HOME` recovery, or `codex exec resume` to a Claude target. All non-running states resume exactly where schema 2 says.

If the process is still alive, resume bounded in-turn `Shell` polls. Do not launch a duplicate process. Never end the turn to wait for a background-process completion notification.

Include a relay line in the status block:

`**Relay**: {host} → {target} — {state}, round {n}, session {session_id|pending}{legacy marker}`

Use ` (legacy schema 1)` as the marker when the compatibility mapping is active. Do not print the full session identifier in user-facing status when a presence flag is enough; keep it in state.md.

## Related Skills

- `work` — start a new WorkGroup (if nothing to continue)
- `relay` — setup-aware resolver for a new relay
- `status` — check current project and relay health
