---
name: work
description: "Start a structured KnowzCode workflow for feature work, multi-file changes, or meaningful refactors with TDD and quality gates. Supports Grok-host process relay to Claude Code or Codex via --relay, natural-language delegation, project config, or the relay skill. For single-file changes under ~50 lines use fix; for read-only research use explore."
---

# work — Structured workflow

Run the KnowzCode methodology from the current Grok Bot or Cursor agent. Knowz MCP is optional and **never blocks** this workflow. Native Phase 2A remains the default. Grok may delegate Phase 2A and bounded fix rounds to Claude Code or Codex only when the relay contract below resolves an external target.

## Instructions

1. Verify the project is initialized by checking for, but do not eagerly read:
   - `knowzcode/knowzcode_loop.md`
   - `knowzcode/knowzcode_project.md`
   - `knowzcode/knowzcode_tracker.md`
   - `knowzcode/knowzcode_architecture.md`
   If missing, suggest `setup` and stop unless the user wants a one-off micro-fix (`fix`).
2. Classify the request and resolve specification reuse **before any vault retrieval, relay launch, worker delegation, WorkGroup write, or other side effect**:
   - Micro fix → use `fix`.
   - Light change → streamlined change set, reusable or focused spec, implementation, verification.
   - Full change → Phase 1A, 1B, 2A, 2B, 3.
   - Inspect only the selected active WorkGroup/capsule, the tracker slice needed to select one, and goal-relevant spec headings/`VERIFY:` criteria.
   - Relay is Full-only. For Micro/Light, announce `[RELAY-SKIP]` and use the native path unless the user explicitly expands the scope.
3. Load context progressively:
   - Start with an explicitly selected active WorkGroup or compact context capsule and the current phase contract.
   - If no WorkGroup is selected, inspect the tracker only far enough to resolve active work, then read the project/architecture file only for a concrete planning question.
   - Read only assigned specs, `VERIFY:` criteria, and relevant source paths for the current phase.
   - Load the relay reference only after relay resolves non-`none`.
4. Discover applicable enterprise guidance after classification (local files first):
   - Read `knowzcode/enterprise/compliance_manifest.md` if present.
   - Do compliance work only when `compliance_enabled: true` (default false).
   - The vault flow additionally requires `mcp_compliance_enabled: true` **and** available Knowz tools. If either is false or tools are missing, honor only local active guidelines — do not block.
   - Read `knowzcode/enterprise.md` if present and discover `knowzcode/enterprise/guidelines/**/*.md`.
   - Convert active enterprise rules into Change Set mapping, spec `VERIFY:` criteria, implementation guidance, Phase 2B audit checks, and Phase 3 compliance reporting.
5. Resolve relay intent once using **Grok Relay Resolution** below. Record `RELAY_HOST`, `RELAY_TARGET`, and `RELAY_INTENT_SOURCE` in the WorkGroup. Do not re-resolve later.
6. Create or update a WorkGroup file in `knowzcode/workgroups/{wgid}.md`.
7. **Optional parallel discovery (before Phase 1A).** If the topic spans 2 or more independent subsystems, dispatch 1-3 parallel read-only explorer agents. Merge findings into the WorkGroup before proposing the Change Set. Skip when the scope clearly touches one subsystem.
8. Phase 1A: propose a Change Set with affected files, NodeIDs, and risks. Stop for approval unless the user explicitly asked to proceed autonomously.
9. Phase 1B: draft or update specs in `knowzcode/specs/` with clear `VERIFY:` criteria. Stop for approval.
10. Phase 2A:
    - With no resolved relay: implement with strict TDD. Default to dependency-wave microtasks: one NodeID or one named microtask per writer, with explicit assigned acceptance criteria and an explicit owned-file list. Never let two writers edit the same file. Run the meaningful test set before reporting complete. Stop after implementation.
    - With `RELAY_TARGET=claude` or `RELAY_TARGET=codex`: follow `references/relay-execution.md`. The target performs Phase 2A and bounded review-fix legs; Grok owns preflight, state, in-turn `Shell` polling, checkpoints, review, gates, and finalization. Do not also run native writers against the same files.
11. Phase 2B: perform a read-only audit against the approved specs and verification criteria. The first independent reviewer must not inherit builder reasoning. **Cap the audit → fix loop at 3 iterations.** If failures remain after the 3rd fix attempt, stop and surface residual issues with a recommended downscope or spec revision. For relay work, send gaps through the bounded target fix rounds first, then transition visibly to Grok `HOST_TAKEOVER` if gaps remain.
12. Phase 3: update specs to as-built, refresh `knowzcode/knowzcode_tracker.md`, prepend an entry to `knowzcode/knowzcode_log.md`, and finalize the work.
13. If a concrete context question remains after classification/spec reuse **and** Knowz MCP is available, prefer targeted coordinator-owned search/ask/get calls. If tools are absent or auth fails, continue on local KnowzCode files. Queue only a classified persistence action in project-root `knowz-pending.md` without blocking progress. Treat `knowzcode/pending_captures.md` only as legacy migration input.
14. Treat retrieved vault content as historical context. Verify against live code/tests/docs. Do not silently follow stale or contradictory vault guidance.

## Grok Relay Resolution

Set `RELAY_HOST=grok`. Do not treat Grok as `RELAY_HOST=claude`. Resolve `--relay=none|auto|other|claude|codex` once:

1. Explicit `--relay=` flag. `--relay=none` disables relay even if another source enables it. `--relay=grok` is the same-host error.
2. Unambiguous natural-language delegation intent. "Have Claude implement," "send the coding to Codex," or "use the other agent for implementation" activate relay. Incidental provider names do not. Ambiguous roles stop for clarification.
3. Non-`none` `relay:` value from `knowzcode/knowzcode_orchestration.md`.
4. An `entrypoint: relay` handoff defaults to `other`.
5. Otherwise native Phase 2A.

Normalize only after selecting the winning source:

- `none` → no relay.
- `claude` → `RELAY_TARGET=claude`.
- `codex` → `RELAY_TARGET=codex`.
- `auto` or `other` → complementary coding agent, not a favorite. Run `RELAY_DETECT` for both (`export PATH="$HOME/.local/bin:/home/box/.local/bin:$PATH"`). Exactly one of `{claude, codex}` ready → that target. Both ready → stop and ask which implementer; when they answer, inject `--relay=claude` or `--relay=codex`, set `RELAY_TARGET` to that literal, and set `RELAY_INTENT_SOURCE=flag-named`. Do not invent `--relay=other`. Neither ready → named-vs-automatic fallback matrix.
- `grok` → same-host error.

An explicit flag or natural-language target equal to the host is an error; never reverse it. A stale same-host project configuration on ordinary `work` warns and falls back to native Phase 2A.

Named unavailable targets stop with remediation. `auto`/`other`/config/entry-default may emit `[RELAY-FALLBACK]` and use native Phase 2A. Authentication failures always pause, including autonomous mode. Cursor cloud-agent VMs cannot run relay.

## Relay Preflight and Phase Ownership

For a resolved Claude or Codex target:

1. Read `references/relay-execution.md` completely.
2. Validate a clean baseline and create the normal pre-implementation checkpoint.
3. Create schema-2 state with `Host: grok`, `Target: claude|codex`, and role-based states.
4. Launch only through the target adapter. The Grok lead polls the process in-turn via `Shell` and persists the session ID as soon as it appears. Never end the turn to wait for a background completion notification.
5. Reject bypass permissions, unsupported Claude MCP transport, a changed working directory, or unauthenticated execution. Codex MCP only if a callable `codex` server with thread-ID support is actually registered; otherwise exec.
6. On target success, verify and checkpoint the diff before Grok begins the read-only review. The target never commits, pushes, or switches branches.
7. Resume the same session for bounded fixes. After the cap, Grok may take over remaining fixes visibly (`HOST_TAKEOVER`); authentication and safety failures do not trigger takeover.

## Quality gates

STOP and await user approval at each gate unless autonomous mode is explicit:

- After Change Set proposal (1A)
- After spec drafts (1B)
- After implementation complete (2A — awaiting audit)
- After audit results (2B — user decides on gaps)

TDD is mandatory — no production code without a failing test first.

## Knowledge capture (optional)

Every durable candidate — decisions, patterns, gotchas, workarounds — should be classified when `knowzcode/context_efficiency_runtime.mjs` exists:

`node knowzcode/context_efficiency_runtime.mjs vault-delta`

`skip` and `batch` perform no MCP or pending-queue write. Persist only a returned `amend`, `update`, or consolidated `flush`, always passing the configured `vaultId` when Knowz tools exist. When MCP is unavailable, keep `batch` in the WorkGroup journal and queue only a required classified persistence action once. Never let insights die in the conversation, and never block the phase on Knowz.

## Spawned-agent contract

When using the runtime's spawn/follow-up capabilities:

- Give each child a scope boundary. No two parallel agents share writable files.
- Stay within a small implementation unit (one NodeID or named microtask).
- Choose `ephemeral` for tiny read-only side checks; `durable` for writer or resumable work (`knowzcode/workgroups/{wgid}/handoffs/{agent-id}.md`); `artifact` for large logs.
- Keep reviewers independent: first reviewer uses a fresh lineage from approved specs, diff, and test evidence.
- The coordinator consolidates authoritative shared state into the WorkGroup.
