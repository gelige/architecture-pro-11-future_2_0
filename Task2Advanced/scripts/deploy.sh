#!/usr/bin/env bash
set -euo pipefail
umask 077

environment="${1:-}"
action="${2:-plan}"
if [[ ! "$environment" =~ ^(dev|stage|prod)$ || ! "$action" =~ ^(plan|apply)$ ]]; then
  echo 'Usage: bash Task2Advanced/scripts/deploy.sh dev|stage|prod [plan|apply]' >&2
  exit 1
fi

cd "$(dirname "$0")/.."
export TF_INPUT=false
export TF_WORKSPACE=default
export TF_DATA_DIR="$PWD/.terraform/$environment"

plan_file="$(mktemp "$PWD/plan-XXXXXX.tfplan")"
trap 'rm -f "$plan_file"' EXIT

terraform fmt -check -recursive .
terraform init -input=false -reconfigure -lockfile=readonly \
  -backend-config="bucket=${TF_STATE_BUCKET:?Set TF_STATE_BUCKET}" \
  -backend-config="key=Task2Advanced/$environment/terraform.tfstate"
terraform validate
terraform plan -input=false -lock-timeout=5m \
  -var-file="envs/$environment.tfvars" -out="$plan_file"

if [[ "$action" == apply ]]; then
  terraform apply -input=false -lock-timeout=5m "$plan_file"
fi
