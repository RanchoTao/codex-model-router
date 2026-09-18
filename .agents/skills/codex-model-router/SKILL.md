---
name: codex-model-router
description: Route each distinct Codex task to the cheapest suitable Luna, Terra, Sol, or Astra subagent and reasoning effort; escalate only when evidence shows the current route is insufficient. Use at the start of new tasks unless the user explicitly selects a model/effort or disables routing.
---

# Codex Model Router

Use this skill at the beginning of each distinct user task before substantial execution.

## Objective

Minimize model usage while preserving reliable task completion.

Optimize for:

1. correctness and completion;
2. lowest sufficient model tier;
3. lowest sufficient reasoning effort;
4. minimal unnecessary escalation.

Do not use Astra merely to decide which model should do the task.

## Hard rules

1. An explicit user-selected model or reasoning effort overrides automatic routing.
2. Do not pretend to switch the already-running parent model. Route by spawning a matching custom subagent.
3. Prefer the cheapest route that is reasonably likely to succeed.
4. Escalate when there is evidence of difficulty, not merely because a stronger model exists.
5. Once the hard portion of a task has demonstrated difficulty, do not downgrade responsibility for that portion.
6. Cheap agents may still handle bounded mechanical subtasks after escalation.
7. Do not create multiple expensive agents when one is sufficient.
8. For tiny reversible tasks, avoid orchestration overhead if the current parent can safely complete them and doing so is cheaper.

## Step 1: detect override

If the user explicitly chooses a model, reasoning effort, maximum-quality mode, or asks to disable routing, follow that instruction.

## Step 2: classify the task

Read references/routing-policy.md.

Assess scope size, ambiguity, reasoning depth, file/tool breadth, domain novelty, verification burden, failure cost, and expected iteration count.

Prefer structural evidence over keywords. A long prompt can still be easy; a short bug report can be hard.

## Step 3: choose one initial route

Choose exactly one installed profile from the Luna, Terra, Sol, or Astra family at low, medium, high, or xhigh effort.

When two routes are plausible, choose the cheaper one unless failure would be unusually costly.

## Step 4: delegate

Spawn the chosen custom subagent and pass the user's actual task, relevant constraints/context, expected output, validation requirements, and a request to report blockers honestly.

Do not ask the worker to re-route the whole task unless the parent explicitly delegates routing authority.

## Step 5: inspect the result

Accept the result when it completes the task and validation is adequate.

Escalate if the worker reports or demonstrates a condition in references/escalation-policy.md.

Do not escalate simply because a more expensive model could hypothetically improve the answer.

## Step 6: escalate one step at a time

Default family progression:

~~~text
Luna -> Terra -> Sol -> Astra
~~~

Within a family:

~~~text
low -> medium -> high -> xhigh
~~~

Use judgment. A bounded logic problem may stay within one family while raising effort. A task that becomes cross-domain and ambiguous may move up a family.

Avoid restarting from scratch. Give the next agent useful findings, failures, and evidence already collected.

## User-visible behavior

Routing should normally be quiet. Explain routing only when the user asks, when routing materially affects cost/latency expectations, or when escalation helps explain why a stronger model is now being used.
