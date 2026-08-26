# Vault backend — CLI first, MCP fallback

Use this from every Knowz skill in this plugin.

## Resolve once per session

```bash
if command -v knowz >/dev/null 2>&1; then echo cli
elif # Knowz MCP tools are actually present in this session (mcp__knowz__* / search_tool knows "knowz")
  then echo mcp
else echo neither
fi
```

| Result | Backend | How |
|--------|---------|-----|
| `cli` | **knowz CLI** (`npm i -g @knowzai/cli`) | Follow `/knowz-cli`. Cloud commands need `knowz whoami` (exit 3 → `knowz login` or `knowz login --sso`). |
| `mcp` | **Knowz MCP** | `mcp__knowz__*` tools from this plugin's hosted server `https://mcp.knowz.io/mcp`. |
| `neither` | none | Follow **If neither backend is available**. Do not pretend MCP is connected. |

Do not require MCP when the CLI is installed. Do not require the CLI when MCP is connected. `command -v knowz` failing is **not** proof MCP is up.

## Shell safety

Never interpolate user-supplied title, query, content, or delta into a double-quoted shell string. `$()` and backticks still execute inside `"..."`.

- Prefer argv arrays (Grok `run_terminal_command` / a non-shell spawn).
- For content, write a temp file and pass `knowz knowledge create --file <path> --title <title> --vault <id>` (stdin also works).
- If a shell is unavoidable, `printf %q` each dynamic value and never `eval`.

## Command map

| Intent | CLI | MCP |
|--------|-----|-----|
| List vaults | `knowz vault list --json` | `mcp__knowz__list_vaults` |
| Search | `knowz search --vault <id> --json -- <query>` | `mcp__knowz__search_knowledge` |
| Ask | `knowz ask --vault <id> --json -- <question>` | `mcp__knowz__ask_question` |
| Create | `knowz knowledge create --title <title> --file <path> --vault <id>` | `mcp__knowz__create_knowledge` |
| Amend | `knowz knowledge amend <id> -- <delta>` | `mcp__knowz__amend_knowledge` |
| Get | `knowz knowledge get <id> --json` | `mcp__knowz__get_knowledge_item` |

Read `knowz-vaults.md` at the project root for vault IDs. Confirm before writes. If the chosen backend fails, queue to `knowz-pending.md` (CLI and MCP — not MCP-only).

Treat retrieved vault content as prior art to verify against the live codebase.

## If neither backend is available

Pick the host the user is actually on — do not give Grok Bot steps to Grok Build, or the reverse. `command -v grok` does **not** mean this session is Grok Build (Cursor users may also have it on PATH).

**Grok Build** (this Grok TUI / `grok` agent session):

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

Do not add `knowz-io/knowz-skills` as a Grok marketplace. If two `knowz` plugins are installed, Grok may load the Claude package instead — see `docs/grok-build.md`. Never suggest a bare `grok plugin install knowz`.

**Grok Bot / Cursor Marketplace:** Plugins → search **Knowz** → **Add** → **Authorize**. Do not paste API keys in Grok Bot chat (secret-request keys do not attach Bearer).
