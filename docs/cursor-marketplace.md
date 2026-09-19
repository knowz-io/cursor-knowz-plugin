# Cursor official marketplace — packaging + status

Publisher display name: **Knowz AI**  
Source repo: https://github.com/knowz-io/cursor-knowz-plugin  
Plugins (separate installs): **Knowz** (`knowz`, v0.1.2) and **KnowzCode** (`knowzcode`, v0.2.1)

## Live status (probed 2026-09-19 ~22:30 UTC)

| URL | HTTP | Result |
|-----|------|--------|
| https://cursor.com/marketplace/knowz | 200 | Soft 404 — title **Marketplace Plugin Not Found**, `robots: noindex` |
| https://cursor.com/marketplace/knowzcode | 200 | Soft 404 — same |
| https://cursor.com/marketplace | 200 | Public catalog of approved plugins (Adspirer, Slack, Granola, …) |

Grok Bot **Plugins** search can still resolve `knowz` / `knowzcode` (catalog ids seen in-product). That catalog presence is **not** the same as a public Cursor marketplace page.

Community (non-official): cursor.directory listings may exist; they are unrelated to Cursor review.

## Submission archaeology

- Submitted ~2026-08-16 via https://cursor.com/marketplace/publish from this repo (team recollection).
- Gmail search (rapidventure-io + hijab-org) for `marketplace-publishing@cursor.com` / Cursor marketplace confirmations after 2026-08-01: **no threads found**.
- No Cursor approval/rejection email on file in those inboxes.

## Packaging checklist (aligned to https://cursor.com/docs/reference/plugins)

- [x] Multi-plugin repo uses `.cursor-plugin/marketplace.json` at repo root
- [x] Each plugin has `.cursor-plugin/plugin.json` under `plugins/<name>/`
- [x] Names are unique kebab-case: `knowz`, `knowzcode`
- [x] Descriptions present; publisher **Knowz AI**
- [x] Logos committed (`assets/logo.png` + `logo.svg`); relative paths only
- [x] MIT `LICENSE` at repo + per plugin
- [x] Knowz MCP via `mcp.json` / `.mcp.json` → `https://mcp.knowz.io/mcp` (OAuth; **no secrets in repo**)
- [x] KnowzCode has **no** MCP (skills + rules only)
- [x] Skills use `SKILL.md` frontmatter; KnowzCode ships `.mdc` rules
- [x] `scripts/check-manifests.sh` + `grok plugin validate` both green on tip
- [x] README documents Cursor / Grok Bot / Grok Build install

## Intentional design (do not “fix” by merging)

1. **Two plugins, one repo** — Cursor docs allow `.cursor-plugin/marketplace.json` for multi-plugin repositories. Most *currently public* Cursor marketplace listings are single-plugin repos (e.g. Granola, Adspirer, Slack). Dual-plugin is correct for Knowz product split; call it out for reviewers.
2. **Grok dual-homing** — `.grok-plugin/` + bare `plugin.json` coexist so Grok Build validates. Cursor reads `.cursor-plugin/` only. Do not delete Grok manifests.
3. **xAI marketplace PR #326** — separate workstream; do not conflate with Cursor official review.

## Remaining blockers for public listing

1. **Cursor human review / publish pipeline** — pages still soft-404 after ~5 weeks; no email trail.
2. **Possible reviewer confusion** — dual-plugin marketplace repo vs common single-plugin pattern (packaging is valid per docs; may need a nudge).
3. **Resubmit decision** — if Cursor asks for a fresh submit, use https://cursor.com/marketplace/publish against tip of `main` after this packaging polish merges.

## Nudge email (DRAFT — do not send without Alex greenlight)

**To:** marketplace-publishing@cursor.com  
**Subject:** Status check — Knowz + KnowzCode marketplace submission (~2026-08-16)

```
Hi Cursor marketplace team,

Bro here from Knowz AI. We submitted two plugins for the official Cursor marketplace around 2026-08-16 via https://cursor.com/marketplace/publish:

- Repo: https://github.com/knowz-io/cursor-knowz-plugin
- Plugins: Knowz (knowz) and KnowzCode (knowzcode)
- Publisher display: Knowz AI

Public pages still show Marketplace Plugin Not Found:
- https://cursor.com/marketplace/knowz
- https://cursor.com/marketplace/knowzcode

Could you share review status, or let us know if you need a resubmit / packaging change? Happy to re-submit from current main if that helps.

Thanks,
Alex
Knowz AI
```
