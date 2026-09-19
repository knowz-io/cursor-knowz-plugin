# Changelog

## Unreleased

### Cursor Marketplace packaging polish (no version bump)

- Add PNG logos (`assets/logo.png`, `assets/icon.png`) for marketplace cards; keep SVG
- Point marketplace + plugin manifests at `assets/logo.png`
- Declare explicit `skills` / `rules` paths in plugin manifests (Adspirer-style)
- Add `docs/cursor-marketplace.md` reviewer checklist + live status notes

## 0.1.2 / 0.2.1

Grok **Build** (local `grok` CLI) is a first-class host alongside Grok Bot and Cursor.

- Knowz **0.1.2**: CLI-first vault access (`skills/vault-access.md`, `/knowz-cli`); Grok Build install (`grok plugin marketplace add knowz-io/cursor-knowz-plugin`, `grok plugin install knowz-io/cursor-knowz-plugin#plugins/knowz --trust`); MCP OAuth via `/mcps` then `i` (doctor `OAuth authorization required` until then); `docs/grok-build.md` and `scripts/install-grok.sh` (`--cli`, `--replace-collisions`, GitHub fallback). Grok Bot Authorize path unchanged. Do not merge with KnowzCode. Do not add `knowz-io/knowz-skills` as a Grok marketplace.
- KnowzCode **0.2.1**: same Grok Build install; optional vault via CLI then MCP; never blocks TDD. Setup uses `npx knowzcode install` and adds `--platforms cursor` only when a Cursor surface applies (not merely because `grok` is on PATH); copies `rules/knowzcode.md` to `.grok/rules/`. Slash form `/knowzcode:work` when `work` collides.
- Review follow-up (PR #7 Copilot): `--replace-collisions` uninstalls by `repo_key` and fails closed (never a bare `uninstall knowz` when duplicates exist); `--knowz-only` / `--knowzcode-only` gate the collision pass; `--cli` without npm exits nonzero; vault resolver has an explicit `neither`; CLI/MCP write failures both queue; shell-safety + `--file` for creates; Grok rule uses the classifier contract.

## 0.1.1 / 0.2.0 packaging

Make `grok plugin validate` find a real manifest for each plugin (#5). Knowz and
KnowzCode stay two separate plugins.

- Add a bare `plugins/knowz/plugin.json` and `plugins/knowzcode/plugin.json`. Grok
  resolves `plugin.json` before `.grok-plugin/plugin.json` before
  `.claude-plugin/plugin.json`, and never reads `.cursor-plugin/`
- Add `scripts/check-manifests.sh`: asserts each plugin's three manifests and both
  marketplace entries agree on name, displayName and version; that referenced
  `logo` / `mcpServers` paths exist; that the catalogs list exactly two plugins;
  that the repo root has no `plugin.json`; and that `grok plugin validate` reports
  a valid manifest for each plugin. `validate` exits 0 even when it finds nothing,
  so the script matches on the message rather than the exit code
- Document the exact validate commands, the manifest search order, and why running
  `grok plugin validate` at the repo root correctly says "No plugin.json found"

No version bump for either plugin: the manifests added in #4 already validate, and
xai-org/plugin-marketplace#326 pins those versions alongside the commit SHA.

## 0.2.0

Grok-host KnowzCode process relay, ported from knowz-io/knowz-skills at SHA `35ff36297b6b98623efee48aa146c83cda58288a`.

- Copy shape is the Codex plugin slim surfaces (`plugins/knowzcode/skills/relay/SKILL.md` and `plugins/knowzcode/skills/work/references/relay-execution.md`), host-patched for Grok — not the Claude 40 KB monolith
- Add `relay` skill (`RELAY_HOST = grok`; never treat Grok as `RELAY_HOST=claude`) and both Claude/Codex exec adapters, iron rule, schema-2 state, review loop
- `work` can run native Phase 2A (default) or Tier 3 relay via `--relay=`, natural-language delegation, `relay:` config, or the `relay` entry default
- `auto`/`other` on Grok means the complementary coding agent (no preferred-only lock): the one ready CLI, ask if both Claude and Codex are ready (then persist via `--relay=claude|codex`), else the named-vs-automatic fallback matrix
- Detection prepends `$HOME/.local/bin` and `/home/box/.local/bin` (Grok VM `command -v` misses those). Cursor cloud-agent VMs cannot run relay
- `start-work` passes `--relay=claude` or `--relay=codex` through; it does not invent `--relay=other`
- `continue` and `status` understand schema-2 and legacy schema-1 relay state
- KnowzCode plugin version 0.2.0. No `mcp.json`, no Agent Teams, no relay-runner agent, no telemetry, no Copilot `x-api-key`

## 0.1.1

Review-ready polish for official Cursor / Grok Bot marketplace submission.

- Keep Knowz and KnowzCode as two separately installable plugins
- Publisher / author display name: Knowz AI
- Drop dead `status.knowz.io` link
- Remove Claude / Codex leftover install paths from skills and the Cursor rule
- Remove `..` links from skill docs (manifest-safe relative paths only)
- Per-plugin READMEs so each package stands alone

## 0.1.0

Initial slim Cursor / Grok Bot marketplace package.
