# Multiple Knowz accounts (personal + business)

Grok Bot and Cursor Marketplace share one plugin catalog. Knowz uses **one connector** named `knowz` at **one URL**:

```text
https://mcp.knowz.io/mcp
```

Think Gmail-style accounts: add **personal** and **business** cards on the same connector. Do not add the URL twice. Do not invent a second server name (`knowz-personal`, `knowz-business`). Per-tenant resource URLs are **not** required and are **not** the blocker.

## What isolation actually is

Isolation works when the **second Authorize** is a **different Knowz tenant**.

The hosted MCP authenticates the browser session that completes Authorize. Two cards on `knowz` stay isolated only when that second handshake logs into a different Knowz account than the first.

## How to add a second tenant

1. Install **Knowz** once: Grok Bot **Plugins** (or Cursor Marketplace) → search **Knowz** → **Add**.
2. Complete **Authorize** for the first tenant (for example personal).
3. Confirm vaults look like that tenant (`/knowz-status` or `list_vaults`).
4. **Sign out** of the first Knowz account in the **browser** (or open a different browser profile / private window).
5. Add the second account card on the same `knowz` connector and **Authorize** again.
6. Confirm the second card lists the other tenant's vaults.

If Grok Bot shows **Waiting for authorization**, use **Reopen** so the browser tab comes back.

## Failure mode: same-browser-session token reuse

If you Authorize the second card while still signed into the first Knowz account in that browser, the handshake **reuses the first session token**.

Symptoms:

- The second card **looks connected**.
- Tools succeed.
- Vaults are the **same** as the first card.

That is not a missing URL, a missing `X-Project-Path`, or a need for two MCP server names. Sign out (or switch profile) and Authorize the second card again.

## What does not isolate tenants

| Approach | Why it fails |
|----------|----------------|
| Add `https://mcp.knowz.io/mcp` a second time | Same connector, same URL. Extra copies do not create a tenant. |
| Name servers `knowz-personal` and `knowz-business` | This plugin ships **one** server: `knowz`. Extra names are not the supported path. |
| Set `X-Project-Path` | In-tenant routing (which project inside the signed-in tenant). It does **not** switch tenants. |
| Per-tenant resource URLs | Not required. Not the blocker when two cards show the same vaults. |
| Paste an API key in chat | Do not do this. |
| Grok Bot secret-request / plugin variable API keys | Those keys **do not attach `Authorization: Bearer`** on Grok Bot. Authorize is the auth path. |

## Auth rules for this plugin

- Primary auth is **Authorize** on the `knowz` HTTP MCP at `https://mcp.knowz.io/mcp`.
- Do **not** paste Knowz API keys into chat or ordinary files.
- Do **not** run `/knowz register` when you already have a Knowz account — that creates a **new** account.
- Do **not** use `claude mcp`, Codex `config.toml`, or `/knowz setup <api-key>` as the primary path on Grok Bot / Cursor Marketplace.

## Check

After each Authorize, ask the agent to list vaults (or run `/knowz-status`). Personal and business cards should show **different** vault sets. If they match, you hit same-browser-session token reuse — sign out of Knowz in the browser and Authorize the second card again.
