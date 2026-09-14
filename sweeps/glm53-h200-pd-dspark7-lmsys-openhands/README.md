# glm53-h200-pd-dspark7-lmsys-openhands

| Item | Value |
|---|---|
| run_id | `20260911T053020Z` |
| Cluster | CoreWeave piggy, namespace `zhu-dev` |
| GPUs | 16× H200 (8 prefill + 8 decode) |
| Model | `zai-org/GLM-5.3` |
| Speculator | `RedHatAI/GLM-5.2-speculator.dspark` revision `cc714308fc4ad68b667a6a71bbf2a344c2ef903b`, k=7 |
| vLLM commit | [`95eb419caf7501fd3c9d05887e897528d2f835d8`](https://github.com/LucasWilkinson/vllm/commit/95eb419caf7501fd3c9d05887e897528d2f835d8) |
| ve | `/workspace/vdptest/frankenstein-clean-dspark-pd-e7ede2722` |
| Client | EvalScope `acd09b44384d53174768bb1063f675420f76fae9`, `perf --dataset swe_smith --multi-turn` |
| Dataset builder | sglang `2bac7e166a7b5bf518b778817ec464cec0f75e3e` |
| Dataset | `openhand-zai-org-GLM-5.3-48534d2fdaafc810.json` |
| first_turn_length | 74160 |
| subsequent_turn_length | 753 |
| num_turns | 13 |
| max_tokens | 220 |
| ignore_eos | true |
| conc | 1, 2, 4, 8 |
| conversations (EvalScope `--number`) | 4, 8, 8, 16 |
| serving GPUs for tok/s/gpu | 16 |

Manifests (`EXPECTED_VLLM_COMMIT` in base spec):

- [`p1-pcp8ep-d1-tp8ep-dspark7-frankenstein-clean-agentx`](https://github.com/LucasWilkinson/agentx-mvp/blob/feature/manifesto-sweeps/manifesto/models/glm-5.3/h200/p1-pcp8ep-d1-tp8ep-dspark7-frankenstein-clean-agentx.yaml)
- [`p1-pcp8dcp8ep-d1-tp8ep-dspark7-frankenstein-clean-agentx`](https://github.com/LucasWilkinson/agentx-mvp/blob/feature/manifesto-sweeps/manifesto/models/glm-5.3/h200/p1-pcp8dcp8ep-d1-tp8ep-dspark7-frankenstein-clean-agentx.yaml)
- [`p1-tp8ep-d1-tp8ep-dspark7-frankenstein-clean-agentx`](https://github.com/LucasWilkinson/agentx-mvp/blob/feature/manifesto-sweeps/manifesto/models/glm-5.3/h200/p1-tp8ep-d1-tp8ep-dspark7-frankenstein-clean-agentx.yaml)
- base pin: [`base-dspark7-frankenstein-clean-agentx.yaml#L69`](https://github.com/LucasWilkinson/agentx-mvp/blob/feature/manifesto-sweeps/manifesto/models/glm-5.3/h200/base-dspark7-frankenstein-clean-agentx.yaml#L69)

CSV: [`evalscope-summary.csv`](evalscope-summary.csv) · [`acceptance.csv`](acceptance.csv)  
Raw: [`raw/`](raw/) · ve snapshots: `vllm_env_*.txt`

`tok_s_per_gpu` = EvalScope `Total Throughput (tok/s)` / 16.

`evalscope_decoded_tok_iter` is EvalScope `Decoded Tok/Iter`. `evalscope_spec_accept_rate` is EvalScope `Spec. Accept Rate` = `1 - 1 / Decoded Tok/Iter`.

## EvalScope

| prefiller | conc | HTTP | fail | duration_s | rps | TTFT (ms) | TPOT (ms) | ITL (ms) | total tok/s | tok/s/gpu | acc. length | evalscope spec accept |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| pcp8 | 1 | 52 | 0 | 100.11 | 0.5194 | 697.48 | 5.60 | 29.50 | 41554.70 | 2597.17 | 5.69 | 0.8243 |
| pcp8 | 2 | 104 | 0 | 114.25 | 0.9103 | 888.48 | 5.89 | 31.70 | 72785.26 | 4549.08 | 5.88 | 0.8301 |
| pcp8 | 4 | 104 | 0 | 223.00 | 0.4664 | 7306.89 | 5.19 | 30.35 | 37297.71 | 2331.11 | 6.34 | 0.8423 |
| pcp8 | 8 | 208 | 0 | 446.27 | 0.4661 | 15712.85 | 5.24 | 29.45 | 37265.04 | 2329.07 | 6.14 | 0.8373 |
| pcp8dcp8 | 1 | 52 | 0 | 107.54 | 0.4835 | 950.48 | 5.10 | 29.34 | 38717.68 | 2419.86 | 6.24 | 0.8397 |
| pcp8dcp8 | 2 | 104 | 0 | 118.02 | 0.8812 | 953.29 | 5.86 | 31.75 | 70484.92 | 4405.31 | 5.85 | 0.8292 |
| pcp8dcp8 | 4 | 104 | 0 | 60.96 | 1.7060 | 757.18 | 6.88 | 36.25 | 136343.16 | 8521.45 | 5.93 | 0.8314 |
| pcp8dcp8 | 8 | 208 | 0 | 106.06 | 1.9611 | 2168.78 | 7.59 | 43.33 | 156751.61 | 9796.98 | 6.18 | 0.8381 |
| tp8 | 1 | 52 | 0 | 141.47 | 0.3676 | 1563.35 | 5.28 | 29.69 | 29406.47 | 1837.90 | 6.18 | 0.8382 |
| tp8 | 2 | 104 | 0 | 147.46 | 0.7053 | 1555.69 | 5.80 | 31.69 | 56408.47 | 3525.53 | 6.06 | 0.8349 |
| tp8 | 4 | 104 | 0 | 143.20 | 0.7262 | 4070.68 | 6.35 | 35.38 | 58109.69 | 3631.86 | 6.02 | 0.8339 |
| tp8 | 8 | 208 | 0 | 2195.22 | 0.0948 | 81695.00 | 5.58 | 30.49 | 7575.86 | 473.49 | 6.08 | 0.8354 |

## DSpark7 per-position accept (decode)

Token-weighted by `Drafted` in each 10s `SpecDecoding metrics` line. `mean_accept_len` is vLLM `Mean acceptance length`. `p0`–`p6` are `Per-position acceptance rate`. pcp8: decoder-c-tail only. pcp8dcp8 / tp8: pod-window.

| prefiller | conc | source | n | drafted | accepted | mean_accept_len | p0 | p1 | p2 | p3 | p4 | p5 | p6 |
|---|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| pcp8 | 1 | decoder-c-tail | 3 | 4305 | 2914 | 5.74 | 0.918 | 0.828 | 0.730 | 0.663 | 0.608 | 0.535 | 0.457 |
| pcp8 | 2 | decoder-c-tail | 3 | 7637 | 4681 | 5.29 | 0.859 | 0.762 | 0.684 | 0.608 | 0.542 | 0.470 | 0.367 |
| pcp8 | 4 | decoder-c-tail | 3 | 2919 | 2474 | 6.93 | 0.988 | 0.957 | 0.926 | 0.885 | 0.796 | 0.729 | 0.652 |
| pcp8 | 8 | decoder-c-tail | 3 | 2835 | 2462 | 7.08 | 0.990 | 0.955 | 0.924 | 0.899 | 0.877 | 0.755 | 0.679 |
| pcp8dcp8 | 1 | pod-window | 12 | 14350 | 9653 | 5.71 | 0.915 | 0.799 | 0.715 | 0.655 | 0.603 | 0.546 | 0.476 |
| pcp8dcp8 | 2 | pod-window | 13 | 30422 | 18988 | 5.37 | 0.898 | 0.799 | 0.682 | 0.581 | 0.530 | 0.472 | 0.407 |
| pcp8dcp8 | 4 | pod-window | 7 | 31283 | 18783 | 5.20 | 0.862 | 0.749 | 0.650 | 0.578 | 0.527 | 0.455 | 0.382 |
| pcp8dcp8 | 8 | pod-window | 13 | 59416 | 38070 | 5.49 | 0.875 | 0.785 | 0.709 | 0.605 | 0.559 | 0.500 | 0.451 |
| tp8 | 1 | pod-window | 15 | 14882 | 9586 | 5.51 | 0.889 | 0.788 | 0.689 | 0.625 | 0.577 | 0.506 | 0.435 |
| tp8 | 2 | pod-window | 16 | 30156 | 19027 | 5.42 | 0.884 | 0.771 | 0.683 | 0.609 | 0.556 | 0.487 | 0.427 |
| tp8 | 4 | pod-window | 16 | 29701 | 19065 | 5.49 | 0.891 | 0.796 | 0.712 | 0.598 | 0.549 | 0.501 | 0.448 |
| tp8 | 8 | pod-window | 217 | 60900 | 37535 | 5.31 | 0.858 | 0.759 | 0.662 | 0.591 | 0.539 | 0.480 | 0.425 |
