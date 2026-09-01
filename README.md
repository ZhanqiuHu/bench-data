# bench-data

GLM-5.2-FP8 · P/D disagg (1×8 prefill + 1×8 decode, 16× H200) · aiperf 0.12

Sweep `glm52-fp8-pd-mtp-dspark-20260901` — MTP vs DSpark fair (k=5 vs k=7), concurrency 4–512.

**Complete pairs:** spec-al-math500, spec-al-humaneval (throughput only in this export).

## spec-al-math500

### Throughput & latency

| concurrency | method | exit | tok/s/user | tok/s (cluster) | tok/s/gpu | TTFT (ms) | ITL (ms) |
|---:|---|---:|---:|---:|---:|---:|---:|
| 4 | MTP | 0 | 118.57 | 389.87 | 24.37 | 733.78 | 8.51 |
| 4 | DSpark fair | 0 | 136.34 | 437.29 | 27.33 | 625.19 | 7.45 |
| 8 | MTP | 0 | 107.42 | 604.99 | 37.81 | 697.24 | 9.39 |
| 8 | DSpark fair | 0 | 139.07 | 761.26 | 47.58 | 522.14 | 7.28 |
| 16 | MTP | 0 | 94.76 | 1073.38 | 67.09 | 653.52 | 10.63 |
| 16 | DSpark fair | 0 | 125.24 | 1605.35 | 100.33 | 491.84 | 8.09 |
| 32 | MTP | 0 | 90.67 | 1807.91 | 112.99 | 587.75 | 11.15 |
| 32 | DSpark fair | 0 | 109.91 | 1987.3 | 124.21 | 502.46 | 9.39 |
| 64 | MTP | 0 | 79.30 | 2797.88 | 174.87 | 1082.01 | 13.00 |
| 64 | DSpark fair | 0 | 76.96 | 2168.96 | 135.56 | 2506.72 | 17.27 |
| 128 | MTP | 0 | 64.31 | 2668.83 | 166.8 | 1844.17 | 16.79 |
| 128 | DSpark fair | 0 | 56.97 | 2032.76 | 127.05 | 13198.77 | 47.28 |
| 256 | MTP | 0 | 50.14 | 2679.17 | 167.45 | 1475.12 | 20.84 |
| 256 | DSpark fair | 0 | 53.75 | 1704.85 | 106.55 | 46083.61 | 61.55 |
| 512 | MTP | 0 | 56.14 | 2493.78 | 155.86 | 12405.85 | 20.73 |
| 512 | DSpark fair | 0 | 55.81 | 2164.7 | 135.29 | 22215.88 | 54.25 |

### Head-to-head

| concurrency | MTP tok/s/user | DSpark tok/s/user | Δ% tok/s/user (DSpark vs MTP) | MTP TTFT (ms) | DSpark TTFT (ms) | MTP ITL (ms) | DSpark ITL (ms) |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 4 | 118.57 | 136.34 | +15% | 733.78 | 625.19 | 8.51 | 7.45 |
| 8 | 107.42 | 139.07 | +29% | 697.24 | 522.14 | 9.39 | 7.28 |
| 16 | 94.76 | 125.24 | +32% | 653.52 | 491.84 | 10.63 | 8.09 |
| 32 | 90.67 | 109.91 | +21% | 587.75 | 502.46 | 11.15 | 9.39 |
| 64 | 79.30 | 76.96 | -3% | 1082.01 | 2506.72 | 13.00 | 17.27 |
| 128 | 64.31 | 56.97 | -11% | 1844.17 | 13198.77 | 16.79 | 47.28 |
| 256 | 50.14 | 53.75 | +7% | 1475.12 | 46083.61 | 20.84 | 61.55 |
| 512 | 56.14 | 55.81 | -1% | 12405.85 | 22215.88 | 20.73 | 54.25 |

### Acceptance (mean_accept_len, per_pos, draft_accept_rate)

**Not in this export** — requires `/results/decode-logs/{mtp,dspark}/decode-full.log` on pod. Fair/MTP acceptance lost on 2026-09-01 run (decode logs not saved before swap). Rerun with patched orchestrator.

## spec-al-humaneval

### Throughput & latency

| concurrency | method | exit | tok/s/user | tok/s (cluster) | tok/s/gpu | TTFT (ms) | ITL (ms) |
|---:|---|---:|---:|---:|---:|---:|---:|
| 4 | MTP | 0 | 106.52 | 384.76 | 24.05 | 653.28 | 9.46 |
| 4 | DSpark fair | 0 | 121.39 | 444.4 | 27.77 | 470.94 | 8.34 |
| 8 | MTP | 0 | 97.03 | 608.19 | 38.01 | 701.11 | 10.39 |
| 8 | DSpark fair | 0 | 108.58 | 691.02 | 43.19 | 509.27 | 9.31 |
| 16 | MTP | 0 | 87.20 | 871.02 | 54.44 | 977.67 | 11.61 |
| 16 | DSpark fair | 0 | 98.28 | 830.66 | 51.92 | 480.98 | 10.35 |
| 32 | MTP | 0 | 79.57 | 885.4 | 55.34 | 1082.89 | 12.91 |
| 32 | DSpark fair | 0 | 88.42 | 929.31 | 58.08 | 541.97 | 11.98 |
| 64 | MTP | 0 | 67.97 | 942.78 | 58.92 | 1728.30 | 15.46 |
| 64 | DSpark fair | 0 | 81.13 | 882.05 | 55.13 | 583.18 | 12.76 |
| 128 | MTP | 0 | 65.60 | 717.72 | 44.86 | 1422.31 | 15.39 |
| 128 | DSpark fair | 0 | 71.98 | 1140.58 | 71.29 | 818.65 | 14.47 |
| 256 | MTP | 0 | 68.21 | 1054.2 | 65.89 | 3139.44 | 14.78 |
| 256 | DSpark fair | 0 | 71.03 | 1076.39 | 67.27 | 1635.81 | 14.25 |
| 512 | MTP | 0 | 61.35 | 1038.1 | 64.88 | 1291.41 | 16.63 |
| 512 | DSpark fair | 0 | 68.17 | 1010.04 | 63.13 | 2891.61 | 15.23 |

### Head-to-head

| concurrency | MTP tok/s/user | DSpark tok/s/user | Δ% tok/s/user (DSpark vs MTP) | MTP TTFT (ms) | DSpark TTFT (ms) | MTP ITL (ms) | DSpark ITL (ms) |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 4 | 106.52 | 121.39 | +14% | 653.28 | 470.94 | 9.46 | 8.34 |
| 8 | 97.03 | 108.58 | +12% | 701.11 | 509.27 | 10.39 | 9.31 |
| 16 | 87.20 | 98.28 | +13% | 977.67 | 480.98 | 11.61 | 10.35 |
| 32 | 79.57 | 88.42 | +11% | 1082.89 | 541.97 | 12.91 | 11.98 |
| 64 | 67.97 | 81.13 | +19% | 1728.30 | 583.18 | 15.46 | 12.76 |
| 128 | 65.60 | 71.98 | +10% | 1422.31 | 818.65 | 15.39 | 14.47 |
| 256 | 68.21 | 71.03 | +4% | 3139.44 | 1635.81 | 14.78 | 14.25 |
| 512 | 61.35 | 68.17 | +11% | 1291.41 | 2891.61 | 16.63 | 15.23 |

### Acceptance (mean_accept_len, per_pos, draft_accept_rate)

**Not in this export** — requires `/results/decode-logs/{mtp,dspark}/decode-full.log` on pod. Fair/MTP acceptance lost on 2026-09-01 run (decode logs not saved before swap). Rerun with patched orchestrator.

