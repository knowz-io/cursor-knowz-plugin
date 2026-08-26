# Knowz

Knowz AI plugin for **Grok Build**, **Grok Bot**, and **Cursor**. Product name: **Knowz**.

Connects agents to Knowz vaults: **CLI first** (`knowz` / `/knowz-cli`) then hosted MCP. This plugin is **knowledge only**. For TDD / quality gates, install **KnowzCode** separately — do not merge the two.

## Install

**Grok Build**

```bash
grok plugin marketplace add knowz-io/cursor-knowz-plugin
grok plugin install knowz --trust
npm i -g @knowzai/cli && knowz login    # optional
```

**Grok Bot / Cursor:** Plugins → search **Knowz** → **Add** → **Authorize**.

Do not paste API keys in chat. Do not run `/knowz register` on an existing Knowz account (that creates a new account). Sign in during Authorize.

Personal + business tenants: one connector named `knowz`, same URL. Sign out of the first Knowz account in the browser before the second Authorize.

## MCP

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

Auth is Authorize against Knowz. No secrets, `CLIENT_ID`, `bearer_token_env_var`, or `x-api-key` in this package.

## Skills

`knowz-ask`, `knowz-save`, `knowz-search`, `knowz-browse`, `knowz-amend`, `knowz-setup`, `knowz-status`, `knowz-flush`, `knowz-auto`, `knowz-cli`

Vault calls follow `skills/vault-access.md`: CLI if `knowz` is on PATH, otherwise MCP.

## License

MIT — publisher **Knowz AI**. Homepage: [https://knowz.io](https://knowz.io)
