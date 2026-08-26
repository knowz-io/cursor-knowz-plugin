---
name: setup
description: "Initialize KnowzCode in a repository for Grok Build, Grok Bot, and Cursor: framework files, Grok .grok/rules, and project personalization. Use when asked to set up or bootstrap KnowzCode, or runs /knowzcode:setup. Knowz is optional and never blocks setup."
---

# /knowzcode:setup — Initialize KnowzCode

Initialize the KnowzCode framework in the current project.

**Grok Build** (local `grok` CLI): skills come from this plugin after `grok plugin install knowzcode --trust`. Bootstrap framework files with `npx --yes knowzcode install --target "{absolute-repository-root}" --force` — do not require `.cursor/rules`. Copy this plugin's `rules/knowzcode.md` to `{repo}/.grok/rules/knowzcode.md` when that file is missing. See `docs/grok-build.md` in the marketplace repo.

Grok Bot Plugins and Cursor Marketplace share a catalog — do not treat this as Cursor-IDE-only.

Knowz MCP is **optional**. Never block setup, personalization, or success reporting on missing Knowz tools.

## Instructions

1. Resolve the repository root as an absolute path and check whether `knowzcode/` already exists there.
   - If it does, ask whether to merge, refresh, or stop.
2. Bootstrap through the published CLI rather than assuming this skill can find a plugin-relative framework directory.
   Detect Grok Build with `command -v grok`.
   - Fresh repository on **Grok Build**: `npx --yes knowzcode install --target "{absolute-repository-root}" --force` (no `--platforms cursor`).
   - Fresh repository on **Cursor / Grok Bot**: `npx --yes knowzcode install --target "{absolute-repository-root}" --platforms cursor --force`
   - Approved refresh: `npx --yes knowzcode upgrade --target "{absolute-repository-root}" --force`
   - Adapter-only merge on Cursor: `npx --yes knowzcode add-platforms --target "{absolute-repository-root}" --platforms cursor --force`
   Never substitute the current home/global skill directory for the repository target. Verify the CLI exits successfully and that `knowzcode/knowzcode_loop.md` exists before personalization.
3. Preserve user-authored project files. The CLI's ownership marker and manifest control which Cursor surfaces it may update (including `.cursor/rules/knowzcode.mdc`). On Grok Build, do not fail if `.cursor/rules` is absent.
4. Detect the project stack and write the Stack table in `knowzcode/knowzcode_project.md` with the concrete language, framework, test runner, and build details. Probe for `package.json` (Node/TS), `pyproject.toml` / `requirements.txt` (Python), `*.csproj` / `*.sln` (.NET), `go.mod` (Go), `Cargo.toml` (Rust), `Gemfile` (Ruby). Leave table cells empty if detection fails — do not write `[Detected]` placeholders.
5. Run three personalization gates. Each is skippable; when declined, write `Not configured during init — edit this file or re-run /knowzcode:setup to fill.` into the relevant section instead of leaving the template's bracketed placeholders.
   - **Gate A (`knowzcode_project.md`):** Ask for (1) project name + one-sentence goal, (2) core problem, (3) architecture style. Rewrite the `## Goal` and `## Architecture` sections with the answers. Leave the Stack table alone — step 4 handles it.
   - **Gate B (`knowzcode_architecture.md`):** Do not generate a diagram. The file ships with an empty Mermaid stub — leave it and tell the user "Architecture will be populated on first /knowzcode:work or when you ask for a sketch."
   - **Gate C (`user_preferences.md`):** Ask for (1) testing framework + coverage target, (2) code style / formatter, (3) top-3 quality priorities ranked, (4) non-negotiable project conventions (optional). Rewrite the file with real answers; strip the `*Examples:*` blocks from the filled copy; update `Last Updated` to the current ISO timestamp.
6. Host-specific always-on rule:
   - **Grok Build:** if `{repo}/.grok/rules/knowzcode.md` is missing, copy this plugin's `../../rules/knowzcode.md` there (create `.grok/rules/` as needed). Grok loads `*.md` from `.grok/rules/` automatically.
   - **Cursor / Grok Bot:** confirm `.cursor/rules/knowzcode.mdc` exists after a Cursor-platform install. This plugin also ships `rules/knowzcode.mdc` so those hosts get the methodology without a local copy.
7. If the user also wants team memory, mention the **Knowz** plugin as a **separate** install (do not merge it into this workflow). Grok Build: `grok plugin install knowz --trust`, then CLI (`knowz login`) or `/mcps` → **knowz** → `i`. Grok Bot / Cursor: search **Knowz** → **Add** → **Authorize**. Do not run `/knowz register` on an existing account. Do not paste API keys in Grok Bot chat.
8. End by suggesting `/knowzcode:work`, `/knowzcode:explore`, and `/knowzcode:fix`. Setup succeeds even when Knowz MCP is absent.
