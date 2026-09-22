# AgentX / AIPerf results (2026-09-21–22)

| Concurrency | Profiling records | Cancelled | Errors | Requests/s | Input tok/s | Output tok/s | Avg TTFT (s) | Avg E2E (s) |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 16 | 326 | 0 | 0 | 0.1552 | 11,480.7 | 124.3 | 104.41 | 115.76 |
| 32 | 246 | 0 | 0 | 0.0683 | 4,603.6 | 110.7 | 318.06 | 340.13 |
| 64 | 397 | 0 | 0 | 0.1103 | 5,793.8 | 109.5 | 608.85 | 621.26 |

For every point, the summary request count equals the profiling JSONL record
count, cancelled requests are 0, `error_summary` is empty, `was_cancelled` is
false, and the log records `All results received`.
