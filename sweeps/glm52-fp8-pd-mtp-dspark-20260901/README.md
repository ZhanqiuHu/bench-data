# Sweep: glm52-fp8-pd-mtp-dspark-20260901

**Model:** `zai-org/GLM-5.2-FP8` · **Topology:** P/D 1×8 prefill + 1×8 decode (16× H200)  
**Client:** aiperf 0.12 · **Concurrency:** 4, 8, 16, 32, 64, 128, 256, 512

## Datasets

| Dataset | Path | Pair complete |
|---------|------|:-------------:|
| spec-al-math500 | [`datasets/spec-al-math500/`](datasets/spec-al-math500/) | ✅ |
| spec-al-humaneval | [`datasets/spec-al-humaneval/`](datasets/spec-al-humaneval/) | ✅ |
| spec-al-mbpp | [`datasets/spec-al-mbpp/`](datasets/spec-al-mbpp/) | ❌ (DSpark only) |

See [`STATUS.md`](STATUS.md) for gaps (gsm8k, mtbench, spec-bench, P4 not run).
