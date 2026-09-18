# Architecture

## Goal

Choose the minimum sufficient intelligence for each task while preserving a reliable escalation path.

## Native Codex primitives

The project relies on native Codex features:

1. global/repository Skills for routing policy;
2. AGENTS.md for applying routing to distinct tasks;
3. custom subagent TOML files for exact model/effort selection;
4. subagent orchestration for delegation and handoff.

No external proxy is required for v0.1.

## Control flow

~~~text
User task
   |
   v
Parent orchestrator
   |
   +--> explicit override? -------- yes --> obey user
   |
   no
   |
   v
codex-model-router Skill
   |
   v
cheap structural classification
   |
   v
select exactly one profile
   |
   v
spawn model-specific worker
   |
   v
validate result
   |
   +--> sufficient --> return
   |
   +--> demonstrated difficulty --> escalate with handoff
~~~

## Why not Astra-first routing?

Using the most expensive model to classify every task introduces a fixed high-cost tax before useful work happens. For focused or repetitive tasks, the classifier can cost more than the work it routes.

A cheap orchestrator plus evidence-driven escalation has a better chance of reducing total allowance usage.

## Why native profiles?

A prompt label alone does not select a model. Custom agent profiles can set both model and model_reasoning_effort, making routing operational rather than rhetorical.

## Current limitation

The parent model has already been selected when the Skill runs. The Skill cannot retroactively replace it for that turn. Therefore the strongest quota-saving configuration uses Luna or Terra as the parent/orchestrator and delegates upward.

A future version can add an external launcher or API harness that chooses the root model before creating the Codex session.

## Future work

- benchmark-driven route calibration;
- optional route logging;
- economy / balanced / quality / max budget modes;
- failure classifiers;
- dynamic parallelism;
- API/SDK router that chooses the root model before session creation;
- provider-agnostic routing.
