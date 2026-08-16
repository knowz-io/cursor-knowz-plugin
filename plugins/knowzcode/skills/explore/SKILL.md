---
name: explore
description: "Research a codebase area before implementation. Use when the user wants investigation, architectural context, prior art, or options before changing code."
---

# /knowzcode:explore — Research before implementing

Investigate a topic and stop with findings and recommendations. Knowz MCP is optional and never blocks exploration.

## Instructions

1. Classify the exploration question and resolve any selected WorkGroup, capsule, reusable specification, and current phase **before vault retrieval, parallel delegation, or file writes**. Record the exact unresolved question and relevant subsystem boundaries.
2. Load context progressively. Start with that selected WorkGroup/capsule and goal-relevant spec headings/`VERIFY:` criteria. If neither exists, search the topic first; read only the relevant project, architecture, spec, or prior-WorkGroup sections needed to answer the recorded question.
3. Search the codebase for relevant files and patterns using targeted reads.
4. If the topic spans 2 or more independently useful subsystems, parallelize read-only explorers within the active runtime's capacity. Do not create overlapping scopes and do not implement code in this mode.
5. If the local evidence leaves a named prior-decision or convention question **and** Knowz MCP is available, use a targeted `mcp__knowz__search_knowledge` or `mcp__knowz__ask_question` call. Do not issue a broad baseline vault query. If tools are missing, continue with local evidence only.
6. Produce the **Exploration Deliverable** in chat. Write it to `knowzcode/explore/<topic-slug>/summary.md` only when writes are authorized and durable exploration output is requested or materially useful for recovery.
7. Do not implement changes unless the user explicitly asks to move into `/knowzcode:work` or `/knowzcode:fix`.

## Parallel explorer dispatch

Each explorer must:

- Receive exactly one subsystem boundary. No two explorers share files.
- Stay read-only — do not edit or implement code.
- Default to `ephemeral` output (bounded findings in chat). Use `durable` files only when writes are authorized and recovery needs them.

Skip parallel dispatch when the topic touches a single subsystem.

## Exploration Deliverable

```markdown
# Exploration: {topic}

## Current State
{what exists today, with file:line citations}

## Constraints
{rules, conventions, dependencies that must hold}

## Options
1. {option name} — {one-paragraph description}
2. {option name} — {one-paragraph description}

## Risks
{risk → mitigation, one per bullet}

## Recommendation
{one option from the list above, with rationale}

## Suggested Next Skill
{`/knowzcode:work` for full build or `/knowzcode:fix` for a single-file change — pick one}
```

The `<topic-slug>` is the topic in 2-4 word kebab-case.
