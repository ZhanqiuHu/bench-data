# glm53-h200-pd-dspark7-lmsys-openhands

| Item | Value |
|---|---|
| run_id | `20260911T053020Z` |
| Cluster | CoreWeave piggy, namespace `zhu-dev` |
| GPUs | 16× H200 (8 prefill + 8 decode) |
| Model | `zai-org/GLM-5.3` |
| Speculator | `RedHatAI/GLM-5.2-speculator.dspark` revision `cc714308fc4ad68b667a6a71bbf2a344c2ef903b`, k=7 |
| vLLM | [`95eb419caf7501fd3c9d05887e897528d2f835d8`](https://github.com/LucasWilkinson/vllm/commit/95eb419caf7501fd3c9d05887e897528d2f835d8) |
| Workload | LMSYS OpenHands, EvalScope `perf --dataset swe_smith --multi-turn` |
| first_turn / subsequent / turns / max_tokens | 74160 / 753 / 13 / 220 (`ignore_eos: true`) |
| conc | 1, 2, 4, 8 |

Manifests:

- [`p1-pcp8ep-d1-tp8ep-dspark7-frankenstein-clean-agentx`](https://github.com/LucasWilkinson/agentx-mvp/blob/feature/manifesto-sweeps/manifesto/models/glm-5.3/h200/p1-pcp8ep-d1-tp8ep-dspark7-frankenstein-clean-agentx.yaml)
- [`p1-pcp8dcp8ep-d1-tp8ep-dspark7-frankenstein-clean-agentx`](https://github.com/LucasWilkinson/agentx-mvp/blob/feature/manifesto-sweeps/manifesto/models/glm-5.3/h200/p1-pcp8dcp8ep-d1-tp8ep-dspark7-frankenstein-clean-agentx.yaml)
- [`p1-tp8ep-d1-tp8ep-dspark7-frankenstein-clean-agentx`](https://github.com/LucasWilkinson/agentx-mvp/blob/feature/manifesto-sweeps/manifesto/models/glm-5.3/h200/p1-tp8ep-d1-tp8ep-dspark7-frankenstein-clean-agentx.yaml)
- pin: [`base-dspark7-frankenstein-clean-agentx.yaml#L69`](https://github.com/LucasWilkinson/agentx-mvp/blob/feature/manifesto-sweeps/manifesto/models/glm-5.3/h200/base-dspark7-frankenstein-clean-agentx.yaml#L69)

`tok/s/GPU` = EvalScope `Total Throughput (tok/s)` / 16.  
Acc. length = EvalScope `Decoded Tok/Iter`.

Raw dumps: [`evalscope-summary.csv`](evalscope-summary.csv) · [`acceptance.csv`](acceptance.csv) · [`raw/`](raw/) · `vllm_env_*.txt`

## EvalScope

| prefiller | conc | RPS | TTFT | TPOT | tok/s/GPU | Acc. length |
|---|---:|---:|---:|---:|---:|---:|
| PCP8 | 1 | 0.5194 | 697 ms | 5.60 ms | 2597 | 5.69 |
| PCP8 | 2 | 0.9103 | 888 ms | 5.89 ms | 4549 | 5.88 |
| PCP8 | 4 | 0.4664 | 7.31 s | 5.19 ms | 2331 | 6.34 |
| PCP8 | 8 | 0.4661 | 15.71 s | 5.24 ms | 2329 | 6.14 |
| PCP8+DCP8 | 1 | 0.4835 | 950 ms | 5.10 ms | 2420 | 6.24 |
| PCP8+DCP8 | 2 | 0.8812 | 953 ms | 5.86 ms | 4405 | 5.85 |
| PCP8+DCP8 | 4 | 1.706 | 757 ms | 6.88 ms | 8521 | 5.93 |
| PCP8+DCP8 | 8 | 1.9611 | 2.17 s | 7.59 ms | 9797 | 6.18 |
| TP8 | 1 | 0.3676 | 1.56 s | 5.28 ms | 1838 | 6.18 |
| TP8 | 2 | 0.7053 | 1.56 s | 5.80 ms | 3526 | 6.06 |
| TP8 | 4 | 0.7262 | 4.07 s | 6.35 ms | 3632 | 6.02 |
| TP8 | 8 | 0.0948 | 81.70 s | 5.58 ms | 473 | 6.08 |

## DSpark7 per-position accept (decode, pod-window)

Token-weighted by `Drafted` in each 10s `SpecDecoding metrics` line. MAL = vLLM `Mean acceptance length`. `p0`–`p6` = `Per-position acceptance rate`. PCP8 has no full pod-window dump (decoder log is a 3-sample tail only) and is not in this table.

| prefiller | conc | n | MAL | p0 | p1 | p2 | p3 | p4 | p5 | p6 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| PCP8+DCP8 | 1 | 12 | 5.71 | 0.915 | 0.799 | 0.715 | 0.655 | 0.603 | 0.546 | 0.476 |
| PCP8+DCP8 | 2 | 13 | 5.37 | 0.898 | 0.799 | 0.682 | 0.581 | 0.530 | 0.472 | 0.407 |
| PCP8+DCP8 | 4 | 7 | 5.20 | 0.862 | 0.749 | 0.650 | 0.578 | 0.527 | 0.455 | 0.382 |
| PCP8+DCP8 | 8 | 13 | 5.49 | 0.875 | 0.785 | 0.709 | 0.605 | 0.559 | 0.500 | 0.451 |
| TP8 | 1 | 15 | 5.51 | 0.889 | 0.788 | 0.689 | 0.625 | 0.577 | 0.506 | 0.435 |
| TP8 | 2 | 16 | 5.42 | 0.884 | 0.771 | 0.683 | 0.609 | 0.556 | 0.487 | 0.427 |
| TP8 | 4 | 16 | 5.49 | 0.891 | 0.796 | 0.712 | 0.598 | 0.549 | 0.501 | 0.448 |
| TP8 | 8 | 217 | 5.31 | 0.858 | 0.759 | 0.662 | 0.591 | 0.539 | 0.480 | 0.425 |
