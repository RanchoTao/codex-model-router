#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_SRC="$ROOT/.agents/skills/codex-model-router"
SKILL_DST="$HOME/.agents/skills/codex-model-router"
AGENT_SRC="$ROOT/.codex/agents"
AGENT_DST="$HOME/.codex/agents"
AGENTS_MD="$HOME/.codex/AGENTS.md"
SNIPPET="$ROOT/examples/AGENTS-snippet.md"

mkdir -p "$(dirname "$SKILL_DST")" "$AGENT_DST" "$(dirname "$AGENTS_MD")"

if [ -d "$SKILL_DST" ]; then
  rm -rf "$SKILL_DST"
fi
cp -R "$SKILL_SRC" "$SKILL_DST"

for f in "$AGENT_SRC"/cmr-*.toml; do
  cp "$f" "$AGENT_DST/"
done

touch "$AGENTS_MD"

if ! grep -q '<!-- codex-model-router:start -->' "$AGENTS_MD"; then
  cp "$AGENTS_MD" "$AGENTS_MD.cmr-backup" 2>/dev/null || true
  {
    printf '\n'
    cat "$SNIPPET"
    printf '\n'
  } >> "$AGENTS_MD"
  echo "Added routing block to $AGENTS_MD"
else
  echo "Routing block already exists in $AGENTS_MD"
fi

echo "Installed codex-model-router."
echo "Skill:  $SKILL_DST"
echo "Agents: $AGENT_DST"
echo "Restart Codex if the skill is not detected immediately."
echo "Optional: merge examples/luna-root-config.toml into ~/.codex/config.toml for a cheap parent orchestrator."
