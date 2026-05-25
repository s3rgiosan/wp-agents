#!/usr/bin/env bash
# uninstall.sh — removes the wp-mnemon subagent from a Claude config dir
# Your plugin memory is preserved unless you pass --purge-memory
#
# This does NOT remove the wp-mnemon skill (managed separately by
# wp-skills/wp-mnemon). To remove that too, run its uninstall.sh.
#
# Usage:
#   bash uninstall.sh                                          # → ~/.claude
#   bash uninstall.sh --purge-memory                           # also delete memory
#   CLAUDE_CONFIG_DIR=~/.some-other-dir bash uninstall.sh             # custom config dir

set -euo pipefail

CLAUDE_CONFIG_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
PURGE_MEMORY=false

for arg in "$@"; do
  if [ "$arg" = "--purge-memory" ]; then
    PURGE_MEMORY=true
  fi
done

echo ""
echo "Uninstalling wp-mnemon subagent..."
echo ""

rm -f "$CLAUDE_CONFIG_DIR/agents/wp-mnemon.md"
echo "  ✓ Agent removed"

if [ "$PURGE_MEMORY" = true ]; then
  rm -rf "$CLAUDE_CONFIG_DIR/agent-memory/wp-mnemon"
  echo "  ✓ Memory purged"
else
  echo "  ✓ Memory preserved at $CLAUDE_CONFIG_DIR/agent-memory/wp-mnemon"
  echo "    (run with --purge-memory to delete it)"
fi

echo ""
echo "Note: the wp-mnemon skill at $CLAUDE_CONFIG_DIR/skills/wp-mnemon was NOT removed."
echo "To remove it too, run wp-skills/wp-mnemon/uninstall.sh."
echo ""
echo "Done."
echo ""
