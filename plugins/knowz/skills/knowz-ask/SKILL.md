---
name: knowz-ask
description: "Ask AI-powered questions against Knowz vaults. Use when the user asks about prior decisions, conventions, architecture, patterns, trade-offs, or wants an answer grounded in stored team knowledge."
---

# /knowz-ask — Vault Q&A

Answer the user's question using Knowz vaults.

If `enterprise.json` exists in the project root, use its `brand` value instead of "Knowz" in user-facing text.

## Instructions

Read [vault-access.md](../vault-access.md) first. Prefer `/knowz-cli` when `knowz` is on PATH; otherwise MCP.

1. Read `knowz-vaults.md` from the project root if it exists.
   - If it does not exist, continue without vault routing and suggest `/knowz-setup` after the answer.
2. Parse the user's question.
3. Route to the best vaults using each vault's `When to query` rules.
   - One match → query that vault.
   - Multiple matches → query all matching vaults.
   - No match → use the default vault when available.
4. Query directly from the current agent. Do not assume helper reader agents.
   - CLI: `knowz ask "<question>" --vault <id> --json` (add `--research` for multi-part / why questions)
   - MCP: one `mcp__knowz__ask_question` per target vault (`researchMode: true` for multi-part / why)
5. If the answer is still too thin, open cited items with `knowz knowledge get <id>` or `mcp__knowz__get_knowledge_item`.
6. Answer naturally and mention which vaults informed the result when possible. Frame vault knowledge as **point-in-time and to be verified, not current fact** — prefer the live source when it conflicts with a vault entry.

If neither CLI nor MCP is available, follow the host-specific connect steps in [vault-access.md](../vault-access.md). Do not paste API keys in Grok Bot chat.
