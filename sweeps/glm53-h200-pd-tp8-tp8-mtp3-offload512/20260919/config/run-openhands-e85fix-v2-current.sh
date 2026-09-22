#!/usr/bin/env bash
set -euo pipefail

pcp_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$pcp_root"

export KUBECONFIG="${KUBECONFIG:-$HOME/.kube/coreweave-piggy.yaml}"
export ENV_FILE="$pcp_root/setup-notes/nixl-diagnostic/env.e85fix-v2"
export MODEL=zhu-glm53-h200-e85fix-v2-tp8-tp8-mtp3-offload512
export MANIFESTO_SPEC=glm-5.3/h200/p1-tp8ep-d1-tp8ep-mtp3-offload512-e85fix-v2-zhu
export SWEEP_RUN_ID="${SWEEP_RUN_ID:-$(date -u +%Y%m%dT%H%M%SZ)-e85fix-v2-tp8-control}"
export ZHU_LMSYS_SKIP_DEPLOY=1
export ZHU_LMSYS_POINTS_ONLY="1:4 2:8 4:8 8:16"
export ZHU_LMSYS_POLL_SECONDS=5
export LMSYS_DEVBOX_ENV=/workspace/vdptest/vllm-main-20260914T180020Z-e85c8826

devbox=zhu-vllm-devbox
url=http://glm-zhu-epp:80
if ! kubectl --kubeconfig "$KUBECONFIG" -n zhu-dev exec "$devbox" -- \
  curl -sf -m 10 "$url/v1/models" 2>/dev/null \
  | grep -Fq "\"$MODEL\""; then
  echo "ERROR: exact model is not serving: $MODEL" >&2
  exit 1
fi

controller_dir="$pcp_root/../../../agentx-mvp/results/.artifacts/sweeps/e85fix-v2-tp8-openhands/controllers"
mkdir -p "$controller_dir"
controller_log="$controller_dir/${SWEEP_RUN_ID}.log"
echo "controller_log=$controller_log"
echo "run_id=$SWEEP_RUN_ID model=$MODEL spec=$MANIFESTO_SPEC"

set -o pipefail
bash scripts/zhu-lmsys-spec.sh e85fix-v2-tp8-openhands "$MANIFESTO_SPEC" \
  2>&1 | tee "$controller_log"
