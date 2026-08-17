---
name: relay
description: "Relay implementation from Grok Bot / Cursor to Claude Code or Codex while Grok plans, reviews, and finalizes. Use when the user asks to delegate implementation, use the other agent, enable relay, or run relay."
---

# relay — External Implementation Relay

Use this setup-aware entry point when Grok Bot / Cursor should keep ownership of planning, specification, review, quality gates, and finalization while Claude Code or Codex performs Phase 2A implementation and bounded fix rounds.

`RELAY_HOST` is always `grok` in this packaged skill. Prompt text cannot change the host. Do not treat Grok as `RELAY_HOST=claude`. The execution protocol is in `../work/references/relay-execution.md`; `work` owns final target resolution and execution.

## Target Resolution

Pass the user's goal and intent to `work` without reinterpretation. Resolution precedence is:

1. Explicit `--relay=none|auto|other|claude|codex` flag.
2. Unambiguous natural-language delegation intent.
3. Non-`none` project `relay:` configuration.
4. This `relay` entry point defaults to `other`.
5. Otherwise no relay.

Literal `--relay=claude` or `--relay=codex` (and named natural language) stay literal. Never reverse. `--relay=grok`, or natural language assigning implementation to Grok, is a same-host error. Stop and suggest `--relay=other`, `--relay=claude`, or `--relay=codex`.

`auto`/`other` means the complementary coding agent, not a favorite. No preferred-only lock:

1. Run `RELAY_DETECT` for both `claude` and `codex`.
2. Exactly one ready → that `RELAY_TARGET`.
3. Both ready → stop and ask which implementer. When the user answers Claude or Codex, inject exactly one `--relay=claude` or `--relay=codex` into the `work` handoff, set `RELAY_TARGET` to that literal, and set `RELAY_INTENT_SOURCE=flag-named`. Do not invent `--relay=other`. Do not persist a literal project `relay: claude|codex` unless they also ask to keep that provider.
4. Neither ready → named-vs-automatic fallback matrix.

Natural language activates relay only when it assigns an implementation role, for example:

- "Have Claude implement this."
- "Send the coding to Codex."
- "Use the other agent for the coding."

An incidental provider mention such as "build a Codex integration" does not activate relay. If both providers are mentioned but the implementer is ambiguous, stop and ask who should implement.

`--relay=none` disables relay and hands the goal to ordinary `work` without probing CLIs.

## Setup-Aware Entry Flow

1. Verify the project is initialized (`knowzcode/knowzcode_loop.md` exists). Otherwise suggest `setup` and stop.
2. Read `knowzcode/knowzcode_orchestration.md` when present.
3. Run `RELAY_DETECT` from the execution reference. Prepend `$HOME/.local/bin` and `/home/box/.local/bin` to `PATH` first — `command -v claude|codex` fails on the Grok VM otherwise. Cursor cloud-agent VMs do not have those CLIs; never claim they can run relay.
4. Apply intent-aware readiness handling. Named unavailable target: stop with remediation. `auto`/`other`/config/entry-default unavailable: carry the failed result into `work` so it emits `[RELAY-FALLBACK]`. Installed but unauthenticated: stop and ask the user to authenticate (`codex login` or `claude auth login`); never print Claude auth JSON.
5. If the project selector is missing or `none`, offer once to persist the portable opt-in `relay: other`. Declining persistence still runs this invocation with entry-point selector `other`.
6. Hand off to `work`, preserving the complete goal, all explicit flags, natural-language wording, and an `entrypoint: relay` marker. If arguments had no `--relay=` flag, inject exactly one `--relay={RELAY_SELECTOR}`. Do not repeat target resolution after `work` records `RELAY_TARGET`.

If no goal is supplied and there is no clear recent plan, handoff, or active WorkGroup, ask what the relay should build.

## Availability Outcomes

- Explicitly named Claude or Codex unavailable: stop with that provider's remediation.
- `other`/`auto` unavailable: `work` may visibly fall back to native Phase 2A.
- Any authentication failure: stop, including in autonomous mode.
- Micro-fix: use `fix`; relay remains a full-workflow capability.
- Status-only request: use `status` without starting work.

## Related Skills

- `work` — resolves the target and runs the workflow.
- `continue` — resumes schema-2 or legacy relay state.
- `status` — reports selector, resolved target, readiness, and state.
