# spec-al-humaneval

| c | MTP tok/s/user | DSpark tok/s/user | Δ DSpark | MTP TTFT ms | DSpark TTFT ms |
|--:|---------------:|------------------:|---------:|------------:|---------------:|
| 4 | 106.52 | 121.39 | +14% | 653 | 471 |
| 8 | 97.03 | 108.58 | +12% | 701 | 509 |
| 16 | 87.20 | 98.28 | +13% | 978 | 481 |
| 32 | 79.57 | 88.42 | +11% | 1,083 | 542 |
| 64 | 67.97 | 81.13 | +19% | 1,728 | 583 |
| 128 | 65.60 | 71.98 | +10% | 1,422 | 819 |
| 256 | 68.21 | 71.03 | +4% | 3,139 | 1,636 |
| 512 | 61.35 | 68.17 | +11% | 1,291 | 2,892 |

[`MTP vs DSpark comparison`](head-to-head.csv) · [`summary.csv`](summary.csv)

MTP: [`c4`](mtp/c4/profile_export_aiperf.csv) [`c8`](mtp/c8/profile_export_aiperf.csv) [`c16`](mtp/c16/profile_export_aiperf.csv) [`c32`](mtp/c32/profile_export_aiperf.csv) [`c64`](mtp/c64/profile_export_aiperf.csv) [`c128`](mtp/c128/profile_export_aiperf.csv) [`c256`](mtp/c256/profile_export_aiperf.csv) [`c512`](mtp/c512/profile_export_aiperf.csv)

DSpark: [`c4`](dspark/c4/profile_export_aiperf.csv) [`c8`](dspark/c8/profile_export_aiperf.csv) [`c16`](dspark/c16/profile_export_aiperf.csv) [`c32`](dspark/c32/profile_export_aiperf.csv) [`c64`](dspark/c64/profile_export_aiperf.csv) [`c128`](dspark/c128/profile_export_aiperf.csv) [`c256`](dspark/c256/profile_export_aiperf.csv) [`c512`](dspark/c512/profile_export_aiperf.csv)
