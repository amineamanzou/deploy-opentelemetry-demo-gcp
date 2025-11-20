#!/usr/bin/env bash
set -euo pipefail

show_usage() {
  cat <<'USAGE'
Usage: render_hostname.sh [--service NAME] [--context project|otel]

Without --service the script prints the domain suffix for the context. With --service it returns SERVICE.<suffix>.
Set ARGOCD_HOSTNAME or OTELDEMO_ROOT_DOMAIN to override computed values for each context.
USAGE
}

context="project"
service=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --context)
      context="$2"
      shift 2
      ;;
    --service)
      service="$2"
      shift 2
      ;;
    -h|--help)
      show_usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      show_usage >&2
      exit 1
      ;;
  esac
done

if [[ "$context" != "project" && "$context" != "otel" ]]; then
  echo "context must be 'project' or 'otel'" >&2
  exit 1
fi

# Allow explicit overrides
if [[ -n "$service" && "$context" == "project" && -n "${ARGOCD_HOSTNAME:-}" && "$service" == "argocd" ]]; then
  echo "$ARGOCD_HOSTNAME"
  exit 0
fi

if [[ -z "$service" && "$context" == "otel" && -n "${OTELDEMO_ROOT_DOMAIN:-}" ]]; then
  echo "$OTELDEMO_ROOT_DOMAIN"
  exit 0
fi

if [[ -z "$service" && "$context" == "project" && -n "${PROJECT_ROOT_DOMAIN:-}" ]]; then
  echo "$PROJECT_ROOT_DOMAIN"
  exit 0
fi

if [[ -z "${GCP_PROJECT_ID:-}" && -n "${BASE_DOMAIN:-}" ]]; then
  echo "GCP_PROJECT_ID must be set when BASE_DOMAIN is provided" >&2
  exit 1
fi

suffix=""
if [[ -n "${BASE_DOMAIN:-}" ]]; then
  if [[ "$context" == "otel" ]]; then
    suffix="oteldemo.${GCP_PROJECT_ID}.${BASE_DOMAIN}"
  else
    suffix="${GCP_PROJECT_ID}.${BASE_DOMAIN}"
  fi
else
  ingress_ip=$(terraform -chdir=terraform output -raw ingress_ip 2>/dev/null || true)
  if [[ -z "$ingress_ip" ]]; then
    echo "Unable to determine ingress IP. Run terraform apply or set OTELDEMO_ROOT_DOMAIN." >&2
    exit 1
  fi
  suffix="${ingress_ip}.nip.io"
fi

if [[ -n "$service" ]]; then
  echo "${service}.${suffix}"
else
  echo "$suffix"
fi
