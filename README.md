# Knowz + KnowzCode for Grok Bot and Cursor

## Install on Grok Bot

Grok Bot **Plugins** and Cursor Marketplace are the **same catalog**. Search **Knowz**, then **Add**, then **Authorize**.

1. Open **Plugins** in the sidebar, or follow an in-chat **Connect** card. On mobile, tap your avatar → **Plugins**.
2. Search **Knowz** (knowledge vaults) and/or **KnowzCode** (TDD workflow).
3. **Add** the plugin you want.
4. For **Knowz**, complete **Authorize** in the browser (Knowz login). If the UI says **Waiting for authorization**, use **Reopen**.
5. Confirm the plugin appears under **Installed**.

Do not paste API keys in chat. Grok Bot secret-request keys do **not** attach `Authorization: Bearer`. Authorize is the auth path.

Personal + business Knowz tenants: see [MULTI-ACCOUNT.md](./MULTI-ACCOUNT.md). One connector named `knowz`, same URL, sign out of the first Knowz account in the browser before the second Authorize.

## Install on Cursor

Same listing as Grok Bot.

1. Open **Customize** or **Settings → Plugins**, or browse [cursor.com/marketplace](https://cursor.com/marketplace) after this repo is published.
2. Search **Knowz** and/or **KnowzCode**.
3. **Install** / **Add**. For **Knowz**, **Authorize** when prompted.

Until the public marketplace listing is live, a Cursor team can import this GitHub repo as a [team marketplace](https://cursor.com/docs/plugins.md).

## Two plugins

| Plugin | What you get |
|--------|----------------|
| **Knowz** | Hosted MCP (`https://mcp.knowz.io/mcp`) plus slim vault skills: ask, save, search, browse, amend, setup, status, flush, auto |
| **KnowzCode** | No `mcp.json`. Slim TDD / quality-gate skills plus a Cursor rule. Knowz MCP is **optional** and **never blocks** |

They complement each other and each works alone. Install one or both.

This repo does **not** replace the Claude marketplace:

```text
/plugin marketplace add knowz-io/knowz-skills
```

Use [knowz-io/knowz-skills](https://github.com/knowz-io/knowz-skills) for Claude Code and Codex. Use **this** repo for Grok Bot and Cursor Marketplace.

## Which plugin?

| You want… | Install |
|-----------|---------|
| Persistent team memory — decisions, conventions, lessons | **Knowz** |
| Disciplined feature work — gates, TDD, session handoffs | **KnowzCode** |
| Knowledge-informed development | **Both** — optional complementarity |

## After install

**Knowz**

```text
/knowz-setup          # map vaults once Authorize succeeds
/knowz-ask "…"        # vault Q&A
/knowz-search "…"     # semantic search
/knowz-save "…"       # capture a durable insight
/knowz-status         # connection + vault health
```

Do **not** run `/knowz register` on an existing Knowz account — that creates a **new** account. Sign in during Authorize instead.

**KnowzCode**

```text
/knowzcode:setup      # initialize the framework in a repo
/knowzcode:work "…"   # full TDD workflow with quality gates
/knowzcode:explore    # research first
/knowzcode:fix        # small localized change
/knowzcode:regroup    # local handoff before clearing context
/knowzcode:continue   # resume from the latest handoff
```

KnowzCode never requires Knowz MCP. If vault tools are missing, the local workflow still runs.

## MCP (Knowz plugin only)

```json
{
  "mcpServers": {
    "knowz": {
      "type": "http",
      "url": "https://mcp.knowz.io/mcp"
    }
  }
}
```

One server, no secrets in the repo, no `CLIENT_ID`, no `bearer_token_env_var`, no `x-api-key`.

## Repo layout

```text
.cursor-plugin/marketplace.json
plugins/knowz/          # MCP + vault skills
plugins/knowzcode/      # TDD skills + rules/knowzcode.mdc
```

## Support

- Product: [https://knowz.io](https://knowz.io)
- Email: support@knowz.io
- Multiple accounts: [MULTI-ACCOUNT.md](./MULTI-ACCOUNT.md)
- Privacy: [https://knowz.io/privacy](https://knowz.io/privacy)
- Status: [https://status.knowz.io](https://status.knowz.io)

## License

MIT — see [LICENSE](./LICENSE). Copyright 2026 Knowz / knowz-io.

Skills and the Cursor rule are adapted from the Codex-slim packages in [knowz-io/knowz-skills](https://github.com/knowz-io/knowz-skills) at `35ff36297b6b98623efee48aa146c83cda58288a`.
