# KnowzCode Rules

This project uses KnowzCode for structured TDD development.

Knowz MCP is optional and never blocks KnowzCode work. On Grok Build, prefer the `knowz` CLI when it is on PATH; otherwise Knowz MCP after `/mcps` → **knowz** → `i`.

## Required reading

Before any feature work, read:

- `knowzcode/knowzcode_loop.md` — Complete methodology
- `knowzcode/knowzcode_project.md` — Project context
- `knowzcode/knowzcode_tracker.md` — Active WorkGroups
- `knowzcode/knowzcode_architecture.md` — Architecture docs

## Phase rules

### Phase 1A: Impact Analysis

- Identify affected components and propose a Change Set
- NodeIDs are domain concepts (PascalCase), not tasks
- Check `knowzcode/specs/` before creating new specs
- PAUSE for user approval before proceeding

### Phase 1B: Specification

- Use 4-section format: Rules & Decisions, Interfaces, Verification Criteria, Debt & Gaps
- Minimum: 2+ VERIFY statements per spec
- PAUSE for user approval, then commit specs

### Phase 2A: Implementation

- TDD is mandatory: write failing test FIRST, then minimal code, then refactor
- Run the meaningful test set before reporting complete
- PAUSE after implementation

### Phase 2B: Audit

- READ-ONLY — do not modify source files
- Compare implementation vs spec VERIFY statements
- Report completion percentage and gaps
- PAUSE for user decision

### Phase 3: Finalization

- Update specs to As-Built status
- Update tracker and log
- Check architecture for drift
- Final commit

## Enforcement

- Never skip phases or quality gates
- TDD is mandatory — no production code without a failing test
- Every WorkGroup todo starts with `KnowzCode:` prefix
- Consolidate specs when domains overlap >50%
- Target <20 specs per project
- Log completions in `knowzcode/knowzcode_log.md`

## Knowledge capture

Durable candidates (decisions, patterns, gotchas, workarounds) should be saved when a Knowz backend is available (`knowz` CLI or MCP). When it is not, keep the candidate in the WorkGroup journal or `knowz-pending.md`. Never block a phase on Knowz.

Use `/knowz-save` when the Knowz plugin is installed. Treat vault entries as point-in-time leads to verify against the live codebase.

## Slash commands

`/knowzcode:work`, `/knowzcode:explore`, `/knowzcode:fix`, `/knowzcode:setup`, `/knowzcode:status`, `/knowzcode:continue`, `/knowzcode:relay`, `/knowzcode:regroup`
