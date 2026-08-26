# Vault backend — CLI first, MCP fallback

Use this from every Knowz skill in this plugin.

## Resolve once per session

```bash
command -v knowz >/dev/null 2>&1 && echo cli || echo mcp
```

| Result | Backend | How |
|--------|---------|-----|
| `cli` | **knowz CLI** (`npm i -g @knowzai/cli`) | Follow `/knowz-cli`. Cloud commands need `knowz whoami` (exit 3 → `knowz login` or `knowz login --sso`). |
| `mcp` | **Knowz MCP** | `mcp__knowz__*` tools from this plugin's hosted server `https://mcp.knowz.io/mcp`. |

Do not require MCP when the CLI is installed. Do not require the CLI when MCP is connected.

## Command map

| Intent | CLI | MCP |
|--------|-----|-----|
| List vaults | `knowz vault list --json` | `mcp__knowz__list_vaults` |
| Search | `knowz search "<q>" --vault <id> --json` | `mcp__knowz__search_knowledge` |
| Ask | `knowz ask "<q>" --vault <id> --json` | `mcp__knowz__ask_question` |
| Create | `knowz knowledge create "<title>" --content "..." --vault <id>` | `mcp__knowz__create_knowledge` |
| Amend | `knowz knowledge amend <id> "<delta>"` | `mcp__knowz__amend_knowledge` |
| Get | `knowz knowledge get <id> --json` | `mcp__knowz__get_knowledge_item` |

Read `knowz-vaults.md` at the project root for vault IDs. Confirm before writes. If both backends fail, queue to `knowz-pending.md`.

Treat retrieved vault content as prior art to verify against the live codebase.

## If neither backend is available

Pick the host the user is actually on — do not give Grok Bot steps to Grok Build, or the reverse.

**Grok Build** (local `grok` CLI):

```bash
grok plugin marketplace add knowz-io/cursor-knowz-plugin
grok plugin install knowz-io/cursor-knowz-plugin#plugins/knowz --trust
# optional CLI (preferred; no MCP OAuth):
npm i -g @knowzai/cli && knowz login
```

`--trust` attaches `https://mcp.knowz.io/mcp` but does **not** complete login. Authenticate MCP in the TUI:

1. New Grok session (or `r` in the Plugins tab).
2. `/mcps` → select **knowz** → press `i` to OAuth in the browser.
3. `/knowz-status`. `grok mcp doctor knowz` saying `OAuth authorization required` means this step is still pending.

Static API key (user-scope config, **never** chat):

```bash
grok mcp add --transport http knowz https://mcp.knowz.io/mcp --header "Authorization: Bearer <api-key>"
```

Do not add `knowz-io/knowz-skills` as a Grok marketplace. If two `knowz` plugins are installed, Grok may load the Claude package instead — see `docs/grok-build.md`.

**Grok Bot / Cursor Marketplace:** Plugins → search **Knowz** → **Add** → **Authorize**. Do not paste API keys in Grok Bot chat (secret-request keys do not attach Bearer).
