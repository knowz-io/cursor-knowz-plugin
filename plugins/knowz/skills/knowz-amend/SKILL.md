---
name: knowz-amend
description: "Apply a targeted server-side edit to an existing Knowz vault item without retyping the whole entry. Use when the user describes a delta — fix a typo, add a line, change a tag, append a caveat — to knowledge that already exists in a vault."
---

# /knowz-amend — Targeted vault edit

Patch an existing Knowz knowledge item with just the change the user describes. Prefer this over `/knowz-save` + "Replace existing" whenever the change is partial — `amend_knowledge` preserves untouched fields server-side and does not require the user to retype the whole entry.

If `enterprise.json` exists in the project root, use its `brand` value instead of "Knowz" in user-facing text.

## Routing

If the user hands over a **complete new body** or explicitly asks to "replace" or "rewrite" the entry, use `/knowz-save` with "Replace existing item" instead — that path calls `update_knowledge`.

If the target item does not exist yet, use `/knowz-save` — amend cannot create new items.

## Instructions

Read [vault-access.md](../vault-access.md). Prefer `/knowz-cli` when `knowz` is on PATH.

1. Read `knowz-vaults.md` from the project root if it exists.
2. Parse the user's change from the request. Strip any `--id <knowledgeId>` flag and remember the value.
3. **Resolve the target item:**
   - If `--id` was provided → `knowz knowledge get <id>` or `mcp__knowz__get_knowledge_item(id)` to confirm the item exists and fetch its title + vault for the confirmation step.
   - If no `--id` → extract the subject of the change and search (`knowz search` or `mcp__knowz__search_knowledge`) scoped to the vault routing rules in `knowz-vaults.md` with `limit: 5`.
     - One clear match → use it.
     - Multiple plausible matches → present the top 3 with titles and snippets and ask the user which one.
     - Zero matches → report no matching item was found and suggest `/knowz-save` instead. Stop.
4. **Confirm the change with the user before writing:**
   ```
   Amending in {Vault Name}:
     Title:  {existing title}
     Change: {user's requested change}
   ```
   Proceed only on explicit yes.
5. Resolve one stable `Idempotency Key` from `amend`, the resolved target vault, `KnowledgeId`, normalized title, and a digest of the exact delta. It MUST NOT contain a timestamp, retry count, agent/session ID, or attempt number. Reuse it for every retry.
6. **Amend** via `knowz knowledge amend <id> "<delta>"` or `mcp__knowz__amend_knowledge` with the resolved KnowledgeId. Do NOT send the full prior content.
7. **If the server reports the target is missing** (deleted concurrently, bad id): do NOT silently fall through to create a new item. Report the missing-target conflict and offer `/knowz-save` as the next step.
8. **If the CLI or MCP write fails** (server unreachable, auth expired), read `knowz-pending.md` first and append a canonical block only when the same key/content is absent. The same key with different mutation content is a collision and MUST fail closed. Wrap the block in `---` delimiters — the flush parser splits on them.

   ```markdown
   ---

   ### {timestamp} -- Amend: {existing title}
   - **Operation**: amend
   - **Idempotency Key**: {stable key resolved before the mutation}
   - **Queue Status**: pending
   - **KnowledgeId**: {id}
   - **Category**: {category}
   - **Target Vault**: {vault}
   - **Source**: knowz-amend
   - **Payload**:
   {the delta only — not the full prior body}

   ---
   ```

   Report: "Queued to knowz-pending.md — run /knowz-flush when a backend is available."
9. **Report success:**
   ```
   Knowledge amended!
     Title:  {title}
     Vault:  {vault}
     Change: {short summary of what was patched}
   ```

If neither CLI nor MCP is available, follow [vault-access.md](../vault-access.md). Do not paste API keys in Grok Bot chat.
