---
name: knowz-setup
description: "Connect Knowz MCP and create vault routing files. Use after installing the Knowz plugin, for first-time vault mapping, or when tools are missing after Authorize."
---

# /knowz-setup — Connect and map vaults

Configure hosted Knowz MCP for Grok Bot and Cursor, then write project vault routing.

Grok Bot Plugins and Cursor Marketplace are the same catalog. Do not treat this as Cursor-IDE-only.

## Primary install (do this first)

If Knowz tools such as `mcp__knowz__list_vaults` are already available, skip to **Create or refresh vault routing**.

Otherwise tell the user to connect the plugin — do not paste API keys in chat, and do not treat a secret-request card as working Bearer auth on Grok Bot (those keys do not attach `Authorization: Bearer`).

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

Do **not** use `claude mcp`, Codex `config.toml`, or `/knowz setup <api-key>` as the primary setup. Those belong to other install surfaces.

For a second Knowz tenant (personal + business), follow [MULTI-ACCOUNT.md](../../../../MULTI-ACCOUNT.md): one connector named `knowz`, same URL, sign out of the first Knowz account in the browser (or use another profile) before the second Authorize.

## Endpoint

Use `https://mcp.knowz.io/mcp` unless the project root has `enterprise.json` with `mcp_endpoint`. `--dev` may use `https://mcp.dev.knowz.io/mcp`. `--endpoint <url>` overrides.

## Create or refresh vault routing

Generate `knowz-vaults.md` at the project root if it does not already exist. This file drives vault routing for `/knowz-search`, `/knowz-ask`, `/knowz-browse`, and `/knowz-save`.

1. Call `mcp__knowz__list_vaults` to discover available vaults.
2. For each vault, write a section:
   - **ID** — the vault id from the server
   - **Description** — what the vault stores
   - **When to query** — situations that should fan out to this vault
   - **When to save** — situations that should write to this vault
   - **Content template** — `[CONTEXT] / [INSIGHT] / [RATIONALE] / [TAGS]`
3. Set a **Default vault** at the bottom for cases that match no rule.
4. Add a **Trust & Freshness** section: vault entries are point-in-time and may be stale — treat them as leads to verify against the live codebase, tests, and current docs.
5. Do not invent fields; if information is missing, leave the section short.

If `knowz-vaults.md` already exists, offer to refresh it: re-read `mcp__knowz__list_vaults`, append any new vaults, and flag vaults present in the file but absent from the server.

## Verify

1. `mcp__knowz__list_vaults` returns at least one vault id.
2. `mcp__knowz__search_knowledge` against the default vault returns a result (or an empty-but-successful response).
3. Confirm the resolved brand from `enterprise.json#/brand` (default `Knowz`).

Report the brand, vault count, and that Authorize — not an API key in chat — is how this plugin authenticates.
