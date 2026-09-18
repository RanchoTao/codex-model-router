# Routing policy

This policy is intentionally conservative about expensive models.

## Dimensions

Assess the task qualitatively across scope, ambiguity, reasoning depth, context breadth, novelty, verification burden, failure cost, and iteration risk.

Do not invent fake numeric precision unless benchmarking demonstrates that a scoring classifier works better.

## Luna

### Luna low
Mechanical work: extraction, classification, formatting, renaming, deterministic edits, simple searches, boilerplate, repetitive transformations.

### Luna medium
Small clear tasks with light reasoning: short summaries, obvious small code edits, simple test updates, data cleanup, narrow documentation edits.

### Luna high
Bounded synthesis: large read-only scans, comparing many similar files, repetitive review checks, summarizing homogeneous artifacts.

### Luna xhigh
Tricky but tightly constrained work where Luna is still appropriate.

### Luna max
Reserve for the hardest tightly bounded Luna-suitable work or an explicit user request. If ambiguity or architecture becomes important, move to Terra.

## Terra

### Terra low
Routine everyday work: normal docs, common refactors, small features, routine code changes, well-specified scripts.

### Terra medium
Default standard engineering/professional work: feature implementation, ordinary debugging, document analysis, moderate multi-file edits, normal test design.

### Terra high
Harder everyday work: multi-file debugging, edge-case review, integration issues, nontrivial state flows, complex but familiar analysis.

### Terra xhigh
Difficult but bounded domain work.

### Terra max
Use for the hardest bounded Terra-suitable work. Escalate to Sol when broad planning, architecture, research synthesis, or substantial uncertainty resolution becomes central.

## Sol

### Sol low
Clearly beyond routine work but well specified: complex features, deep debugging, nontrivial algorithms, broad structured analysis.

### Sol medium
Default for genuinely complex work: architecture changes, long dependency chains, research synthesis, complex data/model analysis, multi-step tool use with validation.

### Sol high
Reasoning-heavy work: difficult algorithms, mathematical derivations, research methodology, subtle correctness analysis, complex systems design.

### Sol xhigh
Very deep known-domain reasoning.

### Sol max
Hardest work still reasonably contained in a known domain: very deep debugging, proof-like reasoning, major architecture decisions, or Sol-xhigh failures where depth is the main bottleneck.

## Astra

### Astra low
Use when superior generality matters: unfamiliar problem spaces, cross-domain tasks with moderate depth, or end-to-end workflows with good constraints.

### Astra medium
Demanding end-to-end work: broad autonomous implementation, research plus engineering, complex planning/tool use, unfamiliar systems with validation.

### Astra high
Severe ambiguity or reasoning burden: multiple interacting unknowns, repeated Sol failures, difficult novel research/engineering problems.

### Astra xhigh
Use for severe ambiguity, novelty, or repeated Sol failures.

### Astra max
Reserve for boundary-of-capability tasks, repeated high-quality failures below Astra max, unusually difficult end-to-end work, or explicit user request.

## Tie-breakers

1. Choose cheaper if failure is cheap and escalation is easy.
2. Choose stronger if failure would destroy work, trigger irreversible action, or materially increase total cost.
3. Prefer higher effort within the same family when the domain is bounded.
4. Prefer moving up a family when ambiguity, novelty, or breadth is the main problem.
