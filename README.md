# bench-data

Public inference benchmark results.

**Model:** GLM-5.2-FP8 · **Topology:** P/D disagg (1×8 prefill + 1×8 decode, 16× H200) · **Client:** aiperf 0.12  
**Metric:** tok/s/user = Output Token Throughput Per User; tok/s/gpu = cluster output tok/s ÷ 16

## Sweeps

| Sweep | Date | Datasets complete | Link |
|-------|------|-------------------|------|
| glm52-fp8-pd-mtp-dspark-20260901 | 2026-09-01 | math500 ✅ humaneval ✅ mbpp (DSpark only) | [results](sweeps/glm52-fp8-pd-mtp-dspark-20260901/) |

## Coverage (glm52-fp8-pd-mtp-dspark-20260901)

| Dataset | MTP 8/8 | DSpark 8/8 | Head-to-head |
|---------|:-------:|:----------:|:------------:|
| spec-al-math500 | ✅ | ✅ fair | [table](sweeps/glm52-fp8-pd-mtp-dspark-20260901/#spec-al-math500) |
| spec-al-humaneval | ✅ | ✅ | [table](sweeps/glm52-fp8-pd-mtp-dspark-20260901/#spec-al-humaneval) |
| spec-al-mbpp | ❌ | ✅ | DSpark only |
| spec-al-gsm8k | ❌ | ❌ | not run (typo, fixed) |
| mtbench / spec-bench / P4 | ❌ | ❌ | not run |

## Headline (c=32 tok/s/user)

| Dataset | MTP | DSpark | Δ DSpark |
|---------|----:|-------:|---------:|
| spec-al-math500 | 90.67 | 109.91 | **+21%** |
| spec-al-humaneval | 79.57 | 88.42 | **+11%** |

Full per-concurrency tables → [`sweeps/glm52-fp8-pd-mtp-dspark-20260901/README.md`](sweeps/glm52-fp8-pd-mtp-dspark-20260901/README.md)

## Repo layout

```
sweeps/<sweep-id>/datasets/<dataset>/{mtp,dspark}/c{N}/profile_export_aiperf.csv
```
