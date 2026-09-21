# GLM-5.3 H200 PD TP8→TP8 MTP3 offload512 OpenHands

## Published result status

This directory publishes the valid OpenHands run only.

| Workload | Run ID | Status |
|---|---|---|
| OpenHands / EvalScope | 2026-09-19 | valid; all requests completed at all four points |
| AgentX / AIPerf | — | not published; the attempted run did not drain outstanding requests and must be rerun |

No AgentX performance numbers are published in this directory.

## Configuration

| Field | Value |
|---|---|
| Prefill | 8×H200, TP8 + EP, MTP3, CPU KV offload 512 GiB |
| Decode | 8×H200, TP8 + EP, MTP3, CPU KV offload 512 GiB |
| vLLM commit | `1f6a41a1771bf62d30401eb14a327ce020f573a4` |
| Runtime change | NIXL stale-peer recovery patch for prefiller restart/re-handshake |

The exact internal model name, manifest name, runtime path and patch are kept
under `config/` for reproduction; they are not names for the experiment itself.

## OpenHands results

Each completed conversation makes 13 sequential LLM API calls. Conversation
parallelism is therefore different from the number of model calls.

| Max concurrent conversations | Completed conversations | Model API calls | Successful model calls | Model calls/s | Avg call latency (s) | P99 call latency (s) | Avg TTFT (ms) | P99 TTFT (ms) | Output tok/s | Decode tok/s | Spec accept rate |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | 4 | 52 | 52 | 0.36 | 2.759 | 12.540 | 1174.1 | 10538.5 | 79.72 | 138.31 | 73.6% |
| 2 | 8 | 104 | 104 | 0.63 | 3.141 | 13.560 | 1406.5 | 11532.4 | 137.54 | 126.26 | 73.2% |
| 4 | 8 | 104 | 104 | 1.38 | 2.815 | 4.160 | 814.7 | 1707.0 | 303.86 | 109.41 | 74.3% |
| 8 | 16 | 208 | 208 | 1.23 | 6.444 | 70.720 | 4247.5 | 68328.6 | 270.45 | 99.70 | 73.4% |

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
