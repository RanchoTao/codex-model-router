# Escalation policy

Escalation is evidence-driven.

## Escalate when

- the worker explicitly says it cannot complete reliably;
- two materially different attempts fail for the same unresolved reason;
- validation/test evidence contradicts the proposed solution and the worker cannot localize why;
- required context expands substantially beyond the initial scope;
- architectural, mathematical, research, or cross-domain complexity emerges;
- the worker must guess at a critical assumption that cannot be cheaply verified;
- the user explicitly asks for a stronger model or more reasoning.

## Usually do not escalate when

- a command fails because of a typo, missing path, transient dependency, or clear local setup issue;
- the worker needs one more targeted file or source;
- a small reversible edit needs a quick correction;
- the answer can be verified cheaply;
- the task is long but mechanically repetitive.

## Escalation order

Prefer the smallest useful increase.

~~~text
Luna low -> Luna medium
Luna high -> Terra low
Terra medium -> Terra high
Terra high -> Sol medium
Sol high -> Sol max
Sol max -> Astra high
Astra high -> Astra max
~~~

Why it failed determines the next route:

- lack of reasoning depth -> raise effort;
- lack of broad judgment or ambiguity handling -> raise model family;
- excessive volume but low complexity -> keep model cheap and parallelize bounded work when useful.

## Handoff requirements

When escalating, pass forward what was attempted, what succeeded, exact failures, relevant files/sources, hypotheses ruled out, validation output, and remaining uncertainty.

Do not make the stronger model rediscover everything from scratch.

## Stop conditions

Stop escalating when the task is complete and validated, the user-imposed ceiling is reached, the blocker is external, or missing information genuinely requires user input.
