# GLM-5.2-FP8 MTP vs DSpark — benchmark data

Public dataset for overnight speculative-decoding sweeps on **GLM-5.2-FP8** with P/D disaggregation (1×8 prefill + 1×8 decode, 16× H200).

## What's here

| Path | Description |
|------|-------------|
| `summary/all_cells.csv` | One row per completed cell (parsed key metrics) |
| `raw/{mtp,dspark}/{dataset}/c{N}/profile_export_aiperf.csv` | aiperf 0.12 CSV exports |
| `STATUS.md` | Coverage matrix + known gaps |

## Setup (fixed for all runs)

- **Model:** `zai-org/GLM-5.2-FP8`
- **Client:** aiperf `profile`, `--use-server-token-count`, `--streaming`
- **Concurrency sweep:** 4, 8, 16, 32, 64, 128, 256, 512
- **Datasets:** aiperf spec-decode public sets (`spec-al-math500`, `spec-al-humaneval`, `spec-al-mbpp`)
- **Metrics:** tok/s/user = `Output Token Throughput Per User`; tok/s/gpu = total output tok/s ÷ 16 GPUs

## Complete fair pairs (MTP + DSpark)

- **spec-al-math500** — 8/8 + 8/8 (DSpark = fair rerun, epoch after 2026-09-01T03:26Z)
- **spec-al-humaneval** — 8/8 + 8/8

## Partial

- **spec-al-mbpp** — DSpark 8/8 only; MTP blocked by cluster GPU contention

## Not included (failed / not run)

- gsm8k, mtbench, spec-bench, P4 synthetics — see `STATUS.md`

## Citation

If you use this data, note: spec-decode datasets are **not** InferenceMAX chat/reasoning/summarization scenarios; comparison is valid within same dataset/topology/client.
