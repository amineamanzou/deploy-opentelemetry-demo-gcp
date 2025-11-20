#!/usr/bin/env bash
set -euo pipefail

SECRET="$1"
FILE="$2"

gcloud container clusters get-credentials "$GKE_CLUSTER_NAME" --region "$GCP_REGION" --project "$GCP_PROJECT_ID"

if ! gcloud secrets describe "$SECRET" >/dev/null 2>&1; then
  gcloud secrets create "$SECRET" --replication-policy="automatic"
fi

gcloud secrets versions add "$SECRET" --data-file="$FILE"
echo "Stored kubeconfig in secret $SECRET"
