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

## Requirements

- [Claude Code](https://claude.ai/code)
- Bash (macOS, Linux, or WSL on Windows)
- `curl` (for GitHub API access)

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
├── install.sh
├── uninstall.sh
├── README.md
└── .claude/
    ├── agents/
    │   └── agent-name.md
    └── skills/
        └── agent-name/
            ├── SKILL.md
            └── scripts/
```

---

## License

MIT
