# GLM-5.3 H200 TP8→TP8 MTP3 offload512 e85fix-v2

## Published result status

This directory publishes the valid OpenHands run only.

| Workload | Run ID | Status |
|---|---|---|
| OpenHands / EvalScope | `20260919T181450Z-e85fix-v2-tp8-control` | valid; all requests completed at all four points |
| AgentX / AIPerf | — | not published; the attempted run did not drain outstanding requests and must be rerun |

Do not use commit `fc80cb5` or `a6870c2` as a source of AgentX performance
numbers. Those commits retained a diagnostic run whose latency distribution was
censored. The current tree removes that run from the published result set.

## Configuration

| Field | Value |
|---|---|
| Model | `zhu-glm53-h200-e85fix-v2-tp8-tp8-mtp3-offload512` |
| Manifest | `p1-tp8ep-d1-tp8ep-mtp3-offload512-e85fix-v2-zhu` |
| Prefill | 8×H200, TP8 + EP, MTP3, CPU KV offload 512 GiB |
| Decode | 8×H200, TP8 + EP, MTP3, CPU KV offload 512 GiB |
| Runtime base | `/workspace/vdptest/vllm-main-20260914T180020Z-e85c8826` |
| Runtime patch | `e85c8826-nixl-diag-stale-peer-fix-runtime-v2.patch` |

## OpenHands results

| Parallel | Samples | Requests | Success | RPS | Avg latency (s) | P99 latency (s) | Avg TTFT (ms) | P99 TTFT (ms) | Output tok/s | Decode tok/s | Spec accept rate |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | 4 | 52 | 100% | 0.36 | 2.759 | 12.540 | 1174.1 | 10538.5 | 79.72 | 138.31 | 73.6% |
| 2 | 8 | 104 | 100% | 0.63 | 3.141 | 13.560 | 1406.5 | 11532.4 | 137.54 | 126.26 | 73.2% |
| 4 | 8 | 104 | 100% | 1.38 | 2.815 | 4.160 | 814.7 | 1707.0 | 303.86 | 109.41 | 74.3% |
| 8 | 16 | 208 | 100% | 1.23 | 6.444 | 70.720 | 4247.5 | 68328.6 | 270.45 | 99.70 | 73.4% |

Exact machine-readable aggregate values are in `openhands-summary.csv`.

## Included files

- `openhands/`: the complete four-point result tree, including SQLite request
  data, benchmark summaries and percentiles, HTML reports, client output, and
  server logs.
- `openhands-controller.log`: original controller output.
- `openhands-summary.csv`: exact aggregate values copied from the four final
  benchmark summaries.
- `config/`: the manifest, runtime environment, patch and OpenHands runner used
  for this run.
- `SHA256SUMS`: checksums for the current published files.

The incomplete AgentX attempt remains in the local diagnostic archive and is
not part of this published benchmark result.
