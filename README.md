# wp-agents

> Claude Code agents for WordPress developers.

A collection of Claude Code subagents and skills that bring persistent, context-aware WordPress knowledge directly into your development sessions — no more re-explaining plugin architectures, hook signatures, or data structures every time you open a new chat.

---

## Agents

### [wp-mnemon](./wp-mnemon)

> *Mnemon (μνήμων) — ancient Greek for "one who remembers".*

Deep-analyzes WordPress plugins and writes permanent documentation into Claude's global memory. Once a plugin is analyzed, any Claude Code session can answer questions about its architecture, execution flows, hook chains, data lifecycle, extensibility patterns, and more — without ever touching the codebase again.

**Works with:**
- Local plugins (`/wp-content/plugins/my-plugin`)
- Public GitHub repos (`https://github.com/org/plugin`)
- Private GitHub repos (via personal access token)

**Analyzes:**
- Full plugin architecture — class hierarchies, design patterns, namespaces, autoloading
- Bootstrap & initialization flow — what loads when and what triggers what
- Execution flows — complete trigger-to-output chains for every major feature
- All `add_action` / `add_filter` registrations with context on what callbacks do
- All `do_action` / `apply_filters` extension points with parameters and use cases
- Custom post types, taxonomies, meta keys, options, and their lifecycle
- Custom database table schemas and CRUD operations
- REST API routes with request/response shapes
- Admin & frontend UI mapping — pages, metaboxes, shortcode output, block rendering
- Gutenberg blocks, WP-CLI commands, cron jobs, enqueued assets
- Third-party integration points (WooCommerce, ACF, WPML, Elementor...)
- Extensibility patterns with 3-5 practical code examples

**[→ Install wp-mnemon](./wp-mnemon/README.md)**

---

## Install via Claude Code plugin marketplace (recommended)

`wp-agents` is a Claude Code plugin marketplace. Add it once, then install agents individually:

```
/plugin marketplace add s3rgiosan/wp-agents
/plugin install wp-mnemon@wp-agents
```

The `wp-mnemon` plugin declares a cross-marketplace dependency on the `wp-mnemon` skill in [`wp-skills`](https://github.com/s3rgiosan/wp-skills). Claude Code installs both pieces automatically — no second `marketplace add` needed.

Or wire it into `settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "wp-agents": { "source": { "source": "github", "repo": "s3rgiosan/wp-agents" } },
    "wp-skills": { "source": { "source": "github", "repo": "s3rgiosan/wp-skills" } }
  },
  "enabledPlugins": {
    "wp-mnemon@wp-agents": true,
    "wp-mnemon@wp-skills": true
  }
}
```

---

## Install via shell script (fallback)

For older Claude Code builds or scripted environments. Each agent's directory ships an `install.sh` that auto-fetches its skill dependency. See the per-agent README.

---

## Requirements

- [Claude Code](https://claude.ai/code) — v2.1.110+ for plugin marketplace support.
- Bash (macOS, Linux, or WSL on Windows) for fallback `install.sh`.
- `curl` (for GitHub API access during plugin analysis).

---

## Philosophy

WordPress projects accumulate plugins fast. Understanding how each one works — what hooks it exposes, what data it stores, how to safely extend it — requires hours of code reading that evaporates the moment you close the tab.

These agents exist to fix that. Analyze once, remember forever. Every agent writes structured documentation into Claude's user-level memory (`~/.claude/agent-memory/`), making it available across every project and every session automatically.

---

## Contributing

New agent ideas are welcome. If you build a Claude Code agent for WordPress development — theme analysis, block documentation, query optimization, deployment workflows — feel free to open a PR.

Each agent lives in its own directory and follows the same structure:

```
agent-name/
├── .claude-plugin/
│   └── plugin.json              ← plugin manifest (declares dependencies)
├── agents/
│   └── agent-name.md
├── install.sh                   ← fallback installer
├── uninstall.sh
└── README.md
```

Skills consumed by the agent live in [`wp-skills`](https://github.com/s3rgiosan/wp-skills) and are declared in `plugin.json` via `dependencies`.

---

## License

MIT
