# Knowz

Knowz AI plugin for **Grok Bot** and **Cursor Marketplace**. Product name: **Knowz**.

Connects agents to hosted Knowz vaults over MCP. This plugin is **knowledge only**. For TDD / quality gates, install **KnowzCode** separately — do not merge the two.

## Install

1. Grok Bot **Plugins** → search **Knowz** → **Add** → **Authorize**.
2. Same listing in Cursor Marketplace (**Customize** → **Plugins**).

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

`knowz-ask`, `knowz-save`, `knowz-search`, `knowz-browse`, `knowz-amend`, `knowz-setup`, `knowz-status`, `knowz-flush`, `knowz-auto`

## License

MIT — publisher **Knowz AI**. Homepage: [https://knowz.io](https://knowz.io)
