#!/usr/bin/env bash
# install.sh — installs the wp-mnemon subagent into a Claude config dir
#
# The subagent depends on the wp-mnemon skill (from
# https://github.com/s3rgiosan/wp-skills). If it's missing from the target
# Claude config dir, this installer will offer to fetch and install it for
# you. Pass --yes for non-interactive runs, or --no-skill-install to manage
# the skill yourself.
#
# Usage:
#   bash install.sh                                # → ~/.claude (default), prompts if skill missing
#   bash install.sh --yes                          # auto-fetch skill if missing (CI)
#   bash install.sh --no-skill-install             # skip auto-fetch; error if skill missing
#   CLAUDE_CONFIG_DIR=~/.some-other-dir bash install.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
WP_SKILLS_REPO="https://github.com/s3rgiosan/wp-skills.git"

AUTO_YES=false
NO_SKILL_INSTALL=false
for arg in "$@"; do
  case "$arg" in
    -y|--yes) AUTO_YES=true ;;
    --no-skill-install) NO_SKILL_INSTALL=true ;;
    -h|--help)
      sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
  esac
done

echo ""
echo "Installing wp-mnemon subagent..."
echo ""

# Pre-flight: ensure the wp-mnemon skill is installed.
SKILL_PATH="$CLAUDE_CONFIG_DIR/skills/wp-mnemon"
if [ ! -d "$SKILL_PATH" ]; then
  echo "  ⚠ wp-mnemon skill not found at $SKILL_PATH"

  # Decide whether to auto-install:
  # - opted out via flag → no
  # - git not installed → no
  # - not interactive and --yes not passed → no
  if [ "$NO_SKILL_INSTALL" = true ] \
     || ! command -v git >/dev/null 2>&1 \
     || { [ "$AUTO_YES" = false ] && [ ! -t 0 ]; }; then
    echo ""
    echo "    Install the skill manually first:"
    echo ""
    echo "      git clone $WP_SKILLS_REPO"
    echo "      cd wp-skills/wp-mnemon && CLAUDE_CONFIG_DIR=$CLAUDE_CONFIG_DIR bash install.sh"
    echo ""
    if [ "$NO_SKILL_INSTALL" = true ]; then
      echo "    (--no-skill-install passed — skipping auto-install.)"
    elif ! command -v git >/dev/null 2>&1; then
      echo "    (git is not on PATH — auto-install unavailable.)"
    elif [ ! -t 0 ] && [ "$AUTO_YES" = false ]; then
      echo "    (Non-interactive shell — re-run with --yes to auto-install.)"
    fi
    echo ""
    exit 1
  fi

  # Prompt unless --yes was passed.
  if [ "$AUTO_YES" = false ]; then
    read -r -p "  Install it now from github.com/s3rgiosan/wp-skills? [Y/n] " ans
    case "${ans:-Y}" in
      [Nn]*)
        echo "  Aborted. Install the skill manually and re-run."
        exit 1
        ;;
    esac
  fi

  TMP_SKILLS="$(mktemp -d)"
  trap 'rm -rf "$TMP_SKILLS"' EXIT
  echo "  → Cloning $WP_SKILLS_REPO (shallow) into $TMP_SKILLS"
  git clone --depth 1 "$WP_SKILLS_REPO" "$TMP_SKILLS" >/dev/null 2>&1
  echo "  → Running wp-skills/wp-mnemon/install.sh"
  CLAUDE_CONFIG_DIR="$CLAUDE_CONFIG_DIR" bash "$TMP_SKILLS/wp-mnemon/install.sh"
fi
echo "  ✓ Skill dependency satisfied → $SKILL_PATH"

# Create directories if they don't exist
mkdir -p "$CLAUDE_CONFIG_DIR/agents"
mkdir -p "$CLAUDE_CONFIG_DIR/agent-memory/wp-mnemon/plugins"

# Copy agent definition
cp "$SCRIPT_DIR/.claude/agents/wp-mnemon.md" "$CLAUDE_CONFIG_DIR/agents/wp-mnemon.md"
echo "  ✓ Agent installed → $CLAUDE_CONFIG_DIR/agents/wp-mnemon.md"

# Create MEMORY.md index if it doesn't exist yet
MEMORY_FILE="$CLAUDE_CONFIG_DIR/agent-memory/wp-mnemon/MEMORY.md"
if [ ! -f "$MEMORY_FILE" ]; then
  cat > "$MEMORY_FILE" << 'EOF'
# wp-mnemon — Plugin Knowledge Base

## Analyzed Plugins
| Plugin | Slug | Version | Date |
|---|---|---|---|

## Cross-Plugin Patterns Observed
_Nothing yet. Analyze a plugin to get started._
EOF
  echo "  ✓ Memory index created"
else
  echo "  ✓ Memory index already exists, skipping"
fi

echo ""
echo "Done! wp-mnemon is ready in Claude Code."
echo ""
echo "Try it:"
echo "  \"Analyze the WordPress plugin at /path/to/plugin\""
echo "  \"Analyze https://github.com/org/plugin-repo\""
echo ""
