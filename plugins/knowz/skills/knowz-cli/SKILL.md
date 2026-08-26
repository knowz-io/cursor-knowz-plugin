---
name: knowz-cli
description: "Use the knowz CLI for vault operations instead of MCP — search, ask, save, amend, browse, attach. Use when knowz is on PATH, Grok MCP OAuth is pending, or the user runs /knowz-cli."
---

# /knowz-cli — CLI vault operations

Prefer this path whenever `knowz` is on PATH. It needs no MCP OAuth. Cloud commands use `knowz login`; local commands need no auth.

## Resolve the binary

```bash
if command -v knowz >/dev/null 2>&1; then KNOWZ="knowz"
else echo "knowz CLI not installed"; fi
$KNOWZ --version
```

If missing: `npm i -g @knowzai/cli` (scoped). Do **not** install the unscoped `knowz` package. Then `knowz login` or `knowz login --sso`. Exit 3 from a cloud command means unauthenticated.

This repo does not vendor the full CLI inventory. For flags, run `$KNOWZ <command> --help`. Default to `--json` when parsing.

## Map

| Intent | Command |
|--------|---------|
| Ask | `$KNOWZ ask "<q>" --vault <id> --json` |
| Search | `$KNOWZ search "<q>" --vault <id> --json` |
| Save | `$KNOWZ knowledge create "<title>" --content "<text>" --vault <id>` |
| Amend | `$KNOWZ knowledge amend <id> "<delta>"` |
| Get | `$KNOWZ knowledge get <id> --json` |
| Browse vaults | `$KNOWZ vault list --json` / `$KNOWZ vault contents <id> --json` |
| Whoami | `$KNOWZ whoami` |

Read `knowz-vaults.md` for routing. Confirm before writes. If the CLI is absent, use the MCP tools via `/knowz-ask` / `/knowz-save` / `/knowz-setup` instead of inventing a third path.
