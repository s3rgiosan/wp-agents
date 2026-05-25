# wp-mnemon

> *Mnemon (μνήμων) — ancient Greek for "one who remembers". A keeper of knowledge.*

Part of [wp-agents](../README.md) — Claude Code agents for WordPress developers.

A Claude Code subagent that deeply analyzes WordPress plugins and writes permanent
documentation into Claude's global memory, making plugin knowledge available in
every future session without re-reading code.

---

## Installation

### Via Claude Code plugin marketplace (recommended)

```
/plugin marketplace add s3rgiosan/wp-agents
/plugin install wp-mnemon@wp-agents
```

The plugin declares a cross-marketplace dependency on `wp-mnemon@wp-skills`. Claude Code installs both automatically; you don't need to add the `wp-skills` marketplace yourself, but the skill dependency must be enabled (run `/plugin` and confirm both show as enabled).

Or wire via `settings.json`:

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

### Via shell script (fallback)

The subagent depends on the [`wp-mnemon` skill](https://github.com/s3rgiosan/wp-skills/tree/main/wp-mnemon) from the `wp-skills` repo. The installer detects whether the skill is present and offers to fetch it for you:

```bash
git clone https://github.com/s3rgiosan/wp-agents.git
cd wp-agents/wp-mnemon

# Default → ~/.claude. Prompts to install the skill if it's missing.
bash install.sh

# Custom Claude config dir (override via env var)
CLAUDE_CONFIG_DIR=~/.some-other-dir bash install.sh
```

If the skill is missing the installer asks `Install it now? [Y/n]`; on yes it shallow-clones `wp-skills` into a temp dir, runs the skill's installer, and cleans up.

### Flags

| Flag | When to use |
|---|---|
| `--yes` / `-y` | Skip the prompt and auto-install the skill. Use in CI or non-interactive shells. |
| `--no-skill-install` | Skip auto-install entirely. Fails fast with manual instructions if the skill is missing. Use when you manage skills yourself. |

```bash
bash install.sh --yes                    # auto-fetch on missing skill (CI / scripts)
bash install.sh --no-skill-install       # opt out; fail-fast if missing
```

The installer falls back to manual instructions automatically when `git` isn't on `PATH`, when stdin isn't a TTY (and `--yes` isn't set), or when `--no-skill-install` is passed.

### Manual two-step (alternative)

If you'd rather manage each repo explicitly:

```bash
# 1) Install the skill from wp-skills
git clone https://github.com/s3rgiosan/wp-skills.git
cd wp-skills/wp-mnemon && bash install.sh

# 2) Install the subagent from wp-agents
cd ../..
git clone https://github.com/s3rgiosan/wp-agents.git
cd wp-agents/wp-mnemon && bash install.sh
```

To uninstall (keeps your plugin memory by default):

```bash
bash uninstall.sh                                # → ~/.claude
CLAUDE_CONFIG_DIR=~/.some-other-dir bash uninstall.sh   # → custom dir

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
├── .claude-plugin/
│   └── marketplace.json                  ← marketplace manifest for the wp-agents repo
└── wp-mnemon/
    ├── .claude-plugin/
    │   └── plugin.json                   ← declares dependency on wp-mnemon@wp-skills
    ├── agents/
    │   └── wp-mnemon.md                  ← subagent definition
    ├── install.sh                        ← fallback installer
    ├── uninstall.sh
    └── README.md                         ← you are here
```

The skill (`SKILL.md` + `scripts/`) lives in the [`wp-skills`](https://github.com/s3rgiosan/wp-skills) repo under `wp-mnemon/`. Centralising skills there means the subagent here stays focused on the memory + agent contract, while the analysis instructions and helper scripts can be invoked standalone from any Claude Code session.
