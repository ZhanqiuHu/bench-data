# GLM-5.3 H200 PD next-run matrix — 2026-09-19

## Runs already available

| Prefill | Decode | MTP | CPU KV offload | Runtime | OpenHands | AgentX |
|---|---|---:|---:|---|---|---|
| PCP8 + DCP8 + TP1 + EP | TP8 + EP | 3 | 512 GiB | main `1f6a41a177`, unpatched | complete (`20260916T172941Z`) | complete (`20260917T133915Z`) |
| TP8 + EP | TP8 + EP | 3 | 512 GiB | main `1f6a41a177` + e85fix-v2 | complete (`20260919T181450Z`) | complete (`20260919T182534Z`) |

These two rows are not a controlled topology A/B: the runtime differs, and the
e85fix-v2 manifest explicitly identifies itself as a recovery-validation
deployment rather than a final performance configuration.

## Next runs, in order

### P0 — controlled PCP8+DCP8 versus TP8 prefill comparison

Create a new PCP8+DCP8 manifest that uses the exact same vLLM environment,
e85fix-v2 patch, image, decoder topology, MTP3 settings, 512 GiB offload, model
revision, context cap, and workload scripts as the completed TP8 control. Only
the prefill topology and the minimum topology-required batching/KV settings may
differ.

Run sequence:

1. render and save the rendered manifest;
2. deploy under a new model name;
3. one long-prefix smoke request and one prefiller-restart recovery check;
4. OpenHands points `1:4`, `2:8`, `4:8`, `8:16`;
5. AgentX c16/c32/c64 for 1800 seconds each;
6. archive raw client/server/controller output and all metrics under a new run ID.

This is the next result needed for Lucas's immediate PCP comparison. The older
PCP8+DCP8 result remains useful historical data but is not the matching control
for the e85fix-v2 TP8 row.

### P1 — PCP8 without DCP

Lucas's requested `pcp8-{dcp8}` notation includes a PCP8+DCP1 row. It needs a
separate feasibility gate before a paid sweep because DCP1 replicates the KV
view across PCP ranks and the repository already records that the long-context
H200 configuration can be memory-limited.

Required gate:

1. render the PCP8+DCP1 manifest on the same runtime;
2. calculate available KV capacity from startup output;
3. verify the required 142k context and the OpenHands long-prefix request;
4. only if both pass, run the same OpenHands and AgentX grids.

If 142k cannot be supported without changing the workload, record the row as
infeasible on 8×H200. Do not compare a shorter-context run as if it were the
same experiment.

### P2 — DEP8 decoder arm

Lucas also requested `{tep8/dep8}`. The current completed decoder is TP8+EP;
there is no validated MTP3+offload512 DEP8 decoder manifest in this directory.
Before benchmarking, this arm needs its own manifest, router/NIXL mapping
validation, one long-prefix request, and restart/re-handshake test. If valid,
run the identical OpenHands and AgentX grids against both matching prefill arms.

### P3 — feature ablations

After the topology matrix is controlled, run one-variable ablations on the
chosen topology:

| Comparison | Fixed variables | Purpose |
|---|---|---|
| MTP0 vs MTP3 | topology, offload size, context, workload | measure actual MTP speedup and latency cost |
| offload disabled vs 512 GiB | topology, MTP, context, workload | measure offload benefit/cost; only valid if the no-offload arm fits |
| MTP3 + offload512 | existing feature-on row | interaction reference |

MTP1 is optional only if a depth curve is needed; MTP0 is the required control.

### P4 — HiSparse

Do not add HiSparse to the immediate controlled matrix. The current H200
manifest explicitly says `no HiSparse`, and no validated HiSparse manifest is
present here. Add it as a separate decoder ablation only after the selected
nightly/runtime exposes the required implementation and it passes correctness,
long-context, and restart tests. Its comparison must keep the selected decoder
topology, MTP depth, and offload size fixed.

## Correctness and reporting requirements for every new row

- unique model name and run ID; never overwrite a previous run;
- exact vLLM commit, runtime path, patch SHA, image, rendered manifest, and
  client environment saved with the results;
- OpenHands reports all four points and AgentX reports c16/c32/c64;
- raw controller, client, prefill, decode, per-request, Prometheus/server
  metrics, and final exports copied before teardown;
- forced-drain/in-flight counts reported separately from completed requests;
- MTP counters, NIXL transfer histograms/failures, scheduler waiting reasons,
  GPU KV use, CPU offload occupancy/hit/load/store metrics recorded per point;
- any full GSM8K check uses the complete dataset (`limit=full`), never a
  testing limit presented as an accuracy result.
