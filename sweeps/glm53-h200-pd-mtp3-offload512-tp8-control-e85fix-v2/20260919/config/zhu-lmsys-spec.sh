#!/usr/bin/env bash
# One spec: glm_53_blog_2 Fast Pareto LMSYS via zhu-vllm-devbox + in-cluster URL (no port-forward).
# Long jobs run via nohup on devbox (kubectl exec websocket cannot survive dataset build).
set -euo pipefail

# shellcheck source=../lib/common.sh
source "$(dirname "$0")/../lib/common.sh"

sweep="${1:?usage: zhu-lmsys-spec.sh <sweep-name> <manifesto-spec>}"
spec="${2:?usage: zhu-lmsys-spec.sh <sweep-name> <manifesto-spec>}"

cd "$AGENTX_ROOT"
# shellcheck source=/dev/null
source scripts/env.sh
load_agentx_env
require_agentx_env KUBE_CONTEXT NAMESPACE MODEL URL ROUTER_RELEASE MANIFESTO_USER RESULTS_PREFIX

export KUBECONFIG="${KUBECONFIG:-$HOME/.kube/coreweave-piggy.yaml}"
export MANIFESTO_CONFIG_HOME="${MANIFESTO_CONFIG_HOME:-$PCP_DIR/manifesto}"

run_id="${SWEEP_RUN_ID:?SWEEP_RUN_ID must be set by zhu-dspark7-spec-sweep.sh start}"
config="$(basename "$spec" .yaml)"
local_dir="${AGENTX_ROOT}/results/.artifacts/sweeps/${sweep}/runs/${run_id}/results_${config}"
lmsys_root="${local_dir}/lmsys"
devbox_pod="${DEVBOX_POD:-zhu-vllm-devbox}"
devbox_env="${LMSYS_DEVBOX_ENV:-${ACCURACY_DEVBOX_ENV:-/workspace/vdptest/vllm-main-20260914T180020Z-e85c8826}}"
devbox_client_py="${devbox_env}/.venv/bin/python"
devbox_lmsys_cache="/workspace/${RESULTS_PREFIX}/cache/lmsys-glm-agentic"
devbox_lmsys_out="/workspace/${RESULTS_PREFIX}/lmsys-runs/${sweep}/${run_id}/${config}"
lmsys_client="${PCP_DIR}/scripts/lmsys-client.sh"
devbox_wrapper="${PCP_DIR}/scripts/zhu-lmsys-devbox-wrapper.sh"
tokenizer_model="${TOKENIZER_MODEL:-${TOKENIZER:-zai-org/GLM-5.3}}"
blog_commit="${BLOG_COMMIT:-2bac7e166a7b5bf518b778817ec464cec0f75e3e}"
evalscope_commit="${EVALSCOPE_COMMIT:-acd09b44384d53174768bb1063f675420f76fae9}"
evalscope_venv="${devbox_lmsys_cache}/evalscope-venv-${evalscope_commit}"
blog_checkout="${devbox_lmsys_cache}/sglang-${blog_commit}"
hf_datasets_cache="${devbox_lmsys_cache}/hf-datasets-cache-v3.6"
slug="${tokenizer_model//\//-}"
dataset_key="$(printf '%s\n' \
  "$tokenizer_model" "$blog_commit" \
  'pad_source=openscience' 'first_turn_length=74160' \
  'subsequent_turn_length=753' 'num_turns=13' 'number=128' \
  | shasum -a 256 | cut -c1-16)"
dataset_path="${devbox_lmsys_cache}/datasets/openhand-${slug}-${dataset_key}.json"
# The GLM-5.3 dataset was built and used successfully by the 2026-09-11
# DSpark7 sweep. Reuse the exact artifact by key across renamed experiment
# roots instead of rebuilding all 67k OpenHands source rows.
shared_dataset="/workspace/zhu-pcp-agentx/cache/lmsys-glm-agentic/datasets/$(basename "$dataset_path")"
if k exec "$devbox_pod" -- test -s "$shared_dataset" 2>/dev/null; then
  dataset_path="$shared_dataset"
fi
poll_interval="${ZHU_LMSYS_POLL_SECONDS:-5}"

mkdir -p "${local_dir}/logs" "${lmsys_root}"

devbox_client_env() {
  cat <<EOF
set -euo pipefail
source '${devbox_env}/.venv/bin/activate'
export HF_HOME=/models/hf HF_HUB_OFFLINE=0 PYTHONUNBUFFERED=1
mkdir -p '${devbox_lmsys_out}' '${devbox_lmsys_cache}' '${devbox_lmsys_cache}/datasets'
export BASE_URL='${URL}'
export SERVED_MODEL='${MODEL}'
export TOKENIZER_MODEL='${tokenizer_model}'
export BLOG_COMMIT='${blog_commit}'
export BLOG_CHECKOUT='${blog_checkout}'
export CLIENT_VENV='${evalscope_venv}'
export CLIENT_PYTHON='${devbox_client_py}'
export EVALSCOPE_COMMIT='${evalscope_commit}'
export HF_DATASETS_CACHE='${hf_datasets_cache}'
export LMSYS_DATASET_PATH='${dataset_path}'
EOF
}

devbox_wait_job() {
  local job_tag="$1"
  local inner="$2"
  local safe_tag="${run_id}-${job_tag//\//-}"
  local log="/tmp/zhu-lmsys-${safe_tag}.log"
  local done="/tmp/zhu-lmsys-${safe_tag}.done"
  local rc="/tmp/zhu-lmsys-${safe_tag}.rc"
  local launcher="/tmp/zhu-lmsys-launch-${safe_tag}.sh"
  local local_launcher
  local_launcher="$(mktemp)"

  {
    devbox_client_env
    printf '%s\n' "$inner"
  } >"$local_launcher"

  set +e
  k exec "$devbox_pod" -- bash -c "rm -f '$done' '$rc' '$log' '$launcher'" >/dev/null 2>&1
  if ! k cp "$local_launcher" "${devbox_pod}:${launcher}" >/dev/null 2>&1; then
    echo "FAILED: k cp launcher -> ${devbox_pod}:${launcher}" >&2
    rm -f "$local_launcher"
    set -e
    return 1
  fi
  rm -f "$local_launcher"
  k exec "$devbox_pod" -- chmod +x "$launcher" >/dev/null 2>&1
  k exec "$devbox_pod" -- bash -c \
    "nohup bash /tmp/zhu-lmsys-devbox-wrapper.sh '$log' '$done' '$rc' bash '$launcher' </dev/null >/dev/null 2>&1 &" \
    >/dev/null 2>&1
  set -e

  echo "devbox job=$job_tag log=$log"
  while ! k exec "$devbox_pod" -- test -f "$done" 2>/dev/null; do
    sleep "$poll_interval"
    k exec "$devbox_pod" -- tail -3 "$log" 2>/dev/null || true
  done
  local ec
  ec="$(k exec "$devbox_pod" -- cat "$rc" 2>/dev/null || echo 1)"
  k exec "$devbox_pod" -- tail -30 "$log" 2>/dev/null || true
  [[ "$ec" == "0" ]]
}

echo "################ $spec -> $local_dir (devbox LMSYS BASE_URL=$URL) MODEL=$MODEL run_id=$run_id"

if [[ "${ZHU_LMSYS_SKIP_DEPLOY:-0}" == "1" ]]; then
  echo "ZHU_LMSYS_SKIP_DEPLOY=1 — reusing current deploy, probing router for MODEL=$MODEL"
  if ! k exec "$devbox_pod" -- curl -sf -m 10 "${URL%/}/v1/models" 2>/dev/null \
    | grep -q "\"$MODEL\""; then
    echo "FAILED: router not serving $MODEL at $URL" >&2
    exit 1
  fi
  echo "Model is serving (skip-deploy)."
else
  scripts/teardown-model.sh --all
  if ! bash "$PCP_DIR/scripts/zhu-deploy-model.sh" "$spec"; then
    echo "FAILED: deploy $config" >&2
    exit 1
  fi
fi

printf '%s\n' "$config" > "$local_dir/config_name.txt"
printf '%s\n' "$run_id" > "$local_dir/run_id.txt"
selector=""
if [[ "${ZHU_LMSYS_SKIP_DEPLOY:-0}" == "1" ]]; then
  echo "skip heavy metadata (ZHU_LMSYS_SKIP_DEPLOY=1)"
else
  echo "collecting spec metadata..."
  set +e
  selector="$(instance_selector "$spec")"
  render_model "$spec" > "$local_dir/manifest.yaml"
  scripts/vllm-args.sh "$spec" > "$local_dir/vllm-args.yaml"
  k get pods -l "$selector" -o jsonpath='{.items[*].metadata.name}' 2>/dev/null | tr ' ' '|' > "$local_dir/pods.txt"
  manifesto config export models "$spec" -o "$local_dir/spec.yaml" --force >/dev/null 2>&1
  grep -m1 '^  label:' "$local_dir/spec.yaml" 2>/dev/null | awk '{print $2}' > "$local_dir/model_label.txt"
  k get pods -l "$selector" -o json 2>/dev/null \
    | jq -r '.items[0].spec.containers[]? | select(.name == "vllm") | .image' 2>/dev/null \
    | head -1 > "$local_dir/vllm_image.txt"
  scripts/vllm-build-info.sh "$selector" > "$local_dir/vllm_env.txt" 2>/dev/null
  scripts/kv-cache-info.sh "$selector" > "$local_dir/kv-cache.yaml" 2>/dev/null
  set -e
  echo "metadata done selector=$selector"
fi
[[ -n "$selector" ]] || selector="$(instance_selector "$spec" 2>/dev/null || true)"

k cp "$lmsys_client" "${devbox_pod}:/tmp/zhu-lmsys-client.sh"
k cp "$devbox_wrapper" "${devbox_pod}:/tmp/zhu-lmsys-devbox-wrapper.sh"
k exec "$devbox_pod" -- chmod +x /tmp/zhu-lmsys-devbox-wrapper.sh /tmp/zhu-lmsys-client.sh

install_deps=1
if k exec "$devbox_pod" -- test -x "$evalscope_venv/bin/python" 2>/dev/null \
  && k exec "$devbox_pod" -- "$evalscope_venv/bin/python" -c \
    'import evalscope.perf.plugin.datasets.swe_smith' >/dev/null 2>&1; then
  install_deps=0
fi
echo "devbox=$devbox_pod cache=$devbox_lmsys_cache INSTALL_DEPS=$install_deps dataset=$dataset_path"

if ! k exec "$devbox_pod" -- test -s "$dataset_path" 2>/dev/null; then
  legacy_dataset="$(k exec "$devbox_pod" -- bash -c \
    "ls -1 /workspace/${RESULTS_PREFIX}/lmsys-runs/${sweep}/*/${config}/lmsys-glm-blog-repro/benchmark/glm_nvfp4_blog/datasets/openhand-${slug}-*.json 2>/dev/null | head -1" \
    2>/dev/null || true)"
  if [[ -n "$legacy_dataset" ]]; then
    echo "bootstrap dataset from legacy path: $legacy_dataset -> $dataset_path"
    k exec "$devbox_pod" -- bash -c "mkdir -p '$(dirname "$dataset_path")' && cp -f '$legacy_dataset' '$dataset_path'"
  fi
fi

dataset_ready=0
if k exec "$devbox_pod" -- test -s "$dataset_path" 2>/dev/null; then
  dataset_ready=1
  echo "dataset cache hit: $dataset_path"
fi

if [[ "$install_deps" == "1" || "$dataset_ready" != "1" ]]; then
  echo "======== $config LMSYS preflight: deps=${install_deps} dataset_ready=${dataset_ready} (nohup on devbox)"
  preflight_inner=$(cat <<EOF
export OUTPUT_DIR='${devbox_lmsys_cache}'
export RUN_NAME='preflight-${run_id}'
export INSTALL_DEPS='${install_deps}'
export ZHU_LMSYS_DATASET_ONLY=1
bash /tmp/zhu-lmsys-client.sh
EOF
)
  if ! devbox_wait_job "${config}-preflight" "$preflight_inner"; then
    echo "FAILED: $config preflight (deps/dataset)" >&2
    exit 1
  fi
  install_deps=0
fi

failed_points=()
if [[ -n "${ZHU_LMSYS_POINTS_ONLY:-}" ]]; then
  # shellcheck disable=SC2206
  bench_points=(${ZHU_LMSYS_POINTS_ONLY})
else
  bench_points=(1:4 2:8 4:8 8:16)
  if [[ -n "${ZHU_LMSYS_EXTRA_POINTS:-}" ]]; then
    # shellcheck disable=SC2206
    bench_points+=(${ZHU_LMSYS_EXTRA_POINTS})
  fi
fi
echo "bench_points=${bench_points[*]}"
for point in "${bench_points[@]}"; do
  concurrency="${point%%:*}"
  requests="${point##*:}"
  started="$(date -u +%Y%m%dT%H%M%SZ)"
  run_name="${config}-c${concurrency}-${started}"
  echo "======== $config LMSYS c=$concurrency n=$requests ($started) url=$URL run_name=$run_name"

  bench_inner=$(cat <<EOF
export OUTPUT_DIR='${devbox_lmsys_out}'
export RUN_NAME='${run_name}'
export INSTALL_DEPS=0
export ZHU_LMSYS_BENCH_ONLY=1
export LMSYS_PARALLELS='${concurrency}'
export LMSYS_NUMBERS='${requests}'
bash /tmp/zhu-lmsys-client.sh
EOF
)
  if ! devbox_wait_job "${run_name}" "$bench_inner"; then
    echo "FAILED: $config c=$concurrency" >&2
    failed_points+=("c${concurrency}")
  else
    mkdir -p "${lmsys_root}/${run_name}"
    k cp "${devbox_pod}:${devbox_lmsys_out}/${run_name}/." \
      "${lmsys_root}/${run_name}/" >/dev/null
  fi

  k logs -l "llm-d.ai/owner=${MANIFESTO_USER},llm-d.ai/role=decode" \
    -c vllm --since=30m > "${local_dir}/logs/decoder-c${concurrency}-${started}.log" 2>&1 || true
done

if [[ -n "$selector" ]]; then
  for pod in $(k get pods -l "$selector" -o jsonpath='{.items[*].metadata.name}' 2>/dev/null); do
    k logs "$pod" --all-containers > "${local_dir}/logs/${pod}.log" 2>&1 || true
  done
fi

if [[ "${ZHU_LMSYS_SKIP_DEPLOY:-0}" != "1" ]]; then
  scripts/teardown-model.sh "$spec"
fi

if [[ ${#failed_points[@]} -gt 0 ]]; then
  echo "FAILED points for $config: ${failed_points[*]}" >&2
  exit 1
fi
echo "OK $config LMSYS all points devbox no-port-forward run_id=$run_id"
