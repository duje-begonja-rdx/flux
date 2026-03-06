#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

run_step() {
  local step="$1"
  "$SCRIPT_DIR/$step"
}

echo "Choose what to execute:"
echo "1) Create k3d cluster"
echo "2) Install Flux Operator"
echo "3) Apply FluxInstance"
echo "4) Run all (1 -> 2 -> 3)"
echo "q) Quit"
read -r -p "Selection: " choice

case "$choice" in
  1) run_step "1-create-k3d-cluster.sh" ;;
  2) run_step "2-install-flux-operator.sh" ;;
  3) run_step "3-apply-flux-instance.sh" ;;
  4)
    run_step "1-create-k3d-cluster.sh"
    run_step "2-install-flux-operator.sh"
    run_step "3-apply-flux-instance.sh"
    ;;
  q|Q) exit 0 ;;
  *) echo "Invalid selection: $choice" >&2; exit 1 ;;
esac
