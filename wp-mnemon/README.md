# wp-mnemon

> *Mnemon (μνήμων) — ancient Greek for "one who remembers". A keeper of knowledge.*

Part of [wp-agents](../README.md) — Claude Code agents for WordPress developers.

A Claude Code subagent that deeply analyzes WordPress plugins and writes permanent
documentation into Claude's global memory, making plugin knowledge available in
every future session without re-reading code.

---

## Installation

Clone the repo and run the install script from the `wp-mnemon` directory:

```bash
git clone https://github.com/your-username/wp-agents.git
cd wp-agents/wp-mnemon
bash install.sh
```

To uninstall (keeps your plugin memory by default):

```bash
bash uninstall.sh

# To also delete all analyzed plugin docs:
bash uninstall.sh --purge-memory
```

---

## Private GitHub Repos

Pass your token at invocation time — the agent will use it in the `Authorization`
header for all GitHub API requests:

```
"Analyze https://github.com/myorg/my-private-plugin — token: ghp_xxx"
```

---

## Usage

Open any Claude Code session and invoke naturally:

```
# Local plugin
"Analyze the WordPress plugin at /var/www/html/wp-content/plugins/my-plugin"

# Public GitHub repo
"Analyze https://github.com/woocommerce/woocommerce"

# Private GitHub repo
"Analyze https://github.com/myorg/my-plugin — token: ghp_xxx"

# Query memory afterwards (any session, any project)
"What hooks does WooCommerce expose on the cart page?"
"What custom DB tables does my-plugin create?"
"How do I override my-plugin's templates from my theme?"
```

---

## What Gets Written to Memory

```
~/.claude/agent-memory/wp-mnemon/
├── MEMORY.md                           ← index of all analyzed plugins
└── plugins/
    └── {plugin-slug}/
        ├── overview.md                 ← what it does, bootstrap flow, execution flows, UI map
        ├── architecture.md             ← class hierarchy, namespaces, autoloading, dependencies
        ├── hooks.md                    ← all hooks registered, exposed, and removed with context
        ├── data.md                     ← CPTs, meta, options, DB tables, REST, assets, cron
        └── extending.md               ← extensibility patterns, key extension points, code examples
```

Each plugin gets a deep analysis covering: what it does and who it's for, full
class architecture and design patterns, bootstrap and initialization flow,
execution flows for every major feature (trigger → processing → output), admin and
frontend UI mapping, all hooks with context on what they do and why, complete data
structures and lifecycle, REST routes with request/response shapes, third-party
integrations, and practical code examples for extending the plugin.

---

## Files

```
wp-agents/
└── wp-mnemon/
    ├── install.sh
    ├── uninstall.sh
    ├── README.md                         ← you are here
    └── .claude/
        ├── agents/
        │   └── wp-mnemon.md              ← subagent definition
        └── skills/
            └── wp-mnemon/
                ├── SKILL.md              ← 12-phase deep analysis instructions
                └── scripts/
                    ├── scan_hooks.sh     ← grep all hook patterns (local plugins)
                    ├── scan_data.sh      ← grep CPTs, meta, options, DB (local plugins)
                    └── scan_classes.sh   ← grep class architecture (local plugins)
```
