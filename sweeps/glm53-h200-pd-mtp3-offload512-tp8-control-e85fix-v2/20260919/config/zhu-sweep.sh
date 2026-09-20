#!/usr/bin/env bash
# zhu sweep — per-concurrency isolated artifacts (not in upstream agentx-mvp).
#
# Saves WHILE each benchmark runs:
#   - kubectl logs -f  -> logs/server/*.live.log (streaming)
#   - aiperf Job tail  -> logs/aiperf-client.live.log
#   - PVC aiperf.log   -> logs/aiperf.live.log (periodic sync)
#   - dspark lines     -> dspark-snapshot.live.txt (periodic refresh)
# After each point: final PVC copy + dspark-snapshot.txt + run_meta.json
#
# Usage: zhu-sweep.sh <sweep-name> [spec]
# Env:   SWEEP_CONCURRENCIES, DURATION_SECONDS, TOKENIZER, MODEL_REVISION,
#        ZHU_SWEEP_SKIP_DEPLOY=1, ZHU_SWEEP_SKIP_TEARDOWN=1,
#        ZHU_SWEEP_PVC_SYNC_SEC=120, ZHU_SWEEP_DSPARK_REFRESH_SEC=60
set -euo pipefail

# shellcheck source=../lib/common.sh
source "$(dirname "$0")/../lib/common.sh"

sweep="${1:?usage: zhu-sweep.sh <sweep-name> [spec]}"
spec="${2:-${MANIFESTO_SPEC:?MANIFESTO_SPEC must be set}}"
config="$(basename "$spec" .yaml)"

cd "$AGENTX_ROOT"
# shellcheck source=/dev/null
source scripts/env.sh
load_agentx_env
require_agentx_env KUBE_CONTEXT NAMESPACE MODEL URL AIPERF_IMAGE RESULTS_PVC RESULTS_PREFIX

read -r -a concurrencies <<<"${SWEEP_CONCURRENCIES:-16 32 64}"
duration="${DURATION_SECONDS:-1800}"
results_mount="${RESULTS_MOUNT:-/results}"
pvc_sync_sec="${ZHU_SWEEP_PVC_SYNC_SEC:-120}"
dspark_refresh_sec="${ZHU_SWEEP_DSPARK_REFRESH_SEC:-60}"

[[ "$sweep" =~ ^[A-Za-z0-9._-]+$ ]] || { echo "ERROR: sweep name must be [A-Za-z0-9._-]" >&2; exit 2; }

config_dir="${AGENTX_ROOT}/results/.artifacts/sweeps/${sweep}/results_${config}"
mkdir -p "$config_dir"
manifest="${config_dir}/manifest.jsonl"
sweep_log="${config_dir}/zhu-sweep.live.log"

exec > >(tee -a "$sweep_log") 2>&1

log() { echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) zhu-sweep: $*"; }

helper=""
helper_manifest=""
capture_pids=()
capture_running=""

cleanup_captures() {
  [[ -n "$capture_running" ]] && rm -f "$capture_running"
  local pid
  for pid in "${capture_pids[@]:-}"; do
    kill "$pid" 2>/dev/null || true
  done
  capture_pids=()
  wait 2>/dev/null || true
}

start_results_helper() {
  [[ -n "$helper" ]] && return 0
  helper="zhu-sweep-cp-$(date -u +%Y%m%d%H%M%S)"
  helper_manifest="$(mktemp)"
  cat >"$helper_manifest" <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: ${helper}
  namespace: ${NAMESPACE}
spec:
  restartPolicy: Never
  containers:
    - name: results
      image: busybox:1.37
      command: [sh, -c, "sleep 7200"]
      volumeMounts:
        - name: results
          mountPath: ${results_mount}
  volumes:
    - name: results
      persistentVolumeClaim:
        claimName: ${RESULTS_PVC}
EOF
  k apply -f "$helper_manifest" >/dev/null
  k wait --for=condition=Ready "pod/$helper" --timeout=3m >/dev/null
  rm -f "$helper_manifest"
  helper_manifest=""
}

stop_results_helper() {
  cleanup_captures
  [[ -n "$helper" ]] || return 0
  k delete pod "$helper" --ignore-not-found --wait=false >/dev/null 2>&1 || true
  helper=""
}

trap stop_results_helper EXIT

copy_pvc_path() {
  local remote_rel="$1" local_path="$2"
  [[ -n "${helper:-}" ]] || start_results_helper
  mkdir -p "$(dirname "$local_path")"
  k cp "${helper}:${results_mount}/${remote_rel}" "$local_path" 2>/dev/null
}

copy_pvc_dir() {
  local remote_rel="$1" local_dir="$2"
  [[ -n "${helper:-}" ]] || start_results_helper
  mkdir -p "$local_dir"
  k cp "${helper}:${results_mount}/${remote_rel}/." "$local_dir/" 2>/dev/null
}

extract_dspark_snapshot() {
  local log_dir="$1" out="$2"
  : >"$out"
  [[ -d "$log_dir" ]] || return 0
  if command -v rg >/dev/null 2>&1; then
    rg -h 'Mean acceptance length|Per-position acceptance rate|Avg Draft acceptance rate|Num successful transfers|External prefix cache hit rate|Draft acceptance' \
      "$log_dir" >>"$out" 2>/dev/null || true
  else
    grep -hE 'Mean acceptance length|Per-position acceptance rate|Avg Draft acceptance rate|Num successful transfers|External prefix cache hit rate|Draft acceptance' \
      "$log_dir"/*.log >>"$out" 2>/dev/null || true
  fi
}

start_server_log_followers() {
  local selector="$1" out_dir="$2"
  mkdir -p "$out_dir"
  local pod container logfile
  while IFS= read -r pod; do
    [[ -n "$pod" ]] || continue
    for container in $(k get pod "$pod" -o jsonpath='{.spec.containers[*].name}' 2>/dev/null); do
      logfile="${out_dir}/${pod}-${container}.live.log"
      : >"$logfile"
      k logs -f "$pod" -c "$container" >>"$logfile" 2>&1 &
      capture_pids+=("$!")
      log "  follow $pod/$container -> ${logfile##*/}"
    done
  done < <(k get pods -l "$selector" -o jsonpath='{.items[*].metadata.name}' 2>/dev/null | tr ' ' '\n')
}

start_aiperf_job_follower() {
  local concurrency="$1" out_file="$2"
  mkdir -p "$(dirname "$out_file")"
  : >"$out_file"
  (
    local pod="" seen=""
    while [[ -f "$capture_running" ]]; do
      pod="$(k get pods -l 'app.kubernetes.io/name=agentx-aiperf' \
        --sort-by=.metadata.creationTimestamp \
        -o jsonpath='{.items[-1].metadata.name}' 2>/dev/null || true)"
      if [[ -n "$pod" && "$pod" != agentx-c${concurrency}-* ]]; then
        pod=""
      fi
      if [[ -n "$pod" && "$pod" != "$seen" ]]; then
        seen="$pod"
        log "  follow aiperf job pod $pod -> ${out_file##*/}"
        k logs -f "$pod" >>"$out_file" 2>&1 || true
        break
      fi
      sleep 3
    done
  ) &
  capture_pids+=("$!")
}

start_pvc_sync_loop() {
  local remote_rel="$1" point_dir="$2"
  (
    while [[ -f "$capture_running" ]]; do
      copy_pvc_path "${remote_rel}/logs/aiperf.log" "${point_dir}/logs/aiperf.live.log" || true
      if copy_pvc_path "${remote_rel}/profile_export_aiperf.json" "${point_dir}/profile_export_aiperf.live.json"; then
        :
      fi
      sleep "$pvc_sync_sec"
    done
  ) &
  capture_pids+=("$!")
}

start_dspark_refresh_loop() {
  local server_log_dir="$1" out_file="$2"
  (
    while [[ -f "$capture_running" ]]; do
      extract_dspark_snapshot "$server_log_dir" "$out_file"
      sleep "$dspark_refresh_sec"
    done
  ) &
  capture_pids+=("$!")
}

start_point_capture() {
  local selector="$1" concurrency="$2" point_dir="$3" remote_rel="$4"
  mkdir -p "${point_dir}/logs/server" "${point_dir}/logs"
  capture_running="${point_dir}/.capturing"
  : >"$capture_running"
  capture_pids=()
  log "c=$concurrency: start live capture (pvc sync every ${pvc_sync_sec}s, dspark every ${dspark_refresh_sec}s)"
  start_server_log_followers "$selector" "${point_dir}/logs/server"
  start_aiperf_job_follower "$concurrency" "${point_dir}/logs/aiperf-client.live.log"
  start_pvc_sync_loop "$remote_rel" "$point_dir"
  start_dspark_refresh_loop "${point_dir}/logs/server" "${point_dir}/dspark-snapshot.live.txt"
}

stop_point_capture() {
  rm -f "${capture_running:-}"
  cleanup_captures
  capture_running=""
}

save_deploy_metadata() {
  local selector="$1"
  render_model "$spec" >"$config_dir/manifest.yaml"
  scripts/vllm-args.sh "$spec" >"$config_dir/vllm-args.yaml"
  printf '%s\n' "$config" >"$config_dir/config_name.txt"
  k get pods -l "$selector" -o jsonpath='{.items[*].metadata.name}' | tr ' ' '|' >"$config_dir/pods.txt"
  manifesto config export models "$spec" -o "$config_dir/spec.yaml" --force >/dev/null
  grep -m1 '^  label:' "$config_dir/spec.yaml" | awk '{print $2}' >"$config_dir/model_label.txt" || true
  k get pods -l "$selector" -o jsonpath='{.items[0].spec.containers[?(@.name=="vllm")].image}' \
    >"$config_dir/vllm_image.txt"
  scripts/vllm-build-info.sh "$selector" >"$config_dir/vllm_env.txt" || true
  scripts/kv-cache-info.sh "$selector" >"$config_dir/kv-cache.yaml" || true
  if [[ -x scripts/save-run-context.sh ]]; then
    scripts/save-run-context.sh "$config_dir" "$selector" || true
  fi
  cat >"$config_dir/sweep-config.env" <<EOF
# zhu-sweep $(date -u +%Y-%m-%dT%H:%M:%SZ)
sweep=${sweep}
spec=${spec}
SWEEP_CONCURRENCIES=${concurrencies[*]}
DURATION_SECONDS=${duration}
TOKENIZER=${TOKENIZER:-zai-org/GLM-5.3}
MODEL_REVISION=${MODEL_REVISION:-30333038ada1f1dacb294a93270305a890b50c14}
MODEL=${MODEL}
URL=${URL}
RESULTS_PVC=${RESULTS_PVC}
RESULTS_PREFIX=${RESULTS_PREFIX}
EOF
}

log "sweep=$sweep spec=$spec concurrencies=[${concurrencies[*]}] duration=${duration}s -> $config_dir"

failed=()
if [[ "${ZHU_SWEEP_SKIP_DEPLOY:-0}" != "1" ]]; then
  log "teardown all + deploy $spec"
  scripts/teardown-model.sh --all
  bash "$PCP_DIR/scripts/zhu-deploy-model.sh" "$spec"
else
  log "ZHU_SWEEP_SKIP_DEPLOY=1 — reusing current deploy"
fi

selector="$(instance_selector "$spec")"
save_deploy_metadata "$selector"

for c in "${concurrencies[@]}"; do
  artifact_subdir="${sweep}/results_${config}/results_${config}_c${c}"
  point_dir="${config_dir}/results_${config}_c${c}"
  remote_rel="${RESULTS_PREFIX}/${artifact_subdir}"

  log "======== c=$c -> $point_dir"
  started_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  started_epoch="$(date +%s)"
  rc=0

  start_point_capture "$selector" "$c" "$point_dir" "$remote_rel"
  if ! CONCURRENCY="$c" DURATION_SECONDS="$duration" \
    ARTIFACT_SUBDIR="$artifact_subdir" scripts/direct-run.sh; then
    rc=1
    failed+=("${config}_c${c}")
  fi
  stop_point_capture

  ended_epoch="$(date +%s)"
  ended_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

  log "c=$c: final PVC copy from ${remote_rel}"
  if ! copy_pvc_dir "$remote_rel" "$point_dir"; then
    log "WARN: final PVC copy failed for c=$c"
    rc=1
  fi
  extract_dspark_snapshot "${point_dir}/logs/server" "${point_dir}/dspark-snapshot.txt"

  python3 - "$point_dir/run_meta.json" "$manifest" <<PY
import json, sys
meta = {
    "version": "zhu-sweep",
    "concurrency": int("$c"),
    "exit_code": int("$rc"),
    "started_at": "$started_at",
    "ended_at": "$ended_at",
    "duration_sec": int("$ended_epoch") - int("$started_epoch"),
    "local_dir": "$point_dir",
    "pvc_path": "$remote_rel",
    "artifact_subdir": "$artifact_subdir",
    "live_capture": True,
}
open(sys.argv[1], "w").write(json.dumps(meta, indent=2) + "\n")
with open(sys.argv[2], "a") as fh:
    fh.write(json.dumps(meta) + "\n")
PY

  if [[ "$rc" -ne 0 ]]; then
    log "WARN: c=$c failed (exit $rc)"
  else
    log "c=$c done in $((ended_epoch - started_epoch))s"
  fi
done

stop_results_helper
trap - EXIT

if [[ "${ZHU_SWEEP_SKIP_TEARDOWN:-0}" != "1" ]]; then
  log "teardown $spec"
  scripts/teardown-model.sh "$spec"
else
  log "ZHU_SWEEP_SKIP_TEARDOWN=1 — leaving deploy up"
fi

log "manifest: $manifest"
log "sweep log: $sweep_log"
if [[ ${#failed[@]} -gt 0 ]]; then
  log "FAILED points: ${failed[*]}"
  exit 1
fi
log "OK"
