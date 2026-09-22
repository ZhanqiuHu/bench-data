# GLM-5.3 H200 PD PCP8+DCP8→TP8 MTP3 offload512: OpenHands + AgentX

## Published result status

This directory publishes the completed OpenHands and AgentX runs.

| Workload | Date | Status |
|---|---|---|
| OpenHands / EvalScope | 2026-09-16 | valid; all requests completed at all four points |
| AgentX / AIPerf | 2026-09-22 | valid; complete wire drain at c16, c32, and c64 |

## Configuration

| Field | Value |
|---|---|
| Prefill | 8×H200, TP1 + PCP8 + DCP8 + EP |
| Decode | 8×H200, TP8 + EP + MTP3 |
| CPU KV offload | 512 GiB |
| vLLM commit | `1f6a41a1771bf62d30401eb14a327ce020f573a4` |

## OpenHands results

Each completed conversation makes 13 sequential LLM API calls. Conversation
parallelism is therefore different from the number of model calls.

| Max concurrent conversations | Completed conversations | Model API calls | Successful model calls | Model calls/s | Avg call latency (s) | Output tok/s | Avg TTFT (ms) | Avg TPOT (ms) | Avg ITL (ms) |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | 4 | 52 | 52 | 0.3888 | 2.5712 | 85.5254 | 960.95 | 7.35 | 27.43 |
| 2 | 8 | 104 | 104 | 0.7092 | 2.7868 | 156.0275 | 1028.23 | 8.03 | 29.52 |
| 4 | 8 | 104 | 104 | 1.3892 | 2.7997 | 305.6148 | 823.49 | 9.02 | 34.20 |
| 8 | 16 | 208 | 208 | 1.7390 | 4.4960 | 382.5874 | 2194.63 | 10.51 | 40.92 |

## AgentX results

| Concurrency | Profiling records | Cancelled | Errors | Requests/s | Input tok/s | Output tok/s | Avg TTFT (s) | Avg E2E (s) |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 16 | 1,129 | 0 | 0 | 0.5193 | 37,401.1 | 459.0 | 16.11 | 31.78 |
| 32 | 1,001 | 0 | 0 | 0.2781 | 18,273.5 | 264.6 | 59.87 | 77.94 |
| 64 | 1,256 | 0 | 0 | 0.3489 | 20,468.1 | 301.2 | 130.08 | 146.84 |

For every point, the runner exited 0, the summary request count equals the
profiling JSONL record count, cancelled requests are 0, `error_summary` is
empty, `was_cancelled` is false, and the log records `All results received`.

## Included files

- `openhands/raw/`: complete four-point OpenHands output, including SQLite
  request data, benchmark summaries and percentiles, HTML reports, client logs,
  and server logs.
- `openhands/controller.log`: original OpenHands controller output.
- `agentx/raw/c16`, `agentx/raw/c32`, `agentx/raw/c64`: complete AIPerf exports,
  JSONL request records, server metrics, logs, and drain validation.
