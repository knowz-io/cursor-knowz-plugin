# KnowzCode

Knowz AI plugin for **Grok Bot** and **Cursor Marketplace**. Product name: **KnowzCode**.

Structured TDD development with quality gates, local handoffs, a Cursor rule, and Grok-host process relay to Codex or Claude Code. This plugin **does not** ship `mcp.json`. Knowz vaults are a **separate** optional install and **never block** this workflow.

Process relay is ported from the Codex plugin slim surfaces in [knowz-io/knowz-skills](https://github.com/knowz-io/knowz-skills) at SHA `35ff36297b6b98623efee48aa146c83cda58288a` and host-patched for Grok Bot / Cursor (`RELAY_HOST = grok`; never `claude`). Same contract: Grok plans, specifies, reviews, and finalizes; Claude Code or Codex owns Phase 2A and bounded fix rounds. Native Phase 2A remains the default.

## Install

1. Grok Bot **Plugins** → search **KnowzCode** → **Add**.
2. Same listing in Cursor Marketplace (**Customize** → **Plugins**).

No Authorize step is required for KnowzCode itself. If you also want team memory, add the **Knowz** plugin separately (search **Knowz** → **Add** → **Authorize**).

## Skills

`work`, `relay`, `explore`, `fix`, `setup`, `status`, `regroup`, `continue`, `start-work`, `regroup-trigger`

`work` is native Phase 2A by default. Relay starts from `relay`, `work --relay=…`, unambiguous delegation language, or `relay:` in `knowzcode/knowzcode_orchestration.md`. Selectors are `none|auto|other|claude|codex`. On Grok, `auto`/`other` means the complementary coding agent: the one ready CLI, or ask if both Claude and Codex are ready. No preferred-only lock.

Detection prepends `$HOME/.local/bin` and `/home/box/.local/bin` (hosted Grok VM; `command -v` alone fails). Cursor cloud-agent VMs cannot run those CLIs; automatic selectors fall back native and named selectors stop. Light / `fix` skip relay visibly. `start-work` may pass `--relay=claude` or `--relay=codex` only.

## Rule

`rules/knowzcode.mdc` — always-on TDD / quality-gate guidance.

## License

MIT — publisher **Knowz AI**. Homepage: [https://knowz.io](https://knowz.io)
