# Development instructions

This repository develops the codex-model-router Skill.

When working on this repository:

- Keep routing policy explicit, auditable, and cost-aware.
- Prefer native Codex mechanisms over custom wrappers when native subagent configuration is sufficient.
- Do not claim that a Skill can switch the already-running parent model. It can route work by spawning a model-specific subagent.
- Do not hard-code undocumented model identifiers or reasoning levels.
- Preserve user override: an explicit model/effort request takes precedence over automatic routing.
- Treat benchmark results as evidence; do not claim quota savings until measured.
- Keep installers idempotent and avoid overwriting unrelated user configuration.
