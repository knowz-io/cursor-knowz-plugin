# Grok Build

This repo is the Knowz AI marketplace for **Grok Build**, **Grok Bot**, and **Cursor**. Two plugins, never merged: **Knowz** (vaults) and **KnowzCode** (TDD).

Grok Build is the local coding agent (`grok` CLI / TUI). It is **not** Grok Bot (the hosted chat product). Bot uses Authorize in a Plugins UI. Build uses `grok plugin …`, optional `knowz` CLI, and MCP OAuth in `/mcps`.

Do **not** install `knowz-io/knowz-skills` into Grok Build. That package ships Claude monoliths, Agent Teams, and telemetry. This repo is the Grok/Cursor package.

## Fastest install (no clone)

```bash
grok plugin marketplace add knowz-io/cursor-knowz-plugin
grok plugin install knowz-io/cursor-knowz-plugin#plugins/knowz --trust
grok plugin install knowz-io/cursor-knowz-plugin#plugins/knowzcode --trust
```

`--trust` attaches Knowz MCP from `plugins/knowz/.mcp.json`. Skills load in a **new** Grok session (`r` in the Plugins tab also reloads).

Use the `#plugins/…` source, not a bare `grok plugin install knowz`. If `knowz-io/knowz-skills` is also a marketplace, the short name is ambiguous and Grok asks you to pin `knowz@<qualifier>`.

After the marketplace is the only Knowz source, the short names work:

```bash
grok plugin install knowz --trust
grok plugin install knowzcode --trust
```

From a clone of this repo:

```bash
./scripts/install-grok.sh
# or: ./scripts/install-grok.sh --cli          # also npm i -g @knowzai/cli
# or: ./scripts/install-grok.sh --replace-collisions
```

Local path or git URL also work as marketplace sources:

```bash
grok plugin marketplace add /path/to/cursor-knowz-plugin
grok plugin marketplace add https://github.com/knowz-io/cursor-knowz-plugin.git
```

Pin the marketplace so every Grok session sees it. User-scope (`~/.grok/config.toml`) or project-scope (`.grok/config.toml`):

```toml
[[marketplace.sources]]
name = "cursor-knowz-plugin"
git = "https://github.com/knowz-io/cursor-knowz-plugin.git"

[plugins]
enabled = ["knowz", "knowzcode"]
```

## First-run vault access

Pick **one**. CLI is preferred when you already use `@knowzai/cli`. MCP OAuth is the Grok-native path (same account as Grok Bot Authorize).

1. **knowz CLI (preferred when installed)**

   ```bash
   npm i -g @knowzai/cli
   knowz login          # or: knowz login --sso
   knowz whoami
   ```

2. **Grok MCP OAuth** (plugin MCP after `--trust`)

   In the Grok TUI: `/mcps` → select **knowz** → press `i` to authorize. Grok opens a browser, stores tokens in `~/.grok/mcp_credentials.json`. Then `/knowz-status`.

   `grok mcp doctor knowz` reports `OAuth authorization required` until that step succeeds. That is expected, not a broken plugin.

3. **Static API key** (last resort; user-scope config, never chat)

   ```bash
   grok mcp add --transport http knowz https://mcp.knowz.io/mcp --header "Authorization: Bearer <api-key>"
   ```

Do **not** run `/knowz register` on an existing Knowz account. Do not paste API keys in the Grok Build chat.

Then: `/knowz-setup` (writes `knowz-vaults.md`) and `/knowzcode:setup` if the repo has no `knowzcode/` yet.

## After install

```text
/knowz-status
/knowz-setup
/knowz-cli              # if knowz is on PATH
/knowz-ask "…"
/knowzcode:setup
/knowzcode:work "…"
/knowzcode:explore "…"
```

KnowzCode skills are named `work`, `explore`, `fix`, … When another skill shares that name, Grok shows the qualified form `/knowzcode:work`. Type `/knowzcode` and pick from the menu.

## Vault resolution

1. `knowz` on PATH → `/knowz-cli`
2. Else Knowz MCP tools in the session (plugin MCP after `--trust` **and** OAuth via `/mcps` `i`, or a key header)
3. Else `/knowz-setup` — host steps in `plugins/knowz/skills/vault-access.md`

KnowzCode never requires Knowz. Missing vaults do not block `/knowzcode:work`.

## KnowzCode on Grok Build

`/knowzcode:setup` bootstraps `knowzcode/` through `npx knowzcode install` and writes `.grok/rules/knowzcode.md` so Grok loads the methodology as a project rule. It does **not** require `.cursor/rules`.

`work` is native Phase 2A by default. Relay to Claude Code or Codex is optional (`/knowzcode:relay`, or `work --relay=claude|codex`).

## Collisions with knowz-skills

If `grok plugin list` shows two `knowz` or two `knowzcode` entries, Grok may load the Claude `knowz-skills` copy (monoliths, Agent Teams). This package then looks installed but is not what the session runs.

```bash
grok plugin list --json
# uninstall the copy whose source contains knowz-skills
./scripts/install-grok.sh --replace-collisions
```

Claude Code plugins under `~/.claude/plugins/marketplaces/knowz-skills/` can also appear in `grok inspect` because Grok scans Claude plugin dirs. That is expected on a mixed Claude + Grok machine. Project `.grok/skills/` still outranks both. For a Grok-only machine, do not add `knowz-io/knowz-skills` as a marketplace.

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| Plugin installed, skills missing | New session, or `r` in the Plugins tab. Confirm `grok plugin list` and `[plugins] enabled`. |
| `grok mcp doctor knowz` → OAuth required | `/mcps` → **knowz** → `i`. Or install the CLI. |
| MCP tools missing after `--trust` | Plugin hooks/MCP stay off until trusted. Reinstall with `--trust`. |
| Wrong vaults / Claude monoliths | Collision — see above. Use this repo, not knowz-skills. |
| `grok plugin validate` at repo root → no plugin.json | Correct. The root is the marketplace index. Validate `plugins/knowz` and `plugins/knowzcode`. |
| Org refuses unpinned install | `grok plugin install knowz-io/cursor-knowz-plugin@<full-sha>#plugins/knowz --trust` |

## Validate

```bash
bash scripts/check-manifests.sh
grok plugin validate plugins/knowz
grok plugin validate plugins/knowzcode
```

## Official xAI catalog

[xai-org/plugin-marketplace#326](https://github.com/xai-org/plugin-marketplace/pull/326) points at **this** repo (`plugins/knowz`, `plugins/knowzcode`), not `knowz-io/knowz-skills`. After merge, `grok plugin install knowz --trust` also works from the official catalog.
