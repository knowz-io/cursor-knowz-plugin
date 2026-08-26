#!/usr/bin/env bash
# Guard the Grok / Cursor plugin packaging for this repo.
#
# Knowz and KnowzCode are, and stay, two separate plugins.
#
# grok 1.0.5 resolves a plugin manifest in this order (verified against the
# binary, see knowz-io/cursor-knowz-plugin#5):
#
#   <plugin>/plugin.json                 <- read first, wins over the others
#   <plugin>/.grok-plugin/plugin.json    <- Grok-native location
#   <plugin>/.claude-plugin/plugin.json  <- Claude fallback
#
# It never reads `.cursor-plugin/`. A plugin that ships only a Cursor manifest
# makes `grok plugin validate` print "No plugin.json found" and still exit 0,
# so the breakage is silent. Each plugin therefore carries a bare `plugin.json`
# plus `.grok-plugin/` for Grok and `.cursor-plugin/` for Cursor. Because grok
# prefers the bare copy, the three must agree or hosts disagree on what is
# installed.
#
# Run: bash scripts/check-manifests.sh
set -uo pipefail

cd "$(dirname "$0")/.."

PLUGINS=(knowz knowzcode)
MARKETPLACES=(.grok-plugin/marketplace.json .cursor-plugin/marketplace.json)
fail=0
plugin_fail=0
note() { printf '  %s\n' "$1"; }
bad() { printf '  FAIL: %s\n' "$1"; fail=1; plugin_fail=1; }

field() { python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get(sys.argv[2],""))' "$1" "$2"; }

# The repo root is the marketplace index, not a plugin. A root plugin.json would
# present Knowz and KnowzCode to every host as one merged plugin.
echo "== repo root is a marketplace, not a plugin"
for d in . .grok-plugin .claude-plugin .cursor-plugin; do
  [ -f "$d/plugin.json" ] && bad "$d/plugin.json exists at the repo root; that would merge the two plugins into one"
done
[ "$fail" -eq 0 ] && note "no root plugin.json; root ships marketplace.json only"

for p in "${PLUGINS[@]}"; do
  echo "== $p"
  plugin_fail=0
  root="plugins/$p"
  manifests=("$root/plugin.json" "$root/.grok-plugin/plugin.json" "$root/.cursor-plugin/plugin.json")

  for m in "${manifests[@]}"; do
    if [ ! -f "$m" ]; then bad "missing $m"; continue; fi
    python3 -c 'import json,sys; json.load(open(sys.argv[1]))' "$m" \
      || bad "$m is not valid JSON"
  done
  # Without readable manifests the comparisons below are meaningless.
  if [ "$plugin_fail" -ne 0 ]; then continue; fi

  # Identity must agree across all three manifests.
  for key in name displayName version description; do
    ref=$(field "${manifests[0]}" "$key")
    [ -n "$ref" ] || { bad "$root/plugin.json has empty '$key'"; continue; }
    for m in "${manifests[@]:1}"; do
      got=$(field "$m" "$key")
      [ "$got" = "$ref" ] || bad "$key differs: $m has '$got', expected '$ref'"
    done
  done

  # The plugin's own name must match its directory: no accidental merge.
  got=$(field "$root/plugin.json" name)
  [ "$got" = "$p" ] || bad "$root/plugin.json name is '$got', expected '$p'"

  # Paths a manifest points at must exist, or the host silently drops the
  # component: no logo on the marketplace card, no MCP server after install.
  for m in "${manifests[@]}"; do
    for key in logo mcpServers; do
      target=$(field "$m" "$key")
      case "$target" in
        ''|'{'*) continue ;;  # absent, or an inline object rather than a path
      esac
      [ -f "$root/${target#./}" ] || bad "$m points $key at '$target' but $root/${target#./} does not exist"
    done
  done

  # Marketplace entry must exist for this plugin at the same version.
  for mk in "${MARKETPLACES[@]}"; do
    python3 - "$mk" "$p" "$(field "$root/plugin.json" version)" <<'PY' || bad "$mk disagrees with plugins/$p"
import json, sys
mk, name, version = sys.argv[1], sys.argv[2], sys.argv[3]
entries = json.load(open(mk))["plugins"]
hit = [e for e in entries if e.get("name") == name]
if len(hit) != 1:
    print(f"  FAIL: {mk} has {len(hit)} entries named '{name}', expected exactly 1")
    raise SystemExit(1)
if hit[0].get("version") != version:
    print(f"  FAIL: {mk} lists {name} at {hit[0].get('version')}, manifest says {version}")
    raise SystemExit(1)
if hit[0].get("source") != f"./plugins/{name}":
    print(f"  FAIL: {mk} points {name} at {hit[0].get('source')}, expected ./plugins/{name}")
    raise SystemExit(1)
PY
  done
  [ "$plugin_fail" -eq 0 ] && note "three manifests agree; marketplace entries match"
done

# Two listings, never one merged plugin.
for mk in "${MARKETPLACES[@]}"; do
  n=$(python3 -c 'import json,sys; print(len(json.load(open(sys.argv[1]))["plugins"]))' "$mk")
  [ "$n" = "2" ] || bad "$mk lists $n plugins, expected exactly 2 (knowz + knowzcode)"
done

echo "== Grok Build packaging extras"
[ -f docs/grok-build.md ] || bad "missing docs/grok-build.md"
[ -x scripts/install-grok.sh ] || bad "scripts/install-grok.sh is not executable"
[ -f plugins/knowz/.mcp.json ] || bad "missing plugins/knowz/.mcp.json (Grok plugin MCP)"
[ -f plugins/knowz/mcp.json ] || bad "missing plugins/knowz/mcp.json (Cursor MCP)"
python3 - <<'PY' || bad "plugins/knowz .mcp.json and mcp.json differ"
import json, pathlib
a = json.loads(pathlib.Path("plugins/knowz/.mcp.json").read_text())
b = json.loads(pathlib.Path("plugins/knowz/mcp.json").read_text())
if a != b:
    raise SystemExit(1)
PY
[ -f plugins/knowzcode/rules/knowzcode.md ] || bad "missing plugins/knowzcode/rules/knowzcode.md (Grok project rule)"
[ -f plugins/knowzcode/rules/knowzcode.mdc ] || bad "missing plugins/knowzcode/rules/knowzcode.mdc (Cursor rule)"

if command -v grok >/dev/null 2>&1; then
  echo "== grok plugin validate"
  for p in "${PLUGINS[@]}"; do
    out=$(grok plugin validate "plugins/$p" 2>&1)
    printf '%s\n' "$out" | sed 's/^/  /'
    # validate exits 0 even when it finds nothing, so match on the message.
    case "$out" in
      *"Plugin manifest is valid."*) ;;
      *) bad "grok plugin validate plugins/$p did not report a valid manifest" ;;
    esac
  done
else
  echo "== grok not installed; skipped grok plugin validate"
fi

[ "$fail" -eq 0 ] && echo "OK: knowz and knowzcode are packaged as two valid, separate plugins."
exit "$fail"
