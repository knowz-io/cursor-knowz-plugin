# Knowz + KnowzCode for Grok Build, Grok Bot, and Cursor

Listed as **Knowz AI**. Two separately installable plugins — do not merge them.

**Grok Build** is the local `grok` coding agent. **Grok Bot** is the hosted chat product. Same plugins, different install:

| Host | How to install |
|------|----------------|
| **Grok Build** | `grok plugin marketplace add knowz-io/cursor-knowz-plugin` then `grok plugin install knowz --trust` and/or `knowzcode --trust` |
| **Grok Bot** | Plugins → search **Knowz** / **KnowzCode** → **Add** → **Authorize** (Knowz only) |
| **Cursor** | Customize → Plugins → same listing |

Full Grok Build notes: [docs/grok-build.md](./docs/grok-build.md). One-shot from a clone: `./scripts/install-grok.sh`.

## Install on Grok Build

```bash
grok plugin marketplace add knowz-io/cursor-knowz-plugin
grok plugin install knowz --trust
grok plugin install knowzcode --trust
npm i -g @knowzai/cli && knowz login    # optional; preferred for vault ops
```

`--trust` attaches Knowz MCP. Start a **new** Grok session, then `/knowz-status` and `/knowzcode:setup`.

Do not paste API keys in the Grok Build chat. Put a key in user-scope config if you skip OAuth:

```bash
grok mcp add --transport http knowz https://mcp.knowz.io/mcp --header "Authorization: Bearer <api-key>"
```

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

Same listing as Grok Bot (public listing waits on Cursor review).

1. Open **Customize** or **Settings → Plugins**.
2. Search **Knowz** and/or **KnowzCode**.
3. **Install** / **Add**. For **Knowz**, **Authorize** when prompted.

## Two plugins

| Plugin | Product name | What you get |
|--------|----------------|--------------|
| `knowz` | **Knowz** | Vaults via **CLI first** (`knowz` / `/knowz-cli`) then hosted MCP (`https://mcp.knowz.io/mcp`). Slim skills: ask, save, search, browse, amend, setup, status, flush, auto, cli |
| `knowzcode` | **KnowzCode** | No `mcp.json`. Slim TDD / quality-gate skills, a Cursor rule, and Grok-host process relay to Codex or Claude Code. Knowz MCP is **optional** and **never blocks** |

They complement each other. Each works alone. Install one or both — never as a single combined plugin.

This repo is **not** the Claude / Codex marketplace. Grok Build, Grok Bot, and Cursor team imports must use **this** GitHub repo (`knowz-io/cursor-knowz-plugin`), not `knowz-io/knowz-skills` (that package ships Claude monoliths, Agent Teams, and telemetry). KnowzCode here includes the Grok-host process relay ported from knowz-skills at SHA `35ff36297b6b98623efee48aa146c83cda58288a` — same contract, host-patched for Grok. Do not merge Knowz and KnowzCode.

## Which plugin?

| You want… | Install |
|-----------|---------|
| Persistent team memory — decisions, conventions, lessons | **Knowz** |
| Disciplined feature work — gates, TDD, session handoffs | **KnowzCode** |
| Knowledge-informed development | **Both** — optional complementarity |

## After install

**Knowz**

```text
/knowz-setup          # map vaults once CLI or MCP is up
/knowz-cli            # if `knowz` is on PATH
/knowz-ask "…"        # vault Q&A
/knowz-search "…"     # semantic search
/knowz-save "…"       # capture a durable insight
/knowz-status         # CLI / MCP + vault health
```

Do **not** run `/knowz register` on an existing Knowz account — that creates a **new** account. Sign in during Authorize instead.

**KnowzCode**

```text
/knowzcode:setup      # initialize the framework in a repo
/knowzcode:work "…"   # full TDD workflow with quality gates (native Phase 2A by default)
/knowzcode:relay "…"  # same workflow; Grok plans/reviews, Codex or Claude Code implements
/knowzcode:explore    # research first
/knowzcode:fix        # small localized change (relay skipped)
/knowzcode:regroup    # local handoff before clearing context
/knowzcode:continue   # resume from the latest handoff or relay state
/knowzcode:status     # project health plus relay host/target/detect
```

`work --relay=codex` or `work --relay=claude` names a target and is never reversed. `--relay=other` / `--relay=auto` means the complementary coding agent: the one ready CLI, or ask which implementer if both Claude and Codex are ready. Ordinary `work` stays native.

Relay runs on the **hosted Grok VM** when `claude` / `codex` are installed. Detection prepends `$HOME/.local/bin` and `/home/box/.local/bin` because `command -v` misses those paths. **Cursor cloud-agent VMs do not have those CLIs** — automatic selectors fall back to native Phase 2A; a named unavailable target stops with remediation. Never claim a cloud agent can run relay.

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

The repo root is a **marketplace index**, not a plugin. Each plugin lives under
`plugins/` and carries its own manifests.

```text
docs/grok-build.md                 # Grok Build install
scripts/install-grok.sh            # one-shot Grok Build install
.grok-plugin/marketplace.json      # index Grok reads
.cursor-plugin/marketplace.json    # index Cursor reads
plugins/knowz/                     # MCP + vault skills
  plugin.json                      # read first by `grok plugin validate`
  .grok-plugin/plugin.json         # Grok-native location
  .cursor-plugin/plugin.json       # Cursor
  .mcp.json / mcp.json             # Grok / Cursor MCP config
plugins/knowzcode/                 # TDD skills + rules/knowzcode.mdc
  plugin.json
  .grok-plugin/plugin.json
  .cursor-plugin/plugin.json
scripts/check-manifests.sh         # packaging guard
```

Grok resolves a plugin manifest in this order: `plugin.json`, then
`.grok-plugin/plugin.json`, then `.claude-plugin/plugin.json`. It **never** reads
`.cursor-plugin/`. Each plugin therefore ships a bare `plugin.json` alongside the
Grok and Cursor copies. Because the bare copy wins, all three must stay in sync —
`scripts/check-manifests.sh` enforces that.

## Validate the packaging

Validate each plugin separately. There are two plugins and two listings, so there
are two commands:

```bash
grok plugin validate plugins/knowz
grok plugin validate plugins/knowzcode
```

Both must print `Plugin manifest is valid.` with the matching `name` and `version`.

Running `grok plugin validate` from the repo root prints **"No plugin.json found"**.
That is correct: the root is the marketplace index. Adding a root `plugin.json`
would present Knowz and KnowzCode as one merged plugin — never do that.

`grok plugin validate` exits `0` even when it finds nothing, so check the message,
not the exit code. The guard script does that for you, along with checking that the
three manifests and both marketplace entries agree on name, displayName and version:

```bash
bash scripts/check-manifests.sh
```

If an installed copy reports `No plugin.json found`, it predates the manifests.
Refresh the marketplace cache and the installed plugins:

```bash
grok plugin marketplace update cursor-knowz-plugin
grok plugin update
```

## Support

- Publisher (listed as): Knowz AI
- Product: [https://knowz.io](https://knowz.io)
- Email: support@knowz.io
- Multiple accounts: [MULTI-ACCOUNT.md](./MULTI-ACCOUNT.md)
- Privacy: [https://knowz.io/privacy](https://knowz.io/privacy)

## License

MIT — see [LICENSE](./LICENSE). Copyright 2026 Knowz / knowz-io.
