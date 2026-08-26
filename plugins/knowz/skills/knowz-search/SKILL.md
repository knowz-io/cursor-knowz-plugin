---
name: knowz-search
description: "Search Knowz vaults semantically. Use when the user wants prior art, related work, conventions, examples, or a broad search across stored knowledge. For a synthesized answer use /knowz-ask; for vault structure or recent items use /knowz-browse."
---

# /knowz-search — Semantic search

Search across Knowz vaults and present the most relevant matches.

If `enterprise.json` exists in the project root, use its `brand` value instead of "Knowz" in user-facing text.

## Instructions

Read [vault-access.md](../vault-access.md). Prefer `/knowz-cli` when `knowz` is on PATH.

1. Read `knowz-vaults.md` from the project root if it exists.
2. Parse the search query.
3. Route to the best vaults using `When to query` rules.
   - If no routing rules match, search all configured vaults or the default vault.
4. Search directly from the current agent (`knowz search` or `mcp__knowz__search_knowledge`, limit 10). When multiple vaults are targeted, issue those calls in parallel when possible.
5. If titles or snippets are too thin, open the top 1-2 matches with `knowz knowledge get` or `mcp__knowz__get_knowledge_item`.
6. Present results grouped by vault with title, short summary, and why they are relevant. Note that vault entries are point-in-time and may be stale — treat them as leads to verify against the live codebase and current docs.
7. If nothing useful is found, suggest broader search terms, `/knowz-browse`, or `/knowz-ask`.

If neither CLI nor MCP is available, follow [vault-access.md](../vault-access.md). Do not paste API keys in Grok Bot chat.
