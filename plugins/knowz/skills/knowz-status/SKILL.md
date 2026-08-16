---
name: knowz-status
description: "Check Knowz MCP health, Authorize state, vault routing, and pending captures. Use for diagnostics, setup verification, or troubleshooting."
---

# /knowz-status — Check status

Inspect Knowz MCP health and project routing. Auth for this plugin is Authorize on the `knowz` connector, not an API key in chat.

## Instructions

1. Check whether Knowz tools such as `mcp__knowz__list_vaults` are available.
2. If available, call `mcp__knowz__list_vaults` with `includeStats: true`.
3. Check project files only (do not hunt Codex `config.toml`, `claude mcp`, or pasted keys):
   - `enterprise.json`
   - `knowz-vaults.md`
   - `knowz-pending.md`
4. If tools are missing, tell the user to open **Grok Bot Plugins** or **Cursor Marketplace**, search **Knowz**, **Add**, then **Authorize**. Do not paste API keys. secret-request keys do not attach Bearer on Grok Bot.
5. If tools work but vaults look like the wrong tenant, point at [MULTI-ACCOUNT.md](../../../../MULTI-ACCOUNT.md): same-browser-session token reuse, not a missing second URL.
6. Read `knowz-vaults.md` if present and validate listed vault IDs against the server response.
7. Count pending items in `knowz-pending.md` if it exists.
8. Report:
   - MCP connection status
   - server vault count and names
   - vault routing file health
   - pending capture count
   - one concrete next step (Authorize, sign out before a second tenant card, refresh `knowz-vaults.md`, or `/knowz-flush`)
