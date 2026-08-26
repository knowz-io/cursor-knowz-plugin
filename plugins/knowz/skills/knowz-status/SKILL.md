---
name: knowz-status
description: "Check Knowz MCP health, Authorize state, vault routing, and pending captures. Use for diagnostics, setup verification, or troubleshooting."
---

# /knowz-status — Check status

Inspect Knowz health and project routing. Read [vault-access.md](../vault-access.md).

## Instructions

1. Resolve backend: `knowz` on PATH and/or Knowz MCP tools.
2. List vaults (`knowz vault list --json` or `mcp__knowz__list_vaults` with `includeStats: true`).
3. Check project files only (do not hunt pasted keys):
   - `enterprise.json`
   - `knowz-vaults.md`
   - `knowz-pending.md`
4. If neither backend is available, follow host-specific connect steps in [vault-access.md](../vault-access.md). Do not paste API keys in Grok Bot chat.
5. If tools work but vaults look like the wrong tenant: same-browser-session token reuse, not a missing second URL. Sign out of the first Knowz account in the browser before the second Authorize.
6. Read `knowz-vaults.md` if present and validate listed vault IDs against the server response.
7. Count pending items in `knowz-pending.md` if it exists.
8. Report:
   - Backend: CLI / MCP / neither
   - MCP connection status (if applicable)
   - server vault count and names
   - vault routing file health
   - pending capture count
   - one concrete next step (Authorize, sign out before a second tenant card, refresh `knowz-vaults.md`, or `/knowz-flush`)
