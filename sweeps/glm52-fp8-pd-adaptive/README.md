# glm52-fp8-pd-adaptive

GLM-5.2-FP8 · DSpark adaptive verification (`enable_adaptive_verification=true`).

| Item | Value |
|---|---|
| GPUs | 16× H200 |
| Image | `nightly-a9a17e70` + Hopper sparse MLA patch |
| Spec | decode k=7, prefill k=1, adaptive verification ON |
| Run date | 2026-09-03 overnight |
| **Acceptance** | **NOT INCLUDED** (decode logs not saved — rerun required) |
| Baseline compare | DSpark fair from `glm52-fp8-pd-mtp-dspark` |

## spec-al-math500

> **Acceptance (mal, per_pos): NOT PUBLISHED** — decode logs missing; throughput only.

### Throughput & latency (DSpark adaptive)

| c | method | exit | tok/s/user | tok/s (cluster) | tok/s/gpu | TTFT (ms) | ITL (ms) | req latency (ms) |
|---:|---|---:|---:|---:|---:|---:|---:|---:|
| 4 | **DSpark adaptive** | 0 | 128.72 | 482.09 | 30.13 | 569.49 | 7.85 | 14507.44 |
| 8 | **DSpark adaptive** | 0 | 148.95 | 1057.94 | 66.12 | 503.68 | 6.84 | 12386.31 |
| 16 | **DSpark adaptive** | 0 | 140.23 | 1778.89 | 111.18 | 518.29 | 7.19 | 13798.26 |
| 32 | **DSpark adaptive** | 0 | 125.41 | 3248.03 | 203.00 | 538.79 | 8.07 | 15991.84 |
| 64 | **DSpark adaptive** | 0 | 107.68 | 5405.29 | 337.83 | 843.33 | 9.42 | 19490.19 |
| 128 | **DSpark adaptive** | 0 | 70.82 | 7518.19 | 469.89 | 810.78 | 14.81 | 29618.18 |
| 256 | **DSpark adaptive** | 0 | 68.74 | 8557.49 | 534.84 | 19405.89 | 17.34 | 51857.54 |
| 512 | **DSpark adaptive** | 0 | 60.96 | 8236.83 | 514.80 | 61720.51 | 26.71 | 109329.00 |

### DSpark fair vs adaptive (throughput only)

| c | DSpark fair tok/s/user | **Adaptive tok/s/user** | Δ% vs fair | fair TTFT | adaptive TTFT | fair ITL | adaptive ITL |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 4 | 173.38 | **128.72** | -25.8 | 486.45 | 569.49 | 5.81 | 7.85 |
| 8 | 157.58 | **148.95** | -5.5 | 519.57 | 503.68 | 6.39 | 6.84 |
| 16 | 140.33 | **140.23** | -0.1 | 515.50 | 518.29 | 7.18 | 7.19 |
| 32 | 128.90 | **125.41** | -2.7 | 545.66 | 538.79 | 7.83 | 8.07 |
| 64 | 117.29 | **107.68** | -8.2 | 844.84 | 843.33 | 8.60 | 9.42 |
| 128 | 90.76 | **70.82** | -22.0 | 1270.71 | 810.78 | 11.36 | 14.81 |
| 256 | 76.24 | **68.74** | -9.8 | 17727.72 | 19405.89 | 14.86 | 17.34 |
| 512 | 66.92 | **60.96** | -8.9 | 57291.79 | 61720.51 | 23.54 | 26.71 |

Raw CSV: [`summary.csv`](datasets/spec-al-math500/summary.csv) · [`comparison.csv`](datasets/spec-al-math500/comparison.csv)

## spec-al-humaneval

> **Acceptance (mal, per_pos): NOT PUBLISHED** — decode logs missing; throughput only.

### Throughput & latency (DSpark adaptive)

| c | method | exit | tok/s/user | tok/s (cluster) | tok/s/gpu | TTFT (ms) | ITL (ms) | req latency (ms) |
|---:|---|---:|---:|---:|---:|---:|---:|---:|
| 4 | **DSpark adaptive** | 0 | 139.80 | 480.07 | 30.00 | 477.69 | 7.23 | 11964.78 |
| 8 | **DSpark adaptive** | 0 | 127.43 | 807.87 | 50.49 | 523.33 | 7.94 | 13400.39 |
| 16 | **DSpark adaptive** | 0 | 113.32 | 1445.26 | 90.33 | 522.46 | 8.94 | 16722.05 |
| 32 | **DSpark adaptive** | 0 | 98.70 | 2483.55 | 155.22 | 514.22 | 10.28 | 17273.87 |
| 64 | **DSpark adaptive** | 0 | 87.22 | 4272.54 | 267.03 | 558.44 | 11.64 | 19915.09 |
| 128 | **DSpark adaptive** | 0 | 66.16 | 6389.53 | 399.35 | 761.13 | 16.04 | 28136.06 |
| 256 | **DSpark adaptive** | 0 | 48.84 | 5751.19 | 359.45 | 23588.61 | 24.65 | 63873.98 |
| 512 | **DSpark adaptive** | 0 | 43.72 | 5433.03 | 339.56 | 77086.10 | 40.80 | 137455.71 |

### DSpark fair vs adaptive (throughput only)

| c | DSpark fair tok/s/user | **Adaptive tok/s/user** | Δ% vs fair | fair TTFT | adaptive TTFT | fair ITL | adaptive ITL |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 4 | 141.49 | **139.80** | -1.2 | 470.49 | 477.69 | 7.14 | 7.23 |
| 8 | 128.81 | **127.43** | -1.1 | 524.83 | 523.33 | 7.85 | 7.94 |
| 16 | 114.82 | **113.32** | -1.3 | 493.15 | 522.46 | 8.82 | 8.94 |
| 32 | 105.58 | **98.70** | -6.5 | 531.26 | 514.22 | 9.57 | 10.28 |
| 64 | 95.69 | **87.22** | -8.9 | 555.67 | 558.44 | 10.56 | 11.64 |
| 128 | 73.97 | **66.16** | -10.6 | 782.72 | 761.13 | 14.07 | 16.04 |
| 256 | 59.27 | **48.84** | -17.6 | 18779.17 | 23588.61 | 19.61 | 24.65 |
| 512 | 53.84 | **43.72** | -18.8 | 67065.43 | 77086.10 | 32.06 | 40.80 |

Raw CSV: [`summary.csv`](datasets/spec-al-humaneval/summary.csv) · [`comparison.csv`](datasets/spec-al-humaneval/comparison.csv)

## spec-al-gsm8k

> **Acceptance (mal, per_pos): NOT PUBLISHED** — decode logs missing; throughput only.

### Throughput & latency (DSpark adaptive)

| c | method | exit | tok/s/user | tok/s (cluster) | tok/s/gpu | TTFT (ms) | ITL (ms) | req latency (ms) |
|---:|---|---:|---:|---:|---:|---:|---:|---:|
| 4 | **DSpark adaptive** | 0 | 183.28 | 594.85 | 37.18 | 480.20 | 5.50 | 4133.15 |
| 8 | **DSpark adaptive** | 0 | 167.48 | 1002.93 | 62.68 | 528.55 | 6.02 | 4516.55 |
| 16 | **DSpark adaptive** | 0 | 148.40 | 1331.20 | 83.20 | 510.91 | 6.81 | 5688.52 |
| 32 | **DSpark adaptive** | 0 | 133.77 | 2476.88 | 154.81 | 537.60 | 7.58 | 6162.04 |
| 64 | **DSpark adaptive** | 0 | 118.09 | 4412.33 | 275.77 | 560.24 | 8.59 | 6799.90 |
| 128 | **DSpark adaptive** | 0 | 95.12 | 7738.39 | 483.65 | 621.99 | 10.72 | 8425.39 |
| 256 | **DSpark adaptive** | 0 | 102.18 | 10744.24 | 671.51 | 5459.55 | 9.94 | 12732.49 |
| 512 | **DSpark adaptive** | 0 | 101.52 | 11889.80 | 743.11 | 18144.30 | 10.01 | 25613.98 |

### DSpark fair vs adaptive (throughput only)

| c | DSpark fair tok/s/user | **Adaptive tok/s/user** | Δ% vs fair | fair TTFT | adaptive TTFT | fair ITL | adaptive ITL |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 4 | 184.34 | **183.28** | -0.6 | 555.44 | 480.20 | 5.48 | 5.50 |
| 8 | 168.17 | **167.48** | -0.4 | 531.13 | 528.55 | 6.00 | 6.02 |
| 16 | 150.62 | **148.40** | -1.5 | 656.30 | 510.91 | 6.71 | 6.81 |
| 32 | 138.10 | **133.77** | -3.1 | 718.34 | 537.60 | 7.32 | 7.58 |
| 64 | 124.89 | **118.09** | -5.4 | 790.94 | 560.24 | 8.09 | 8.59 |
| 128 | 107.38 | **95.12** | -11.4 | 1167.08 | 621.99 | 9.41 | 10.72 |
| 256 | 98.39 | **102.18** | 3.9 | 5710.13 | 5459.55 | 10.27 | 9.94 |
| 512 | 97.84 | **101.52** | 3.8 | 18586.63 | 18144.30 | 10.33 | 10.01 |

Raw CSV: [`summary.csv`](datasets/spec-al-gsm8k/summary.csv) · [`comparison.csv`](datasets/spec-al-gsm8k/comparison.csv)

## spec-al-mbpp

> **Acceptance (mal, per_pos): NOT PUBLISHED** — decode logs missing; throughput only.

### Throughput & latency (DSpark adaptive)

| c | method | exit | tok/s/user | tok/s (cluster) | tok/s/gpu | TTFT (ms) | ITL (ms) | req latency (ms) |
|---:|---|---:|---:|---:|---:|---:|---:|---:|
| 4 | **DSpark adaptive** | 0 | 124.63 | 459.40 | 28.71 | 463.98 | 8.11 | 13418.16 |
| 8 | **DSpark adaptive** | 0 | 113.55 | 782.94 | 48.93 | 521.47 | 8.91 | 14784.88 |
| 16 | **DSpark adaptive** | 0 | 100.60 | 1331.64 | 83.23 | 483.23 | 10.07 | 18323.27 |
| 32 | **DSpark adaptive** | 0 | 87.96 | 2258.30 | 141.14 | 502.84 | 11.49 | 20150.67 |
| 64 | **DSpark adaptive** | 0 | 79.17 | 4076.02 | 254.75 | 521.31 | 12.76 | 22542.84 |
| 128 | **DSpark adaptive** | 0 | 66.60 | 6594.12 | 412.13 | 648.34 | 15.61 | 27961.34 |
| 256 | **DSpark adaptive** | 0 | 49.96 | 6031.00 | 376.94 | 24230.35 | 22.03 | 61889.06 |
| 512 | **DSpark adaptive** | 0 | 45.36 | 5935.39 | 370.96 | 79729.17 | 31.17 | 130114.76 |

### DSpark fair vs adaptive (throughput only)

| c | DSpark fair tok/s/user | **Adaptive tok/s/user** | Δ% vs fair | fair TTFT | adaptive TTFT | fair ITL | adaptive ITL |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 4 | 127.90 | **124.63** | -2.6 | 500.91 | 463.98 | 7.90 | 8.11 |
| 8 | 116.18 | **113.55** | -2.3 | 504.64 | 521.47 | 8.70 | 8.91 |
| 16 | 103.80 | **100.60** | -3.1 | 490.78 | 483.23 | 9.73 | 10.07 |
| 32 | 96.10 | **87.96** | -8.5 | 518.60 | 502.84 | 10.51 | 11.49 |
| 64 | 87.03 | **79.17** | -9.0 | 534.58 | 521.31 | 11.60 | 12.76 |
| 128 | 68.92 | **66.60** | -3.4 | 672.88 | 648.34 | 14.89 | 15.61 |
| 256 | 58.62 | **49.96** | -14.8 | 19707.52 | 24230.35 | 18.89 | 22.03 |
| 512 | 52.44 | **45.36** | -13.5 | 70185.21 | 79729.17 | 27.25 | 31.17 |

Raw CSV: [`summary.csv`](datasets/spec-al-mbpp/summary.csv) · [`comparison.csv`](datasets/spec-al-mbpp/comparison.csv)

## spec-al-mtbench

> **Acceptance (mal, per_pos): NOT PUBLISHED** — decode logs missing; throughput only.

### Throughput & latency (DSpark adaptive)

| c | method | exit | tok/s/user | tok/s (cluster) | tok/s/gpu | TTFT (ms) | ITL (ms) | req latency (ms) |
|---:|---|---:|---:|---:|---:|---:|---:|---:|
| 4 | **DSpark adaptive** | 0 | 122.99 | 411.19 | 25.70 | 586.06 | 8.85 | 15655.50 |
| 8 | **DSpark adaptive** | 0 | 111.25 | 709.45 | 44.34 | 638.07 | 9.76 | 17264.96 |
| 16 | **DSpark adaptive** | 0 | 98.74 | 1235.65 | 77.23 | 612.38 | 11.04 | 19685.20 |
| 32 | **DSpark adaptive** | 0 | 88.88 | 1910.23 | 119.39 | 643.54 | 12.32 | 21613.75 |
| 64 | **DSpark adaptive** | 0 | 83.53 | 2730.33 | 170.65 | 704.66 | 13.07 | 22738.06 |
| 128 | **DSpark adaptive** | 0 | 81.08 | 2702.87 | 168.93 | 726.77 | 13.45 | 23098.25 |

### DSpark fair vs adaptive (throughput only)

| c | DSpark fair tok/s/user | **Adaptive tok/s/user** | Δ% vs fair | fair TTFT | adaptive TTFT | fair ITL | adaptive ITL |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 4 | 125.86 | **122.99** | -2.3 | 826.41 | 586.06 | 8.55 | 8.85 |
| 8 | 113.34 | **111.25** | -1.8 | 632.51 | 638.07 | 9.51 | 9.76 |
| 16 | 101.61 | **98.74** | -2.8 | 643.81 | 612.38 | 10.64 | 11.04 |
| 32 | 94.34 | **88.88** | -5.8 | 718.50 | 643.54 | 11.44 | 12.32 |
| 64 | 86.37 | **83.53** | -3.3 | 789.41 | 704.66 | 12.52 | 13.07 |
| 128 | 83.98 | **81.08** | -3.5 | 747.88 | 726.77 | 12.81 | 13.45 |

Raw CSV: [`summary.csv`](datasets/spec-al-mtbench/summary.csv) · [`comparison.csv`](datasets/spec-al-mtbench/comparison.csv)

## spec-bench

> **Acceptance (mal, per_pos): NOT PUBLISHED** — decode logs missing; throughput only.

### Throughput & latency (DSpark adaptive)

| c | method | exit | tok/s/user | tok/s (cluster) | tok/s/gpu | TTFT (ms) | ITL (ms) | req latency (ms) |
|---:|---|---:|---:|---:|---:|---:|---:|---:|
| 4 | **DSpark adaptive** | 0 | 127.60 | 444.63 | 27.79 | 467.08 | 8.27 | 13226.11 |
| 8 | **DSpark adaptive** | 0 | 115.19 | 769.91 | 48.12 | 538.65 | 9.15 | 14377.46 |
| 16 | **DSpark adaptive** | 0 | 102.24 | 1287.43 | 80.46 | 524.25 | 10.24 | 15416.04 |
| 32 | **DSpark adaptive** | 0 | 86.40 | 2074.39 | 129.65 | 525.35 | 11.97 | 15013.76 |
| 64 | **DSpark adaptive** | 0 | 87.35 | 3721.28 | 232.58 | 556.48 | 12.24 | 14873.61 |
| 128 | **DSpark adaptive** | 0 | 78.46 | 6776.88 | 423.56 | 587.72 | 13.62 | 16664.48 |
| 256 | **DSpark adaptive** | 0 | 69.31 | 7696.30 | 481.02 | 12901.50 | 15.74 | 30998.46 |
| 512 | **DSpark adaptive** | 0 | 56.47 | 7167.71 | 447.98 | 42749.44 | 24.76 | 69469.26 |

### DSpark fair vs adaptive (throughput only)

| c | DSpark fair tok/s/user | **Adaptive tok/s/user** | Δ% vs fair | fair TTFT | adaptive TTFT | fair ITL | adaptive ITL |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 4 | 130.28 | **127.60** | -2.1 | 475.45 | 467.08 | 8.08 | 8.27 |
| 8 | 117.69 | **115.19** | -2.1 | 520.19 | 538.65 | 8.91 | 9.15 |
| 16 | 104.92 | **102.24** | -2.6 | 514.48 | 524.25 | 9.96 | 10.24 |
| 32 | 92.45 | **86.40** | -6.5 | 552.34 | 525.35 | 11.14 | 11.97 |
| 64 | 92.74 | **87.35** | -5.8 | 579.44 | 556.48 | 11.38 | 12.24 |
| 128 | 79.31 | **78.46** | -1.1 | 619.88 | 587.72 | 13.32 | 13.62 |
| 256 | 72.11 | **69.31** | -3.9 | 12110.22 | 12901.50 | 14.68 | 15.74 |
| 512 | 62.72 | **56.47** | -10.0 | 38863.40 | 42749.44 | 21.68 | 24.76 |

Raw CSV: [`summary.csv`](datasets/spec-bench/summary.csv) · [`comparison.csv`](datasets/spec-bench/comparison.csv)

## synthetic-chat

> **Acceptance (mal, per_pos): NOT PUBLISHED** — decode logs missing; throughput only.

### Throughput & latency (DSpark adaptive)

| c | method | exit | tok/s/user | tok/s (cluster) | tok/s/gpu | TTFT (ms) | ITL (ms) | req latency (ms) |
|---:|---|---:|---:|---:|---:|---:|---:|---:|
| 4 | **DSpark adaptive** | 0 | 110.42 | 403.70 | 25.23 | 670.21 | 9.25 | 9661.02 |
| 8 | **DSpark adaptive** | 0 | 100.68 | 707.58 | 44.22 | 745.76 | 10.24 | 10378.07 |
| 16 | **DSpark adaptive** | 0 | 89.71 | 1237.11 | 77.32 | 725.88 | 11.49 | 11680.23 |
| 32 | **DSpark adaptive** | 0 | 80.77 | 2198.51 | 137.41 | 754.98 | 12.82 | 12925.36 |
| 64 | **DSpark adaptive** | 0 | 73.37 | 3966.28 | 247.89 | 846.12 | 14.05 | 14428.85 |
| 128 | **DSpark adaptive** | 0 | 65.62 | 7176.94 | 448.56 | 1025.36 | 15.71 | 16204.72 |
| 256 | **DSpark adaptive** | 0 | 40.32 | 5191.94 | 324.50 | 18536.64 | 28.12 | 45619.39 |
| 512 | **DSpark adaptive** | 0 | 40.13 | 5364.51 | 335.28 | 60809.55 | 28.19 | 87743.85 |

### DSpark fair vs adaptive (throughput only)

| c | DSpark fair tok/s/user | **Adaptive tok/s/user** | Δ% vs fair | fair TTFT | adaptive TTFT | fair ITL | adaptive ITL |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 4 | 114.95 | **110.42** | -3.9 | 723.08 | 670.21 | 8.95 | 9.25 |
| 8 | 104.69 | **100.68** | -3.8 | 720.32 | 745.76 | 9.76 | 10.24 |
| 16 | 92.30 | **89.71** | -2.8 | 914.56 | 725.88 | 11.06 | 11.49 |
| 32 | 85.33 | **80.77** | -5.3 | 804.77 | 754.98 | 12.02 | 12.82 |
| 64 | 75.32 | **73.37** | -2.6 | 939.23 | 846.12 | 13.67 | 14.05 |
| 128 | 61.61 | **65.62** | 6.5 | 1163.47 | 1025.36 | 16.73 | 15.71 |
| 256 | 41.62 | **40.32** | -3.1 | 17483.95 | 18536.64 | 27.19 | 28.12 |
| 512 | 42.75 | **40.13** | -6.1 | 58048.00 | 60809.55 | 26.53 | 28.19 |

Raw CSV: [`summary.csv`](datasets/synthetic-chat/summary.csv) · [`comparison.csv`](datasets/synthetic-chat/comparison.csv)

## synthetic-reasoning

> **Acceptance (mal, per_pos): NOT PUBLISHED** — decode logs missing; throughput only.

### Throughput & latency (DSpark adaptive)

| c | method | exit | tok/s/user | tok/s (cluster) | tok/s/gpu | TTFT (ms) | ITL (ms) | req latency (ms) |
|---:|---|---:|---:|---:|---:|---:|---:|---:|
| 4 | **DSpark adaptive** | 0 | 121.14 | 493.40 | 30.84 | 653.67 | 8.71 | 27485.97 |
| 8 | **DSpark adaptive** | 0 | 115.08 | 930.31 | 58.14 | 693.72 | 9.34 | 29550.97 |
| 16 | **DSpark adaptive** | 0 | 96.10 | 1408.32 | 88.02 | 700.76 | 11.14 | 31011.12 |
| 32 | **DSpark adaptive** | 0 | 83.83 | 2408.26 | 150.52 | 735.73 | 12.79 | 35996.66 |
| 64 | **DSpark adaptive** | 0 | 61.42 | 3600.91 | 225.06 | 1082.20 | 17.95 | 53373.48 |
| 128 | **DSpark adaptive** | 0 | 28.68 | 2867.20 | 179.20 | 19121.38 | 47.00 | 136037.01 |
| 256 | **DSpark adaptive** | 0 | 26.07 | 2914.96 | 182.19 | 136372.88 | 54.62 | 266062.59 |
| 512 | **DSpark adaptive** | 0 | 25.72 | 2950.16 | 184.38 | 402105.54 | 55.17 | 532514.69 |

### DSpark fair vs adaptive (throughput only)

| c | DSpark fair tok/s/user | **Adaptive tok/s/user** | Δ% vs fair | fair TTFT | adaptive TTFT | fair ITL | adaptive ITL |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 4 | 127.72 | **121.14** | -5.2 | 653.37 | 653.67 | 8.25 | 8.71 |
| 8 | 110.44 | **115.08** | 4.2 | 687.63 | 693.72 | 9.58 | 9.34 |
| 16 | 100.50 | **96.10** | -4.4 | 729.52 | 700.76 | 10.44 | 11.14 |
| 32 | 93.69 | **83.83** | -10.5 | 820.67 | 735.73 | 11.37 | 12.79 |
| 64 | 64.35 | **61.42** | -4.6 | 1137.71 | 1082.20 | 16.74 | 17.95 |
| 128 | 32.22 | **28.68** | -11.0 | 17671.48 | 19121.38 | 40.79 | 47.00 |
| 256 | 27.68 | **26.07** | -5.8 | 127174.84 | 136372.88 | 51.36 | 54.62 |
| 512 | 28.04 | **25.72** | -8.3 | 369337.01 | 402105.54 | 50.68 | 55.17 |

Raw CSV: [`summary.csv`](datasets/synthetic-reasoning/summary.csv) · [`comparison.csv`](datasets/synthetic-reasoning/comparison.csv)

## synthetic-summarization

> **Acceptance (mal, per_pos): NOT PUBLISHED** — decode logs missing; throughput only.

### Throughput & latency (DSpark adaptive)

| c | method | exit | tok/s/user | tok/s (cluster) | tok/s/gpu | TTFT (ms) | ITL (ms) | req latency (ms) |
|---:|---|---:|---:|---:|---:|---:|---:|---:|
| 4 | **DSpark adaptive** | 0 | 105.31 | 329.92 | 20.62 | 2173.72 | 9.76 | 11096.07 |
| 8 | **DSpark adaptive** | 0 | 94.22 | 594.14 | 37.13 | 2253.50 | 10.79 | 12299.18 |
| 16 | **DSpark adaptive** | 0 | 83.24 | 1018.82 | 63.68 | 2569.44 | 12.23 | 13857.18 |
| 32 | **DSpark adaptive** | 0 | 81.49 | 1673.68 | 104.61 | 4951.87 | 12.58 | 16569.62 |
| 64 | **DSpark adaptive** | 0 | 57.24 | 1239.66 | 77.48 | 27700.64 | 19.54 | 45677.97 |
| 128 | **DSpark adaptive** | 0 | 57.22 | 1259.06 | 78.69 | 71330.07 | 19.63 | 89213.03 |
| 256 | **DSpark adaptive** | 0 | 56.50 | 1259.71 | 78.73 | 163260.72 | 19.89 | 181622.57 |
| 512 | **DSpark adaptive** | 0 | 56.93 | 1264.71 | 79.04 | 335847.65 | 19.57 | 354007.55 |

### DSpark fair vs adaptive (throughput only)

| c | DSpark fair tok/s/user | **Adaptive tok/s/user** | Δ% vs fair | fair TTFT | adaptive TTFT | fair ITL | adaptive ITL |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 4 | 108.17 | **105.31** | -2.6 | 2246.16 | 2173.72 | 9.47 | 9.76 |
| 8 | 97.18 | **94.22** | -3.0 | 2242.48 | 2253.50 | 10.51 | 10.79 |
| 16 | 87.37 | **83.24** | -4.7 | 2677.97 | 2569.44 | 11.62 | 12.23 |
| 32 | 41.01 | **81.49** | 98.7 | 6175.47 | 4951.87 | 28.12 | 12.58 |
| 64 | 31.25 | **57.24** | 83.2 | 40443.73 | 27700.64 | 35.13 | 19.54 |
| 128 | 31.24 | **57.22** | 83.2 | 109646.41 | 71330.07 | 35.25 | 19.63 |
| 256 | 30.73 | **56.50** | 83.9 | 255327.27 | 163260.72 | 35.82 | 19.89 |
| 512 | 31.01 | **56.93** | 83.6 | 535204.45 | 335847.65 | 35.66 | 19.57 |

Raw CSV: [`summary.csv`](datasets/synthetic-summarization/summary.csv) · [`comparison.csv`](datasets/synthetic-summarization/comparison.csv)

