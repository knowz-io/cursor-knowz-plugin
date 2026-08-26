---
name: knowz-cli
description: "Use the knowz CLI for vault operations instead of MCP — search, ask, save, amend, browse, attach. Use when knowz is on PATH, Grok MCP OAuth is pending, or the user runs /knowz-cli."
---

# /knowz-cli — CLI vault operations

Prefer this path whenever `knowz` is on PATH. It needs no MCP OAuth. Cloud commands use `knowz login`; local commands need no auth.

## Resolve the binary

```bash
if command -v knowz >/dev/null 2>&1; then
  KNOWZ="knowz"
  "$KNOWZ" --version
else
  echo "knowz CLI not installed"
  KNOWZ=""
fi
```

If missing: `npm i -g @knowzai/cli` (scoped). Do **not** install the unscoped `knowz` package. Then `knowz login` or `knowz login --sso`. Exit 3 from a cloud command means unauthenticated. Do not run `$KNOWZ --version` (or any `$KNOWZ …`) when the binary was not found.

Read [vault-access.md](../vault-access.md) for backend resolution and shell-safety. Never interpolate user text into double-quoted shell (`$()` / backticks still execute). Prefer argv, or `knowz knowledge create --file` for bodies.

This repo does not vendor the full CLI inventory. For flags, run `$KNOWZ <command> --help`. Default to `--json` when parsing.

## Map

| Intent | Command |
|--------|---------|
| Ask | `$KNOWZ ask --vault <id> --json -- <q>` |
| Search | `$KNOWZ search --vault <id> --json -- <q>` |
| Save | `$KNOWZ knowledge create --title <title> --file <path> --vault <id>` |
| Amend | `$KNOWZ knowledge amend <id> -- <delta>` |
| Get | `$KNOWZ knowledge get <id> --json` |
| Browse vaults | `$KNOWZ vault list --json` / `$KNOWZ vault contents <id> --json` |
| Whoami | `$KNOWZ whoami` |

Read `knowz-vaults.md` for routing. Confirm before writes. If a CLI write fails, queue to `knowz-pending.md` the same way as an MCP failure. If the CLI is absent, use the MCP tools via `/knowz-ask` / `/knowz-save` / `/knowz-setup` instead of inventing a third path.
