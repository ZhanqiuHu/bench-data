# GLM-5.3 H200 TP8→TP8 MTP3 offload512 e85fix-v2

This directory is a self-contained, immutable copy of the 2026-09-19 runs. It records observed data and raw output without replacing earlier experiments.

## Data validity status

| Data | Status |
|---|---|
| OpenHands, all four points | Valid: every request completed successfully |
| AgentX completed throughput and saturation evidence | Usable only with the sent/completed/in-flight counts below |
| AgentX c16/c32/c64 latency percentiles | Censored: 13/36/108 requests remained in flight at forced phase completion |
| Formal PCP-versus-TP8 comparison | Not available: the existing PCP and TP8 runs used different runtime builds |

Do not use the AgentX c32/c64 P95 or P99 values as complete tail-latency
measurements. The runner stopped sending at the 1800-second deadline, then
timed out and force-ended outstanding credits instead of draining every request.
The raw data is retained so the termination behavior remains auditable.

## Identity

| Field | Value |
|---|---|
| Model | `zhu-glm53-h200-e85fix-v2-tp8-tp8-mtp3-offload512` |
| Manifest | `p1-tp8ep-d1-tp8ep-mtp3-offload512-e85fix-v2-zhu` |
| Prefill | 8×H200, TP8 + EP, MTP3, CPU KV offload 512 GiB |
| Decode | 8×H200, TP8 + EP, MTP3, CPU KV offload 512 GiB |
| Runtime base | `/workspace/vdptest/vllm-main-20260914T180020Z-e85c8826` |
| Runtime change | `e85c8826-nixl-diag-stale-peer-fix-runtime-v2.patch` |

The exact manifest, environment, runtime patch, runner scripts, and sweep scripts used or retained for reproduction are in `config/`.

## Runs

| Workload | Run ID | Points | Result |
|---|---|---|---|
| OpenHands / EvalScope | `20260919T181450Z-e85fix-v2-tp8-control` | parallel/total samples `1/4`, `2/8`, `4/8`, `8/16` | all requests successful; all four reports generated |
| AgentX / AIPerf | `20260919T182534Z-e85fix-v2-tp8-control` | concurrency `16`, `32`, `64`; 1800 s profiling each | all three exports generated; see forced phase-end warning below |

Exact aggregate values are in:

- `openhands-summary.csv`
- `agentx-summary.csv`

## Raw data

- `openhands/`: full copied OpenHands result tree, including the four SQLite databases, benchmark JSON files, HTML reports, performance summaries, client logs, and server logs.
- `agentx/`: full copied AgentX result tree, including AIPerf CSV/JSON, per-request profiler JSONL, server metrics, run metadata, manifests, client logs, and server logs.
- `independent-client-raw/`: independent raw stdout captures for the three AgentX client pods.
- `openhands-controller.log`: original OpenHands controller output.
- `agentx-controller.log`: original AgentX controller output.
- `SHA256SUMS`: SHA-256 checksums for the copied archive.

At archive creation there were 125 checksummed files and the checksum verification passed.

The c16 decoder live log was 131,291,746 bytes, above GitHub's single-file
limit. The archive stores it losslessly as `.log.gz`. Its original and
decompressed SHA-256 are both
`d15b7fb7e11b27f0eab0b9cbe9a2faf286f55a4ff4a169d71e41945fbee6111b`.
The uncompressed source remains in the original `agentx-mvp` result tree.

## Recorded warnings and errors

All three AgentX points reached the profiling deadline with requests still in flight. Raw client output records:

```text
Phase profiling timed out, cancelling all credits.
Timeout waiting 10.0s for cancelled credits to return. Some credits may be stuck. Forcing phase completion.
```

The in-flight counts were 13 at c16, 36 at c32, and 108 at c64. The exported `error_summary` is empty and `was_cancelled` is false for all three completed-result JSON files. These in-flight requests are not counted in `completed_requests`.

After the c64 final copy, the controller records:

```text
2026-09-19T20:23:50Z zhu-sweep: c=64 done in 2656s
scripts/zhu-sweep.sh: line 307: syntax error near unexpected token `exit'
```

All three point-level `run_meta.json` files contain `exit_code: 0`; the aggregate controller did not print its final `OK` line. The archived raw controller log is authoritative.
