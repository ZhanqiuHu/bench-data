# Feature metrics: tp8-tp8 c32

This file records only this experiment.

- Complete raw feature rows: [`FEATURE_METRICS_RAW.csv`](FEATURE_METRICS_RAW.csv)
- Complete server export: [`server_metrics_export.csv`](server_metrics_export.csv) and [`server_metrics_export.json`](server_metrics_export.json)
- Request/drain validity: [`drain-validation.json`](drain-validation.json)

The feature extract contains MTP draft/accepted/per-position counters; NIXL transfer bytes, descriptors, timings and failures; KV offload bytes, sizes, timings, tiering and CPU-cache usage; local/external prefix-cache counters; KV usage; running/waiting queues; and preemptions, with original units, labels and aggregation fields preserved. Counter-derived ratios are not asserted when resets or changing series membership make totals inconsistent.
