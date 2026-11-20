# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.1] - 2026-11-20

### Changed

- The wp-mnemon agent runs on the Sonnet model.

## [1.1.0] - 2026-10-19

### Added

- wp-mnemon checks agent memory before analyzing and reuses an existing analysis of the same plugin version, unless asked to re-analyze or refresh.
- wp-mnemon stores each plugin version in its own folder (`plugins/{slug}/{version}/`) with one index row per slug and version, so analyses of different versions stay on record side by side.

### Changed

- wp-mnemon writes memory under `$CLAUDE_CONFIG_DIR` when set, otherwise `~/.claude`.
- Docs written by earlier runs directly in `plugins/{slug}/` are moved into their version folder on the next run.

[Unreleased]: https://github.com/s3rgiosan/wp-agents/compare/1.1.1...HEAD
[1.1.1]: https://github.com/s3rgiosan/wp-agents/compare/1.1.0...1.1.1
[1.1.0]: https://github.com/s3rgiosan/wp-agents/releases/tag/1.1.0
