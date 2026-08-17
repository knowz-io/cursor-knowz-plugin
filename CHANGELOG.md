# Changelog

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
