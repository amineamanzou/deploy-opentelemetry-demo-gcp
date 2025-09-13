#!/usr/bin/env bash
set -euo pipefail

SECRET="$1"
FILE="$2"

gcloud secrets versions access latest --secret="$SECRET" > "$FILE"
export KUBECONFIG="$FILE"

echo "Fetched kubeconfig to $FILE"
