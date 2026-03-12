#!/usr/bin/env bash
# install.sh — installs wp-mnemon into Claude Code global config

set -euo pipefail

CLAUDE_DIR="${HOME}/.claude"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "Installing wp-mnemon..."
echo ""

# Create directories if they don't exist
mkdir -p "$CLAUDE_DIR/agents"
mkdir -p "$CLAUDE_DIR/skills"
mkdir -p "$CLAUDE_DIR/agent-memory/wp-mnemon/plugins"

# Copy agent definition
cp "$SCRIPT_DIR/.claude/agents/wp-mnemon.md" "$CLAUDE_DIR/agents/wp-mnemon.md"
echo "  ✓ Agent installed"

# Copy skill (overwrite if exists)
rm -rf "$CLAUDE_DIR/skills/wp-mnemon"
cp -r "$SCRIPT_DIR/.claude/skills/wp-mnemon" "$CLAUDE_DIR/skills/wp-mnemon"
echo "  ✓ Skill installed"

# Make scripts executable
chmod +x "$CLAUDE_DIR/skills/wp-mnemon/scripts/"*.sh
echo "  ✓ Scripts ready"

# Create MEMORY.md index if it doesn't exist yet
MEMORY_FILE="$CLAUDE_DIR/agent-memory/wp-mnemon/MEMORY.md"
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
