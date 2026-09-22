# Prefix-cache counters

Raw counters exported by AIPerf from the vLLM metrics endpoint.

| Topology | Conc. | Local hits | Local queries | External hits | External queries |
|---|---:|---:|---:|---:|---:|
| PCP8+DCP8→TP8 | 16 | 2,645,248 | 81,315,509 | 79,911,163 | 78,670,261 |
| PCP8+DCP8→TP8 | 32 | 1,553,664 | 68,117,312 | 51,899,990 | 66,563,648 |
| PCP8+DCP8→TP8 | 64 | 4,838,976 | 73,685,093 | 68,846,117 | 68,846,117 |
| TP8→TP8 | 16 | 1,425,088 | 24,109,401 | 8,618,944 | 22,684,313 |
| TP8→TP8 | 32 | 17,101,312 | 15,991,730 | 100,439,418 | 0 |
| TP8→TP8 | 64 | 2,419,200 | 20,857,584 | 18,438,384 | 18,438,384 |

These are cumulative counter aggregates, not validated hit-rate deltas. Some
rows have hits greater than queries or nonzero hits with zero queries, showing
that resets and/or changing series membership occurred during aggregation.
Those rows must not be converted directly into hit-rate percentages. The raw
CSV and JSON exports are retained beside each concurrency point.
