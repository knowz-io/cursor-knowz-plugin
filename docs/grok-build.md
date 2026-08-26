# Grok Build

This repo is the Knowz AI marketplace for **Grok Build**, **Grok Bot**, and **Cursor**. Two plugins, never merged: **Knowz** (vaults) and **KnowzCode** (TDD).

Grok Build is the local coding agent (`grok` CLI / TUI). It is **not** Grok Bot (the hosted chat product). Bot uses Authorize in a Plugins UI. Build uses `grok plugin …` and can use the knowz CLI.

## Install

```bash
grok plugin marketplace add knowz-io/cursor-knowz-plugin
grok plugin install knowz --trust
grok plugin install knowzcode --trust
```

`--trust` attaches Knowz MCP from `plugins/knowz/.mcp.json`. Start a **new** Grok session.

Optional, preferred for vault ops (no MCP OAuth):

```bash
npm i -g @knowzai/cli
knowz login          # or: knowz login --sso
```

From a clone of this repo:

```bash
./scripts/install-grok.sh
```

Local path or git URL also work:

```bash
grok plugin marketplace add /path/to/cursor-knowz-plugin
grok plugin marketplace add https://github.com/knowz-io/cursor-knowz-plugin.git
```

Pin the marketplace in `~/.grok/config.toml` or a project `.grok/config.toml`:

```toml
[[marketplace.sources]]
name = "cursor-knowz-plugin"
git = "https://github.com/knowz-io/cursor-knowz-plugin.git"
```

## After install

```text
/knowz-status
/knowz-setup          # write knowz-vaults.md once a backend is up
/knowz-cli            # if knowz is on PATH
/knowzcode:setup      # skip if the repo already has knowzcode/
/knowzcode:work "…"
/knowzcode:explore "…"
```

Do **not** run `/knowz register` on an existing Knowz account.

## Vault resolution

1. `knowz` on PATH → `/knowz-cli`
2. Else Knowz MCP tools in the session (plugin MCP after `--trust`; first call may OAuth)
3. Else `/knowz-setup` — Grok Build steps in `plugins/knowz/skills/vault-access.md`

KnowzCode never requires Knowz. Missing vaults do not block `/knowzcode:work`.

## Validate

```bash
bash scripts/check-manifests.sh
grok plugin validate plugins/knowz
grok plugin validate plugins/knowzcode
```

The repo root is the marketplace index. `grok plugin validate` at the root correctly says there is no root `plugin.json`.

## Official xAI catalog

[xai-org/plugin-marketplace#326](https://github.com/xai-org/plugin-marketplace/pull/326) points at **this** repo (`plugins/knowz`, `plugins/knowzcode`), not `knowz-io/knowz-skills`. After merge, `grok plugin install knowz --trust` works from the official catalog as well.
