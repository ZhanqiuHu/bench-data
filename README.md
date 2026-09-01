# bench-data

Public inference benchmark results. **One repo, many sweeps; each sweep splits by dataset.**

## Layout

```
bench-data/
  sweeps/
    <sweep-id>/
      README.md
      STATUS.md
      datasets/
        <dataset-name>/
          summary.csv          # all methods × conc for this dataset
          head-to-head.csv     # MTP vs DSpark (when both exist)
          mtp/c{N}/profile_export_aiperf.csv
          dspark/c{N}/profile_export_aiperf.csv
```

## Sweeps

| Sweep | Model | Notes |
|-------|-------|-------|
| [`glm52-fp8-pd-mtp-dspark-20260901`](sweeps/glm52-fp8-pd-mtp-dspark-20260901/) | GLM-5.2-FP8 | P/D 16×H200, MTP vs DSpark spec-decode, overnight 2026-09-01 |

## Adding data

1. `sweeps/<new-id>/datasets/<dataset>/mtp/c4/...`
2. Add per-dataset `summary.csv` (and `head-to-head.csv` if applicable).
3. Update sweep `STATUS.md` and this README table.
