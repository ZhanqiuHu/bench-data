#!/usr/bin/env bash
set -euo pipefail

pcp_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$pcp_root"

export KUBECONFIG="${KUBECONFIG:-$HOME/.kube/coreweave-piggy.yaml}"
export ENV_FILE="$pcp_root/setup-notes/nixl-diagnostic/env.e85fix-v2"
export MODEL=zhu-glm53-h200-e85fix-v2-tp8-tp8-mtp3-offload512
export MANIFESTO_SPEC=glm-5.3/h200/p1-tp8ep-d1-tp8ep-mtp3-offload512-e85fix-v2-zhu
export SWEEP_CONCURRENCIES="16 32 64"
export DURATION_SECONDS=1800
export ZHU_SWEEP_SKIP_DEPLOY=1
export ZHU_SWEEP_SKIP_TEARDOWN=1

devbox=zhu-vllm-devbox
url=http://glm-zhu-epp:80
run_id="${SWEEP_RUN_ID:-$(date -u +%Y%m%dT%H%M%SZ)-e85fix-v2-tp8-control}"
sweep="e85fix-v2-tp8-agentx-${run_id}"
agentx_root="$pcp_root/../../../agentx-mvp"
controller_dir="$agentx_root/results/.artifacts/sweeps/e85fix-v2-tp8-agentx/controllers"
controller_log="$controller_dir/${run_id}.log"
mkdir -p "$controller_dir"

if ! kubectl --kubeconfig "$KUBECONFIG" -n zhu-dev exec "$devbox" -- \
  curl -sf -m 10 "$url/v1/models" 2>/dev/null \
  | grep -Fq "\"$MODEL\""; then
  echo "ERROR: exact model is not serving: $MODEL" >&2
  exit 1
fi

echo "AgentX e85fix-v2 current-deploy validation"
echo "model=$MODEL spec=$MANIFESTO_SPEC"
echo "concurrencies=$SWEEP_CONCURRENCIES duration=${DURATION_SECONDS}s each"
echo "run_id=$run_id controller_log=$controller_log"

set -o pipefail
bash scripts/zhu-sweep.sh "$sweep" "$MANIFESTO_SPEC" 2>&1 | tee "$controller_log"
