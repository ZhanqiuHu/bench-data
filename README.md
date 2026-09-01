# bench-data

Public inference benchmark results.

**Model:** GLM-5.2-FP8 · **Topology:** P/D disagg (1×8 prefill + 1×8 decode, 16× H200) · **Client:** aiperf 0.12  
**Metric:** tok/s/user = Output Token Throughput Per User; tok/s/gpu = cluster output tok/s ÷ 16

Sweep: `glm52-fp8-pd-mtp-dspark-20260901` (2026-09-01) · Raw CSVs under `sweeps/glm52-fp8-pd-mtp-dspark-20260901/datasets/`

## Coverage

| Dataset | MTP | DSpark | Status |
|---------|:---:|:------:|--------|
| spec-al-math500 | 8/8 | 8/8 fair | complete pair |
| spec-al-humaneval | 8/8 | 8/8 | complete pair |
| spec-al-mbpp | — | 8/8 | DSpark only |
| spec-al-gsm8k | — | — | not run |
| mtbench / spec-bench / P4 | — | — | not run |

---

## spec-al-math500

| c | MTP tok/s/user | DSpark tok/s/user | Δ DSpark | MTP TTFT ms | DSpark TTFT ms |
|--:|---------------:|------------------:|---------:|------------:|---------------:|
| 4 | 118.57 | 136.34 | +15% | 734 | 625 |
| 8 | 107.42 | 139.07 | +30% | 697 | 522 |
| 16 | 94.76 | 125.24 | +32% | 654 | 492 |
| 32 | 90.67 | 109.91 | +21% | 588 | 502 |
| 64 | 79.30 | 76.96 | −3% | 1,082 | 2,507 |
| 128 | 64.31 | 56.97 | −11% | 1,844 | 13,199 |
| 256 | 50.14 | 53.75 | +7% | 1,475 | 46,084 |
| 512 | 56.14 | 55.81 | ~0% | 12,406 | 22,216 |

## spec-al-humaneval

| c | MTP tok/s/user | DSpark tok/s/user | Δ DSpark | MTP TTFT ms | DSpark TTFT ms |
|--:|---------------:|------------------:|---------:|------------:|---------------:|
| 4 | 106.52 | 121.39 | +14% | 653 | 471 |
| 8 | 97.03 | 108.58 | +12% | 701 | 509 |
| 16 | 87.20 | 98.28 | +13% | 978 | 481 |
| 32 | 79.57 | 88.42 | +11% | 1,083 | 542 |
| 64 | 67.97 | 81.13 | +19% | 1,728 | 583 |
| 128 | 65.60 | 71.98 | +10% | 1,422 | 819 |
| 256 | 68.21 | 71.03 | +4% | 3,139 | 1,636 |
| 512 | 61.35 | 68.17 | +11% | 1,291 | 2,892 |

## spec-al-mbpp (DSpark only)

| c | tok/s/user | tok/s/gpu | TTFT ms | ITL ms |
|--:|-----------:|----------:|--------:|-------:|
| 4 | 109.88 | 25.1 | 568 | 9.2 |
| 8 | 100.22 | 39.2 | 568 | 10.1 |
| 16 | 87.90 | 54.9 | 562 | 11.6 |
| 32 | 76.45 | 68.9 | 731 | 13.7 |
| 64 | 54.61 | 64.2 | 8,884 | 43.4 |
| 128 | 42.02 | 60.1 | 23,419 | 138.2 |
| 256 | 41.48 | 49.5 | 84,833 | 128.3 |
| 512 | 45.33 | 52.7 | 28,642 | 134.5 |
