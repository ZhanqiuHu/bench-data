GLM-5.2-FP8 inference benchmark results (aiperf 0.12).

### Hardware & serving

| Item | Value |
|---|---|
| GPUs | 16× H200 |
| Topology | P/D disaggregated: 8× prefill + 8× decode |
| Model | `zai-org/GLM-5.2-FP8` |

### Speculative decoding config (compare these two setups)

| | MTP | DSpark |
|---|---|---|
| Prefill draft tokens (k) | 1 | 1 |
| Decode draft tokens (k) | 5 | 7 |

### Metrics (from aiperf `profile_export_aiperf.csv`)

| Column in tables below | aiperf metric |
|---|---|
| output tok/s/user | Output Token Throughput Per User |
| TTFT (ms) | Time to First Token |
| ITL (ms) | Inter Token Latency |
| request latency (ms) | Request Latency |
| mean_accept_len | vLLM SpecDecoding (decode log) |
| draft_accept_rate | accepted tokens / drafted tokens |
| per_pos | per-position acceptance rate vector |

Sweep: `glm52-fp8-pd-mtp-dspark-20260901` · datasets: spec-al-math500, spec-al-humaneval · concurrency 4–512

## spec-al-math500

One row per **concurrency**. Each **Δ%** column = `(DSpark − MTP) / MTP × 100` for that metric (negative on latency = DSpark lower/faster).

| concurrency | MTP tok/s/user | DSpark tok/s/user | Δ% tok/s/user | MTP TTFT (ms) | DSpark TTFT (ms) | Δ% TTFT | MTP ITL (ms) | DSpark ITL (ms) | Δ% ITL | MTP req latency (ms) | DSpark req latency (ms) | Δ% req latency |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 4 | 118.57 | 136.34 | +15 | 733.78 | 625.19 | -15 | 8.51 | 7.45 | -12 | 24119.70 | 24666.53 | +2 |
| 8 | 107.42 | 139.07 | +29 | 697.24 | 522.14 | -25 | 9.39 | 7.28 | -22 | 27195.12 | 20533.27 | -24 |
| 16 | 94.76 | 125.24 | +32 | 653.52 | 491.84 | -25 | 10.63 | 8.09 | -24 | 33651.84 | 24513.02 | -27 |
| 32 | 90.67 | 109.91 | +21 | 587.75 | 502.46 | -15 | 11.15 | 9.39 | -16 | 35500.22 | 32869.00 | -7 |
| 64 | 79.30 | 76.96 | -3 | 1082.01 | 2506.72 | +132 | 13.00 | 17.27 | +33 | 44734.51 | 60392.83 | +35 |
| 128 | 64.31 | 56.97 | -11 | 1844.17 | 13198.77 | +616 | 16.79 | 47.28 | +182 | 61040.37 | 125236.17 | +105 |
| 256 | 50.14 | 53.75 | +7 | 1475.12 | 46083.61 | +3024 | 20.84 | 61.55 | +195 | 71006.21 | 188352.75 | +165 |
| 512 | 56.14 | 55.81 | -1 | 12405.85 | 22215.88 | +79 | 20.73 | 54.25 | +162 | 83477.43 | 151671.94 | +82 |

Raw CSV: [`summary.csv`](sweeps/glm52-fp8-pd-mtp-dspark-20260901/datasets/spec-al-math500/summary.csv) · [`comparison.csv`](sweeps/glm52-fp8-pd-mtp-dspark-20260901/datasets/spec-al-math500/comparison.csv)

### Speculative decoding acceptance

| concurrency | MTP mean_accept_len | DSpark mean_accept_len | MTP draft_accept_rate | DSpark draft_accept_rate | MTP per_pos | DSpark per_pos |
|---:|---:|---:|---:|---:|---|---|
| 4 | — | — | — | — | — | — |
| 8 | — | — | — | — | — | — |
| 16 | — | — | — | — | — | — |
| 32 | — | — | — | — | — | — |
| 64 | — | — | — | — | — | — |
| 128 | — | — | — | — | — | — |
| 256 | — | — | — | — | — | — |
| 512 | — | — | — | — | — | — |

Acceptance columns empty for this export (decode logs were not archived for this run). Values come from vLLM decode logs + `collect-acceptance.py`.

## spec-al-humaneval

One row per **concurrency**. Each **Δ%** column = `(DSpark − MTP) / MTP × 100` for that metric (negative on latency = DSpark lower/faster).

| concurrency | MTP tok/s/user | DSpark tok/s/user | Δ% tok/s/user | MTP TTFT (ms) | DSpark TTFT (ms) | Δ% TTFT | MTP ITL (ms) | DSpark ITL (ms) | Δ% ITL | MTP req latency (ms) | DSpark req latency (ms) | Δ% req latency |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 4 | 106.52 | 121.39 | +14 | 653.28 | 470.94 | -28 | 9.46 | 8.34 | -12 | 44377.72 | 27496.52 | -38 |
| 8 | 97.03 | 108.58 | +12 | 701.11 | 509.27 | -27 | 10.39 | 9.31 | -10 | 38814.04 | 32018.31 | -18 |
| 16 | 87.20 | 98.28 | +13 | 977.67 | 480.98 | -51 | 11.61 | 10.35 | -11 | 63527.88 | 44738.58 | -30 |
| 32 | 79.57 | 88.42 | +11 | 1082.89 | 541.97 | -50 | 12.91 | 11.98 | -7 | 64746.64 | 57581.42 | -11 |
| 64 | 67.97 | 81.13 | +19 | 1728.30 | 583.18 | -66 | 15.46 | 12.76 | -17 | 65427.42 | 69293.17 | +6 |
| 128 | 65.60 | 71.98 | +10 | 1422.31 | 818.65 | -42 | 15.39 | 14.47 | -6 | 72097.76 | 60877.10 | -16 |
| 256 | 68.21 | 71.03 | +4 | 3139.44 | 1635.81 | -48 | 14.78 | 14.25 | -4 | 61257.59 | 56875.09 | -7 |
| 512 | 61.35 | 68.17 | +11 | 1291.41 | 2891.61 | +124 | 16.63 | 15.23 | -8 | 58848.76 | 59766.78 | +2 |

Raw CSV: [`summary.csv`](sweeps/glm52-fp8-pd-mtp-dspark-20260901/datasets/spec-al-humaneval/summary.csv) · [`comparison.csv`](sweeps/glm52-fp8-pd-mtp-dspark-20260901/datasets/spec-al-humaneval/comparison.csv)

### Speculative decoding acceptance

| concurrency | MTP mean_accept_len | DSpark mean_accept_len | MTP draft_accept_rate | DSpark draft_accept_rate | MTP per_pos | DSpark per_pos |
|---:|---:|---:|---:|---:|---|---|
| 4 | — | — | — | — | — | — |
| 8 | — | — | — | — | — | — |
| 16 | — | — | — | — | — | — |
| 32 | — | — | — | — | — | — |
| 64 | — | — | — | — | — | — |
| 128 | — | — | — | — | — | — |
| 256 | — | — | — | — | — | — |
| 512 | — | — | — | — | — | — |

Acceptance columns empty for this export (decode logs were not archived for this run). Values come from vLLM decode logs + `collect-acceptance.py`.


