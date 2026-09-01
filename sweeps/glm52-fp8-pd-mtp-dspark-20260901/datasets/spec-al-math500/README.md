# spec-al-math500

| c | MTP tok/s/user | DSpark tok/s/user | Δ DSpark | MTP TTFT ms | DSpark TTFT ms |
|--:|---------------:|------------------:|---------:|------------:|---------------:|
| 4 | 118.57 | 136.34 | +15% | 734 | 625 |
| 8 | 107.42 | 139.07 | +30% | 697 | 522 |
| 16 | 94.76 | 125.24 | +32% | 654 | 492 |
| 32 | 90.67 | 109.91 | +21% | 588 | 502 |
| 64 | 79.30 | 76.96 | −3% | 1,082 | 2,507 |
| 128 | 64.31 | 56.97 | −11% | 1,844 | 13,199 |
| 256 | 50.14 | 53.75 | +7% | 1,475 | 46,084 |
| 512 | 56.14 | 55.81 | ~0% | 12,406 | 22,216 |

[`MTP vs DSpark comparison`](head-to-head.csv) · [`summary.csv`](summary.csv)

MTP: [`c4`](mtp/c4/profile_export_aiperf.csv) [`c8`](mtp/c8/profile_export_aiperf.csv) [`c16`](mtp/c16/profile_export_aiperf.csv) [`c32`](mtp/c32/profile_export_aiperf.csv) [`c64`](mtp/c64/profile_export_aiperf.csv) [`c128`](mtp/c128/profile_export_aiperf.csv) [`c256`](mtp/c256/profile_export_aiperf.csv) [`c512`](mtp/c512/profile_export_aiperf.csv)

DSpark: [`c4`](dspark/c4/profile_export_aiperf.csv) [`c8`](dspark/c8/profile_export_aiperf.csv) [`c16`](dspark/c16/profile_export_aiperf.csv) [`c32`](dspark/c32/profile_export_aiperf.csv) [`c64`](dspark/c64/profile_export_aiperf.csv) [`c128`](dspark/c128/profile_export_aiperf.csv) [`c256`](dspark/c256/profile_export_aiperf.csv) [`c512`](dspark/c512/profile_export_aiperf.csv)
