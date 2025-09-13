#!/usr/bin/env bash
set -e

reqs=(gcloud terraform kubectl helm tflint node npm markdownlint-cli2 cspell)
miss=()
for c in "${reqs[@]}"; do
  command -v "$c" >/dev/null 2>&1 || miss+=("$c")
done
if [ ${#miss[@]} -ne 0 ]; then
  echo "Missing tools: ${miss[*]}"
  exit 1
fi
echo "All tools present."
