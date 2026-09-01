# bench-data

GLM-5.2-FP8 inference benchmark results (aiperf 0.12).

### Hardware & serving

| Item | Value |
|---|---|
| GPUs | 16× H200 |
| Topology | P/D disaggregated: 8× prefill + 8× decode |
| Model | `zai-org/GLM-5.2-FP8` |

### Speculative decoding config (compare these two setups)

| | MTP | **DSpark** |
|---|---|---|
| Prefill draft tokens (k) | 1 | **1** |
| Decode draft tokens (k) | 5 | **7** |

### Metrics (from aiperf `profile_export_aiperf.csv`)

| Column in tables below | aiperf metric |
|---|---|
| n_req | Request Count |
| tok/s/user | Output Token Throughput Per User |
| tok/s (cluster) | Output Token Throughput |
| tok/s/gpu | cluster tok/s ÷ 16 GPUs |
| TTFT (ms) | Time to First Token |
| ITL (ms) | Inter Token Latency |
| req latency (ms) | Request Latency |
| ISL (tokens) | Input Sequence Length |
| OSL (tokens) | Output Sequence Length |

Sweep: `glm52-fp8-pd-mtp-dspark-20260901` · datasets: spec-al-math500, spec-al-humaneval · concurrency 4–512

## spec-al-math500

### Dataset

| Field | Value |
|---|---|
| aiperf `--public-dataset` | `spec-al-math500` |
| HuggingFace source | `HuggingFaceH4/MATH-500` (test) |
| Prompts in dataset | 500 |
| Turns | single |
| License | MIT |
| Warmup per cell | 16 requests (excluded from stats) |
| Profiled requests per cell | `max(concurrency × 8, 100)`, capped at dataset size |
| Measured ISL (avg, c=4) | 71.94 tokens |
| Measured OSL (avg, c=4) | 2783.16 tokens |
| Notes | MATH-500 math problems; model chooses output length (greedy, temperature 0). |

### Throughput & latency

One row per **method** at each **concurrency** (MTP then DSpark).

| c | method | exit | n_req | tok/s/user | tok/s (cluster) | tok/s/gpu | TTFT (ms) | ITL (ms) | req latency (ms) | ISL (tokens) | OSL (tokens) |
|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 4 | MTP | 0 | 100 | 118.57 | 389.87 | 24.37 | 733.78 | 8.51 | 24119.70 | 71.94 | 2783.16 |
| 4 | **DSpark** | 0 | 100 | **136.34** | **437.29** | **27.33** | **625.19** | **7.45** | **24666.53** | 71.94 | **3157.58** |
| 8 | MTP | 0 | 100 | 107.42 | 604.99 | 37.81 | 697.24 | 9.39 | 27195.12 | 71.94 | 2896.54 |
| 8 | **DSpark** | 0 | 100 | **139.07** | **761.26** | **47.58** | **522.14** | **7.28** | **20533.27** | 71.94 | **2706.46** |
| 16 | MTP | 0 | 128 | 94.76 | 1073.38 | 67.09 | 653.52 | 10.63 | 33651.84 | 71.57 | 3104.43 |
| 16 | **DSpark** | 0 | 128 | **125.24** | **1605.35** | **100.33** | **491.84** | **8.09** | **24513.02** | 71.57 | **2863.32** |
| 32 | MTP | 0 | 256 | 90.67 | 1807.91 | 112.99 | 587.75 | 11.15 | 35500.22 | 79.22 | 3159.12 |
| 32 | **DSpark** | 0 | 256 | **109.91** | **1987.30** | **124.21** | **502.46** | **9.39** | **32869.00** | 79.22 | **3215.54** |
| 64 | MTP | 0 | 500 | 79.30 | 2797.88 | 174.87 | 1082.01 | 13.00 | 44734.51 | 80.72 | 3388.34 |
| 64 | **DSpark** | 0 | 500 | **76.96** | **2168.96** | **135.56** | **2506.72** | **17.27** | **60392.83** | 80.72 | **3143.27** |
| 128 | MTP | 0 | 500 | 64.31 | 2668.83 | 166.80 | 1844.17 | 16.79 | 61040.37 | 80.72 | 3170.17 |
| 128 | **DSpark** | 0 | 500 | **56.97** | **2032.76** | **127.05** | **13198.77** | **47.28** | **125236.17** | 80.72 | **3262.61** |
| 256 | MTP | 0 | 500 | 50.14 | 2679.17 | 167.45 | 1475.12 | 20.84 | 71006.21 | 80.72 | 3228.89 |
| 256 | **DSpark** | 0 | 500 | **53.75** | **1704.85** | **106.55** | **46083.61** | **61.55** | **188352.75** | 80.72 | **3209.88** |
| 512 | MTP | 0 | 500 | 56.14 | 2493.78 | 155.86 | 12405.85 | 20.73 | 83477.43 | 80.72 | 3135.91 |
| 512 | **DSpark** | 0 | 500 | **55.81** | **2164.70** | **135.29** | **22215.88** | **54.25** | **151671.94** | 80.72 | **3204.24** |

### MTP vs DSpark comparison

One row per **concurrency**. Each **Δ%** = `(DSpark − MTP) / MTP × 100` (negative on latency = DSpark lower/faster).

| c | MTP tok/s/user | **DSpark tok/s/user** | Δ% tok/s/user | MTP TTFT (ms) | **DSpark TTFT (ms)** | Δ% TTFT | MTP ITL (ms) | **DSpark ITL (ms)** | Δ% ITL | MTP req latency (ms) | **DSpark req latency (ms)** | Δ% req latency |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 4 | 118.57 | **136.34** | +15 | 733.78 | **625.19** | -15 | 8.51 | **7.45** | -12 | 24119.70 | **24666.53** | +2 |
| 8 | 107.42 | **139.07** | +29 | 697.24 | **522.14** | -25 | 9.39 | **7.28** | -22 | 27195.12 | **20533.27** | -24 |
| 16 | 94.76 | **125.24** | +32 | 653.52 | **491.84** | -25 | 10.63 | **8.09** | -24 | 33651.84 | **24513.02** | -27 |
| 32 | 90.67 | **109.91** | +21 | 587.75 | **502.46** | -15 | 11.15 | **9.39** | -16 | 35500.22 | **32869.00** | -7 |
| 64 | 79.30 | **76.96** | -3 | 1082.01 | **2506.72** | +132 | 13.00 | **17.27** | +33 | 44734.51 | **60392.83** | +35 |
| 128 | 64.31 | **56.97** | -11 | 1844.17 | **13198.77** | +616 | 16.79 | **47.28** | +182 | 61040.37 | **125236.17** | +105 |
| 256 | 50.14 | **53.75** | +7 | 1475.12 | **46083.61** | +3024 | 20.84 | **61.55** | +195 | 71006.21 | **188352.75** | +165 |
| 512 | 56.14 | **55.81** | -1 | 12405.85 | **22215.88** | +79 | 20.73 | **54.25** | +162 | 83477.43 | **151671.94** | +82 |

Raw CSV: [`summary.csv`](sweeps/glm52-fp8-pd-mtp-dspark-20260901/datasets/spec-al-math500/summary.csv) · [`comparison.csv`](sweeps/glm52-fp8-pd-mtp-dspark-20260901/datasets/spec-al-math500/comparison.csv)

## spec-al-humaneval

### Dataset

| Field | Value |
|---|---|
| aiperf `--public-dataset` | `spec-al-humaneval` |
| HuggingFace source | `openai/openai_humaneval` (test) |
| Prompts in dataset | 164 |
| Turns | single |
| License | MIT |
| Warmup per cell | 16 requests (excluded from stats) |
| Profiled requests per cell | `max(concurrency × 8, 100)`, capped at dataset size |
| Measured ISL (avg, c=4) | 138.36 tokens |
| Measured OSL (avg, c=4) | 4391.63 tokens |
| Notes | HumanEval code; served via chat template (differs from raw completion in papers). |

### Throughput & latency

One row per **method** at each **concurrency** (MTP then DSpark).

| c | method | exit | n_req | tok/s/user | tok/s (cluster) | tok/s/gpu | TTFT (ms) | ITL (ms) | req latency (ms) | ISL (tokens) | OSL (tokens) |
|---:|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 4 | MTP | 0 | 100 | 106.52 | 384.76 | 24.05 | 653.28 | 9.46 | 44377.72 | 138.36 | 4391.63 |
| 4 | **DSpark** | 0 | 100 | **121.39** | **444.40** | **27.77** | **470.94** | **8.34** | **27496.52** | 138.36 | **3074.21** |
| 8 | MTP | 0 | 100 | 97.03 | 608.19 | 38.01 | 701.11 | 10.39 | 38814.04 | 138.36 | 3813.36 |
| 8 | **DSpark** | 0 | 100 | **108.58** | **691.02** | **43.19** | **509.27** | **9.31** | **32018.31** | 138.36 | **3223.60** |
| 16 | MTP | 0 | 128 | 87.20 | 871.02 | 54.44 | 977.67 | 11.61 | 63527.88 | 146.27 | 5367.05 |
| 16 | **DSpark** | 0 | 128 | **98.28** | **830.66** | **51.92** | **480.98** | **10.35** | **44738.58** | 146.27 | **3937.70** |
| 32 | MTP | 0 | 164 | 79.57 | 885.40 | 55.34 | 1082.89 | 12.91 | 64746.64 | 143.41 | 4636.96 |
| 32 | **DSpark** | 0 | 164 | **88.42** | **929.31** | **58.08** | **541.97** | **11.98** | **57581.42** | 143.41 | **3910.59** |
| 64 | MTP | 0 | 164 | 67.97 | 942.78 | 58.92 | 1728.30 | 15.46 | 65427.42 | 143.41 | 4540.93 |
| 64 | **DSpark** | 0 | 164 | **81.13** | **882.05** | **55.13** | **583.18** | **12.76** | **69293.17** | 143.41 | **4352.08** |
| 128 | MTP | 0 | 164 | 65.60 | 717.72 | 44.86 | 1422.31 | 15.39 | 72097.76 | 143.41 | 4962.37 |
| 128 | **DSpark** | 0 | 164 | **71.98** | **1140.58** | **71.29** | **818.65** | **14.47** | **60877.10** | 143.41 | **3721.65** |
| 256 | MTP | 0 | 164 | 68.21 | 1054.20 | 65.89 | 3139.44 | 14.78 | 61257.59 | 143.41 | 4468.90 |
| 256 | **DSpark** | 0 | 164 | **71.03** | **1076.39** | **67.27** | **1635.81** | **14.25** | **56875.09** | 143.41 | **3879.45** |
| 512 | MTP | 0 | 164 | 61.35 | 1038.10 | 64.88 | 1291.41 | 16.63 | 58848.76 | 143.41 | 4400.35 |
| 512 | **DSpark** | 0 | 164 | **68.17** | **1010.04** | **63.13** | **2891.61** | **15.23** | **59766.78** | 143.41 | **3541.68** |

### MTP vs DSpark comparison

One row per **concurrency**. Each **Δ%** = `(DSpark − MTP) / MTP × 100` (negative on latency = DSpark lower/faster).

| c | MTP tok/s/user | **DSpark tok/s/user** | Δ% tok/s/user | MTP TTFT (ms) | **DSpark TTFT (ms)** | Δ% TTFT | MTP ITL (ms) | **DSpark ITL (ms)** | Δ% ITL | MTP req latency (ms) | **DSpark req latency (ms)** | Δ% req latency |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 4 | 106.52 | **121.39** | +14 | 653.28 | **470.94** | -28 | 9.46 | **8.34** | -12 | 44377.72 | **27496.52** | -38 |
| 8 | 97.03 | **108.58** | +12 | 701.11 | **509.27** | -27 | 10.39 | **9.31** | -10 | 38814.04 | **32018.31** | -18 |
| 16 | 87.20 | **98.28** | +13 | 977.67 | **480.98** | -51 | 11.61 | **10.35** | -11 | 63527.88 | **44738.58** | -30 |
| 32 | 79.57 | **88.42** | +11 | 1082.89 | **541.97** | -50 | 12.91 | **11.98** | -7 | 64746.64 | **57581.42** | -11 |
| 64 | 67.97 | **81.13** | +19 | 1728.30 | **583.18** | -66 | 15.46 | **12.76** | -17 | 65427.42 | **69293.17** | +6 |
| 128 | 65.60 | **71.98** | +10 | 1422.31 | **818.65** | -42 | 15.39 | **14.47** | -6 | 72097.76 | **60877.10** | -16 |
| 256 | 68.21 | **71.03** | +4 | 3139.44 | **1635.81** | -48 | 14.78 | **14.25** | -4 | 61257.59 | **56875.09** | -7 |
| 512 | 61.35 | **68.17** | +11 | 1291.41 | **2891.61** | +124 | 16.63 | **15.23** | -8 | 58848.76 | **59766.78** | +2 |

Raw CSV: [`summary.csv`](sweeps/glm52-fp8-pd-mtp-dspark-20260901/datasets/spec-al-humaneval/summary.csv) · [`comparison.csv`](sweeps/glm52-fp8-pd-mtp-dspark-20260901/datasets/spec-al-humaneval/comparison.csv)

