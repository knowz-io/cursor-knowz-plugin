---
name: knowz-setup
description: "Connect Knowz (CLI or hosted MCP) and create vault routing files. Use after installing the Knowz plugin, for first-time vault mapping, Grok Build /mcps OAuth, or when tools are missing after Authorize."
---

# /knowz-setup — Connect and map vaults

Connect Knowz (CLI or hosted MCP), then write project vault routing.

Read [vault-access.md](../vault-access.md). Pick the host the user is on.

Skip to **Create or refresh vault routing** only when a backend is actually usable: `knowz whoami` exits 0, or Knowz MCP tools are present in this session. `command -v knowz` alone is not enough (a fresh `npm i -g @knowzai/cli` is commonly logged out; exit 3 → `knowz login` or `knowz login --sso`). If neither backend is ready, follow the host connect steps below, then come back.

## Grok Build (local `grok` CLI)

```bash
grok plugin marketplace add knowz-io/cursor-knowz-plugin
grok plugin install knowz-io/cursor-knowz-plugin#plugins/knowz --trust
npm i -g @knowzai/cli && knowz login    # optional, preferred
```

`--trust` attaches `https://mcp.knowz.io/mcp` but does not log in. Start a new Grok session. Then either:

- CLI: `knowz whoami` (exit 3 → `knowz login`)
- MCP OAuth: `/mcps` → **knowz** → press `i`

`grok mcp doctor knowz` reporting `OAuth authorization required` means OAuth is still pending. API keys belong in `grok mcp add --header`, never in the chat transcript. Do not add `knowz-io/knowz-skills` as a Grok marketplace.

## Grok Bot / Cursor Marketplace

Grok Bot Plugins and Cursor Marketplace are the same catalog.

**Grok Bot**

1. Open **Plugins** in the sidebar (or follow an in-chat **Connect** card). On mobile, tap the avatar → **Plugins**.
2. Search **Knowz**.
3. **Add**, then **Authorize**.
4. Finish the Knowz login in the browser. If the UI says **Waiting for authorization**, use **Reopen**.
5. Confirm Knowz appears under **Installed**.

**Cursor Marketplace** (same listing)

1. Open **Customize** or **Settings → Plugins**.
2. Search **Knowz**.
3. **Install** / **Add**, then **Authorize**.

Do **not** run `/knowz register` when the user already has a Knowz account — that path creates a **new** account. Sign in during Authorize instead.

Do not paste API keys in chat. Grok Bot secret-request keys do not attach Bearer.

For a second Knowz tenant (personal + business): one connector named `knowz`, same URL `https://mcp.knowz.io/mcp`. Sign out of the first Knowz account in the browser (or use another profile) before the second Authorize. Same-browser-session token reuse looks connected but shows the same vaults.

## Endpoint

Use `https://mcp.knowz.io/mcp` unless the project root has `enterprise.json` with `mcp_endpoint`. `--dev` may use `https://mcp.dev.knowz.io/mcp`. `--endpoint <url>` overrides.

## Create or refresh vault routing

Generate `knowz-vaults.md` at the project root if it does not already exist. This file drives vault routing for `/knowz-search`, `/knowz-ask`, `/knowz-browse`, and `/knowz-save`.

1. List vaults: `knowz vault list --json` or `mcp__knowz__list_vaults`.
2. For each vault, write a section:
   - **ID** — the vault id from the server
   - **Description** — what the vault stores
   - **When to query** — situations that should fan out to this vault
   - **When to save** — situations that should write to this vault
   - **Content template** — `[CONTEXT] / [INSIGHT] / [RATIONALE] / [TAGS]`
3. Set a **Default vault** at the bottom for cases that match no rule.
4. Add a **Trust & Freshness** section: vault entries are point-in-time and may be stale — treat them as leads to verify against the live codebase, tests, and current docs.
5. Do not invent fields; if information is missing, leave the section short.

If `knowz-vaults.md` already exists, offer to refresh it: re-list vaults, append any new ones, and flag vaults present in the file but absent from the server.

## Verify

1. Vault list returns at least one id (CLI or MCP).
2. A search against the default vault succeeds (or empty-but-successful).
3. Confirm the resolved brand from `enterprise.json#/brand` (default `Knowz`).

Report the brand, vault count, and which backend is active (CLI vs MCP). On Grok Bot, Authorize — not an API key in chat — is the auth path.
