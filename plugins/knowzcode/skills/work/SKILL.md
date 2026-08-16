---
name: work
description: "Start a structured KnowzCode workflow for feature work, multi-file changes, or meaningful refactors with TDD and quality gates. For single-file changes under ~50 lines use /knowzcode:fix; for read-only research use /knowzcode:explore."
---

# /knowzcode:work — Structured workflow

Run the KnowzCode methodology from the current Grok Bot or Cursor agent. Knowz MCP is optional and **never blocks** this workflow.

## Instructions

1. Verify the project is initialized by checking for, but do not eagerly read:
   - `knowzcode/knowzcode_loop.md`
   - `knowzcode/knowzcode_project.md`
   - `knowzcode/knowzcode_tracker.md`
   - `knowzcode/knowzcode_architecture.md`
   If missing, suggest `/knowzcode:setup` and stop unless the user wants a one-off micro-fix (`/knowzcode:fix`).
2. Classify the request **before any vault retrieval, worker delegation, WorkGroup write, or other side effect**:
   - Micro fix → use `/knowzcode:fix`.
   - Light change → streamlined change set, reusable or focused spec, implementation, verification.
   - Full change → Phase 1A, 1B, 2A, 2B, 3.
   - Inspect only the selected active WorkGroup/capsule, the tracker slice needed to select one, and goal-relevant spec headings/`VERIFY:` criteria.
3. Load context progressively:
   - Start with an explicitly selected active WorkGroup or compact context capsule and the current phase contract.
   - If no WorkGroup is selected, inspect the tracker only far enough to resolve active work, then read the project/architecture file only for a concrete planning question.
   - Read only assigned specs, `VERIFY:` criteria, and relevant source paths for the current phase.
4. Discover applicable enterprise guidance after classification (local files first):
   - Read `knowzcode/enterprise/compliance_manifest.md` if present.
   - Do compliance work only when `compliance_enabled: true` (default false).
   - The vault flow additionally requires `mcp_compliance_enabled: true` **and** available Knowz tools. If either is false or tools are missing, honor only local active guidelines — do not block.
   - Read `knowzcode/enterprise.md` if present and discover `knowzcode/enterprise/guidelines/**/*.md`.
   - Convert active enterprise rules into Change Set mapping, spec `VERIFY:` criteria, implementation guidance, Phase 2B audit checks, and Phase 3 compliance reporting.
5. Create or update a WorkGroup file in `knowzcode/workgroups/{wgid}.md`.
6. **Optional parallel discovery (before Phase 1A).** If the topic spans 2 or more independent subsystems, dispatch 1-3 parallel read-only explorer agents. Merge findings into the WorkGroup before proposing the Change Set. Skip when the scope clearly touches one subsystem.
7. Phase 1A: propose a Change Set with affected files, NodeIDs, and risks. Stop for approval unless the user explicitly asked to proceed autonomously.
8. Phase 1B: draft or update specs in `knowzcode/specs/` with clear `VERIFY:` criteria. Stop for approval.
9. Phase 2A: implement with strict TDD. Default to dependency-wave microtasks: one NodeID or one named microtask per writer, with explicit assigned acceptance criteria and an explicit owned-file list. Never let two writers edit the same file. Run the meaningful test set before reporting complete. Stop after implementation.
10. Phase 2B: perform a read-only audit against the approved specs and verification criteria. The first independent reviewer must not inherit builder reasoning. **Cap the audit → fix loop at 3 iterations.** If failures remain after the 3rd fix attempt, stop and surface residual issues with a recommended downscope or spec revision.
11. Phase 3: update specs to as-built, refresh `knowzcode/knowzcode_tracker.md`, prepend an entry to `knowzcode/knowzcode_log.md`, and finalize the work.
12. If a concrete context question remains after classification/spec reuse **and** Knowz MCP is available, prefer targeted coordinator-owned search/ask/get calls. If tools are absent or auth fails, continue on local KnowzCode files. Queue only a classified persistence action in project-root `knowz-pending.md` without blocking progress. Treat `knowzcode/pending_captures.md` only as legacy migration input.
13. Treat retrieved vault content as historical context. Verify against live code/tests/docs. Do not silently follow stale or contradictory vault guidance.

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
