#!/usr/bin/env bash
# install.sh — installs wp-mnemon into a Claude config dir
#
# Usage:
#   bash install.sh                              # → ~/.claude (default)
#   CLAUDE_HOME=~/.some-other-dir bash install.sh # → custom config dir

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"

echo ""
echo "Installing wp-mnemon..."
echo ""

# Create directories if they don't exist
mkdir -p "$CLAUDE_HOME/agents"
mkdir -p "$CLAUDE_HOME/skills"
mkdir -p "$CLAUDE_HOME/agent-memory/wp-mnemon/plugins"

# Copy agent definition
cp "$SCRIPT_DIR/.claude/agents/wp-mnemon.md" "$CLAUDE_HOME/agents/wp-mnemon.md"
echo "  ✓ Agent installed"

# Copy skill (overwrite if exists)
rm -rf "$CLAUDE_HOME/skills/wp-mnemon"
cp -r "$SCRIPT_DIR/.claude/skills/wp-mnemon" "$CLAUDE_HOME/skills/wp-mnemon"
echo "  ✓ Skill installed"

# Make scripts executable
chmod +x "$CLAUDE_HOME/skills/wp-mnemon/scripts/"*.sh
echo "  ✓ Scripts ready"

# Create MEMORY.md index if it doesn't exist yet
MEMORY_FILE="$CLAUDE_HOME/agent-memory/wp-mnemon/MEMORY.md"
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
