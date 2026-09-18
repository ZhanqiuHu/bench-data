# GLM-5.3 H200 PD MTP3 offload512

## Serving configuration

| Field | Value |
|---|---|
| Model | `zhu-glm53-h200-main-pcp8dcp8-tp8-mtp3-offload512` |
| Spec | `glm-5.3/h200/p1-pcp8dcp8ep-d1-tp8ep-mtp3-offload512-zhu` |
| Prefill | 8×H200, TP1 + PCP8 + DCP8 + EP |
| Decode | 8×H200, TP8 + EP + MTP3 |
| KV offload | 512 |

## Runs

| Workload | Run ID | Points | Status |
|---|---|---|---|
| OpenHands / EvalScope | `20260916T172941Z-current-pcp8dcp8-mtp3-offload512` | parallel 1/2/4/8; samples 4/8/8/16 | complete |
| AgentX / AIPerf | `20260917T133915Z-current-pcp8dcp8-mtp3-offload512` | concurrency 16/32/64; 1800 seconds each | complete; exit code 0 for all points |

## OpenHands workload

`samples` is the number of multi-turn conversation samples executed at that point. `parallel` is the maximum number of samples running concurrently. Each sample contains 13 model-call turns.

| Point | Parallel samples | Total samples | Model-call turns |
|---|---:|---:|---:|
| c1 | 1 | 4 | 52 |
| c2 | 2 | 8 | 104 |
| c4 | 4 | 8 | 104 |
| c8 | 8 | 16 | 208 |

### OpenHands final values

All values are copied from each point's `benchmark_summary.json`.

| Metric | c1 | c2 | c4 | c8 |
|---|---:|---:|---:|---:|
| Test duration (s) | 133.7615 | 146.6408 | 74.8655 | 119.6067 |
| Concurrency | 1 | 2 | 4 | 8 |
| Configured request rate (req/s) | -1.0 | -1.0 | -1.0 | -1.0 |
| Total requests | 52 | 104 | 104 | 208 |
| Successful requests | 52 | 104 | 104 | 208 |
| Failed requests | 0 | 0 | 0 | 0 |
| Request throughput (req/s) | 0.3888 | 0.7092 | 1.3892 | 1.7390 |
| Average latency (s) | 2.5712 | 2.7868 | 2.7997 | 4.4960 |
| Average input tokens | 79830.3269 | 79803.9808 | 79743.9423 | 79616.2933 |
| Average output tokens | 220.0 | 220.0 | 220.0 | 220.0 |
| Input throughput (tok/s), reported | 0.0 | 0.0 | 0.0 | 0.0 |
| Output throughput (tok/s) | 85.5254 | 156.0275 | 305.6148 | 382.5874 |
| Total throughput (tok/s) | 31119.6940 | 56754.2949 | 111082.5827 | 138838.0072 |
| TTFT (ms) | 960.95 | 1028.23 | 823.49 | 2194.63 |
| TPOT (ms) | 7.35 | 8.03 | 9.02 | 10.51 |
| ITL (ms) | 27.43 | 29.52 | 34.20 | 40.92 |
| Average turn index | 7.0 | 7.0 | 7.0 | 7.0 |
| KV cache hit rate (%), reported | 0.0 | 0.0 | 0.0 | 0.0 |
| Decoded tokens/iteration | 3.7583 | 3.7157 | 4.0116 | 14.2891 |
| Speculative acceptance rate | 0.7339 | 0.7309 | 0.7507 | 0.9300 |

The EvalScope source field is named `Avg Turns/Request`; for 13 turns numbered 1 through 13 its reported average is 7.0. The table labels this value `Average turn index` to state what the number represents.

## AgentX final client values

All values are copied from each point's `profile_export_aiperf.json`.

### Run and throughput

| Metric | c16 | c32 | c64 |
|---|---:|---:|---:|
| Wrapper duration (s) | 2020 | 2095 | 2249 |
| Benchmark duration (s) | 1823.991550208 | 1828.203987456 | 1829.281771776 |
| Requests | 1111 | 893 | 1124 |
| Errors | 0 | 0 | 0 |
| Cancelled | false | false | false |
| Request throughput (req/s) | 0.6070998111 | 0.4853259806 | 0.6108692102 |
| Input throughput (tok/s) | 43611.6706657 | 32685.0884876 | 35418.3636527 |
| Output throughput (tok/s) | 438.0080330 | 466.3335934 | 472.3453776 |
| Total throughput (tok/s) | 44049.6786987 | 33151.4220810 | 35890.7090304 |
| Active prefill throughput avg (tok/s) | 44219.9750587 | 32989.9640316 | 35744.4221456 |
| Active decode throughput avg (tok/s) | 439.0330551 | 469.0164294 | 474.5837843 |
| Effective prefill concurrency avg | 9.5318163 | 30.6886636 | 84.3618249 |
| Effective decode concurrency avg | 7.7556100 | 9.3415693 | 9.7187468 |
| Effective total concurrency avg | 17.2874262 | 40.0302329 | 94.0805717 |
| Theoretical prefix reuse (%) | 95.3750278 | 94.4181342 | 94.0956542 |

### Token lengths

| Metric (tokens) | c16 | c32 | c64 |
|---|---:|---:|---:|
| Input avg | 71836.0801080 | 67346.6696529 | 57980.2731317 |
| Input p50 | 73782.0 | 67532.0 | 56076.0 |
| Input p95 | 114228.0 | 116323.8 | 116585.6 |
| Input p99 | 123195.2 | 130071.16 | 131973.92 |
| Output avg | 721.4761476 | 960.8667413 | 773.2348754 |
| Output p50 | 296.0 | 322.0 | 362.5 |
| Output p95 | 2371.5 | 2776.8 | 2331.35 |
| Output p99 | 6477.7 | 9324.24 | 5999.4 |

### Latency

| Metric (ms) | c16 | c32 | c64 |
|---|---:|---:|---:|
| TTFT avg | 15700.5752510 | 63233.0945210 | 138101.2882473 |
| TTFT p50 | 14408.4058550 | 62921.4538310 | 142142.7540975 |
| TTFT p95 | 29282.1322355 | 95635.2926990 | 183359.9212775 |
| TTFT p99 | 38284.8371060 | 115497.0975182 | 192081.1020510 |
| Second-token avg | 51.7790566 | 167.9623757 | 158.6509640 |
| Second-token p50 | 23.1172640 | 155.0555950 | 139.0948970 |
| Second-token p95 | 171.0660489 | 373.9893527 | 357.1275063 |
| Second-token p99 | 291.3945955 | 515.3734316 | 491.6469210 |
| ITL avg | 18.0283603 | 20.7490795 | 21.9518884 |
| ITL p50 | 17.6198115 | 20.0519143 | 20.8499440 |
| ITL p95 | 22.8956975 | 27.8601156 | 29.9612413 |
| ITL p99 | 29.5282373 | 38.7183278 | 44.4062215 |
| E2E avg | 28475.0523945 | 82480.6828700 | 154010.5033666 |
| E2E p50 | 23081.6125270 | 73793.5241390 | 152138.5027390 |
| E2E p95 | 59925.9296545 | 124777.0068886 | 204347.7241407 |
| E2E p99 | 141803.5480473 | 249019.7202125 | 296921.2012360 |

## Raw files

- `openhands/raw/`: unmodified OpenHands output for all four points, including `benchmark_data.db`, `benchmark_summary.json`, `benchmark_percentile.json`, commands, reproduction environments, HTML reports, performance summaries, client logs and server logs.
- `openhands/controller.log`: unmodified OpenHands controller output.
- `agentx/raw/`: unmodified AgentX output for all three points plus deployment metadata, including AIPerf JSON/CSV, per-request profiler JSONL, client logs, server logs, server metrics exports, dspark snapshots, run metadata and manifests.
- `agentx/controller.log`: unmodified final AgentX controller output.

The Markdown tables contain final aggregate values. Per-request records and complete percentile distributions remain in the raw `.db`, `.jsonl`, JSON and CSV files.
