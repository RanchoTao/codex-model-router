# Benchmarks

The routing policy should be evaluated empirically rather than by intuition.

## Baselines

Compare at least:

1. Always Luna
2. Always Terra
3. Always Sol
4. Always Astra
5. codex-model-router

## Metrics

Record:

- task success / acceptance;
- model selected;
- reasoning effort;
- number of escalations;
- total input/output tokens or allowance usage when available;
- latency;
- tool calls;
- validation result;
- unnecessary-Astra rate;
- failure-after-cheap-route rate.

The useful objective is approximately:

~~~text
minimize expected total cost
subject to required task success and quality
~~~

A cheap failure that forces repeated reruns may cost more than selecting the correct stronger route initially.

tasks.jsonl is a starter routing set, not yet a serious performance benchmark.
