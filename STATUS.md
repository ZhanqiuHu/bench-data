# Coverage status — 2026-09-01

| Dataset | MTP 8 conc | DSpark 8 conc | Pair complete |
|---------|:----------:|:-------------:|:-------------:|
| spec-al-math500 | ✅ | ✅ (fair) | **Yes** |
| spec-al-humaneval | ✅ | ✅ | **Yes** |
| spec-al-mbpp | ❌ | ✅ | No (DSpark only) |
| spec-al-gsm8k | ❌ | ❌ | No (typo `gsm8-k`, fixed in scripts) |
| spec-al-mtbench | ❌ | ❌ | No |
| spec-bench | ❌ | ❌ | No |
| P4 synthetic (chat/reasoning/summarization) | ❌ | ❌ | No |

## Blockers at export time

- MTP serving could not schedule (16 GPU required; cluster saturated by other jobs).
- Orchestrator log: `deploy mtp attempt 1/4` failed — `Insufficient nvidia.com/gpu`.

## Raw file count

40 `profile_export_aiperf.csv` files under `raw/` (16 MTP + 24 DSpark).
