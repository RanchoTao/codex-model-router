# codex-model-router

Cost-aware adaptive model routing for Codex.

codex-model-router routes each distinct task to the cheapest model and reasoning effort that is likely to complete it reliably, then escalates only when the task demonstrates that it is harder than expected.

> Core idea: route down aggressively, escalate conservatively, and never use Astra merely to classify a task.

## Why

Codex currently exposes a useful capability/cost ladder:

- GPT-5.6 Luna: fastest and lowest-cost; good for focused or repetitive work.
- GPT-5.6 Terra: balanced speed, capability, and cost for everyday work.
- GPT-5.6 Sol: stronger reasoning for complex professional and coding work.
- GPT-6 Astra: strongest option for the hardest end-to-end work.

Higher reasoning effort also generally increases latency and usage. The router therefore optimizes for task success at minimum sufficient cost, not simply the strongest model.

Official references:

- Models: https://developers.openai.com/api/docs/models
- Codex subagents: https://developers.openai.com/docs/agent-configuration/subagents
- Skills: https://developers.openai.com/docs/build-skills
- Work/Codex usage: https://help.openai.com/en/articles/20001516-managing-usage-with-gpt-6-astra-in-work-and-codex

## Important architecture constraint

A Codex Skill cannot retroactively replace the current parent model for the same turn. Native Codex routing works by having the parent/orchestrator spawn a custom subagent whose profile overrides its model and reasoning effort.

~~~toml
model = "gpt-5.6-terra"
model_reasoning_effort = "medium"
~~~

The most cost-efficient setup is therefore:

~~~text
cheap orchestrator (Luna / Terra)
        |
        +-- simple task ----------------> Luna
        +-- normal task ----------------> Terra
        +-- complex task ---------------> Sol
        +-- hardest / escalated task ---> Astra
~~~

Do not use Astra as the mandatory classifier for every task. That adds an expensive fixed cost before useful work begins.

## Routing matrix

This repository ships 16 native Codex agent profiles: four reasoning levels for each model.

| Model | low | medium | high | xhigh |
|---|---|---|---|---|
| Luna | cmr_luna_low | cmr_luna_medium | cmr_luna_high | cmr_luna_xhigh |
| Terra | cmr_terra_low | cmr_terra_medium | cmr_terra_high | cmr_terra_xhigh |
| Sol | cmr_sol_low | cmr_sol_medium | cmr_sol_high | cmr_sol_xhigh |
| Astra | cmr_astra_low | cmr_astra_medium | cmr_astra_high | cmr_astra_xhigh |

The router does not use all 16 equally. It prefers lower-cost routes and treats higher-effort profiles as escalation points.

## Default policy

| Task shape | Default route |
|---|---|
| Mechanical edit, extraction, classification, formatting | Luna low |
| Small scoped task with light reasoning | Luna medium |
| Large bounded scan / repetitive synthesis | Luna high |
| Tricky but tightly bounded work | Luna xhigh |
| Routine code/doc change | Terra low |
| Normal implementation, analysis, debugging | Terra medium |
| Multi-file debugging or review | Terra high |
| Difficult but bounded domain work | Terra xhigh |
| Complex feature or deep debugging | Sol low/medium |
| Architecture, algorithms, research synthesis | Sol high |
| Very difficult known-domain reasoning | Sol xhigh |
| Unfamiliar, cross-domain, long-horizon task | Astra low/medium |
| High ambiguity, repeated failures, hardest end-to-end work | Astra high/xhigh |

See .agents/skills/codex-model-router/references/routing-policy.md for the full policy.

## Escalation

Typical family progression:

~~~text
Luna -> Terra -> Sol -> Astra
~~~

Reasoning effort can rise before changing model when that is cheaper and likely to solve the problem:

~~~text
low -> medium -> high -> xhigh
~~~

Escalate on evidence: repeated failures, unresolved ambiguity, expanding scope, deeper architectural/research complexity, or failed validation that the current worker cannot explain.

Once a task has demonstrated difficulty, do not downgrade responsibility for the hard part. Cheap agents may still handle mechanical subtasks.

## Install

### Windows PowerShell

    git clone https://github.com/RanchoTao/codex-model-router.git
    cd codex-model-router
    powershell -ExecutionPolicy Bypass -File .\scripts\install.ps1

### macOS / Linux

    git clone https://github.com/RanchoTao/codex-model-router.git
    cd codex-model-router
    bash scripts/install.sh

The installer:

1. copies the Skill to ~/.agents/skills/codex-model-router/;
2. copies namespaced agent profiles to ~/.codex/agents/;
3. adds an idempotent routing block to ~/.codex/AGENTS.md;
4. leaves your existing parent-model selection untouched.

Restart Codex if the new Skill does not appear immediately.

## Recommended parent model

For maximum quota savings, use a cheap parent/orchestrator, usually Luna low or medium.

An optional example lives at examples/luna-root-config.toml. Merge it into your existing ~/.codex/config.toml rather than overwriting unrelated settings.

## Manual override

The user always wins. Examples:

    Use cmr_luna_low for this.
    Route this with Sol high.
    Use Astra xhigh; do not downgrade.
    Do not use model routing for this task.

The Skill must not override an explicit user-selected model or effort.

## Repository layout

~~~text
.
├── .agents/skills/codex-model-router/
│   ├── SKILL.md
│   └── references/
├── .codex/agents/
│   └── cmr-*.toml
├── benchmarks/
├── docs/
├── examples/
└── scripts/
~~~

## Status

v0.1 experimental.

The native primitives are real: Codex supports repository/user Skills, custom subagents, per-agent model overrides, and per-agent model_reasoning_effort. The routing policy itself still needs empirical evaluation.

The next milestone is to benchmark success rate, total allowance/token usage, latency, escalation rate, and unnecessary-Astra rate against fixed baselines such as Always-Sol and Always-Astra.

## License

No license has been selected yet.
