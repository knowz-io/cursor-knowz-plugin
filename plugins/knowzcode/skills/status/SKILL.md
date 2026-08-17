---
name: status
description: "Check KnowzCode project health, active work, pending captures, and Grok-host process relay configuration, readiness, and in-flight state. Use for status, setup verification, or troubleshooting. Knowz MCP is optional."
---

# status — Project status

Report local KnowzCode health without starting or resuming work. Knowz MCP is optional and never blocks this report.

## Instructions

1. Check whether `knowzcode/` exists and whether the core files are present.
2. Inspect `knowzcode/knowzcode_tracker.md` for `[WIP]`, `[VERIFIED]`, and planned work.
3. Count active and completed WorkGroups in `knowzcode/workgroups/` if that directory exists.
4. Count queued items in the project-root `knowz-pending.md` when present. If legacy `knowzcode/pending_captures.md` exists, report it separately as migration input; do not count it as a second active queue.
5. If Knowz MCP is available, call `mcp__knowz__list_vaults` with `includeStats: true` and report vault availability. If not, report that Knowz enhancement is unavailable and the local workflow still works. Do not tell the user to paste an API key or run `/knowz setup <api-key>`.
6. Evaluate relay status using the fixed `RELAY_HOST=grok` rules below.
7. End with one practical action: initialize, continue work, authenticate/install a target CLI, flush captures, or (only if they want vaults) open Grok Bot Plugins / Cursor Marketplace → search **Knowz** → **Add** → **Authorize**.

## Cross-Agent Relay

Read the provider-neutral procedures in `../work/references/relay-execution.md` and the `relay*` keys in `knowzcode/knowzcode_orchestration.md` if present.

**Host is fixed by this package:** `RELAY_HOST=grok`. Prompt text cannot change it.

Parse `relay:` as `none|auto|other|claude|codex` (default `none`) and resolve its configuration-only meaning:

- `none` → native Phase 2A; still probe both candidate CLIs as disabled health
- `auto` or `other` → complementary coding agent (not a favorite): the one ready CLI; both ready → unresolved until the user picks; neither ready → automatic fallback matrix
- `claude` or `codex` → literal target
- `grok` or invalid value → Warning and native Phase 2A (same-host / unsupported)

A concrete target equal to `RELAY_HOST` is a stale same-host configuration. Report a Warning: ordinary `work` will visibly fall back to native Phase 2A, while an explicit same-host flag or natural-language delegation would halt. Never reverse it silently; suggest `relay: other` or a literal `claude` / `codex` target.

**Live `RELAY_DETECT`:** prepend `$HOME/.local/bin` and `/home/box/.local/bin` to `PATH` first (`command -v claude|codex` fails on the Grok VM otherwise). Then probe both:

- Codex: `{codex_bin} --version` → `{codex_bin} login status`
- Claude: `{claude_bin} --version` → `{claude_bin} auth status --json`

For Claude auth, use the command's exit code and parse only `.loggedIn` plus non-identifying method/provider fields. Never display or persist raw auth JSON, email, organization name/ID, tokens, or keys. Normalize both providers to `ready`, `installed-unauthed`, `not-installed`, or `broken-install`. Authentication problems are warnings that will pause a relay even in autonomous mode.

If neither CLI exists, say so plainly: Cursor cloud-agent VMs do not have those CLIs and cannot run relay; hosted Grok Bot sessions share the Grok VM and may. Never claim a cloud agent can run relay.

**Resolve target configuration:**

- Shared: `relay_transport` (default `auto` → exec for both targets on Grok), `relay_max_fix_rounds` (default `2`), `relay_timeout_minutes` (default `90`; interactive time-budget checkpoint, not an unconditional kill)
- Codex target: `relay_codex_model`, `relay_codex_effort`, `relay_codex_fix_effort`, `relay_codex_sandbox`. For v0.20 compatibility only, fall back respectively to `relay_model`, `relay_effort`, `relay_fix_effort`, and `relay_sandbox` when a provider-qualified key is absent.
- Claude target: `relay_claude_model`, `relay_claude_effort`, `relay_claude_fix_effort`, `relay_claude_permission_mode`. Never use Codex legacy values as Claude defaults. Flag `bypassPermissions` as unsafe configuration and report that `dontAsk` is the safe default.
- If target is Claude and transport is `mcp`, warn that Claude MCP is not an agent relay and `auto` or `exec` is required.
- Codex MCP is optional only if a callable `codex` MCP server with thread-ID support is actually registered; otherwise exec.

**Check active relay state:** for active WorkGroups with a `## Relay` section, read `{wgid}-relay/state.md`. Report schema-2 Host, Target, State, Round, and whether a Session ID is present (do not print the identifier). For legacy state with `Mode: codex` and no Schema, report `claude → codex`, append `legacy schema 1`, and map `CODEX_*` / `CLAUDE_TAKEOVER` to their role-based meaning per `continue`. State host/target remains authoritative for continuation even if project config has since changed.

## Output format

```text
## KnowzCode Status

Framework: {Initialized | Not initialized}
  Core files: {N}/4 present (loop, tracker, project, architecture)
Tracker: {W} WIP, {V} verified, {P} planned
WorkGroups: {A} active, {C} completed
Pending captures: {Q} queued
MCP & vaults: {Connected — N vault(s) | Not connected (optional — workflow still works)}
Relay host: grok
Relay selector: {none | auto | other | claude | codex | invalid}
Relay target: {codex | claude | ask which implementer (both ready) | native Phase 2A | invalid same-host}
Codex detect: {ready (vX.Y.Z, authenticated) | installed-unauthed | not-installed | broken-install}
Claude detect: {ready (vX.Y.Z, authenticated) | installed-unauthed | not-installed | broken-install}
Target config: {provider-specific model, effort/fix effort, permission mode or sandbox}; transport={value}; fix rounds={N}; timeout={N}m
Relay state: {none | wgid — host → target, state, round N, session present|pending [legacy schema 1]}

Next: {one concrete suggested action}
```

Guidance:

- `relay: none` + a candidate ready: `Enable portably with relay or set relay: other.`
- `auto`/`other` + both CLIs ready: report `ask which implementer` — do not pick Codex or Claude in status. After the user names one, later invocations persist via `--relay=claude` or `--relay=codex`, not `--relay=other`.
- Automatically/configured unavailable target: warn that ordinary work may visibly fall back to native Phase 2A.
- Explicit unavailable intent cannot be known from a status-only check; remind that explicit requests stop with remediation.
- Any active-state/config mismatch: show both; do not mutate either during status.
- Neither CLI present: `Cursor cloud agents cannot run relay; hosted Grok Bot may if the CLIs are on this VM.`

Omit non-applicable lines. Keep secrets and complete session identifiers out of the report.
