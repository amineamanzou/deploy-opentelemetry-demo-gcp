# OpenTelemetry Demo on GKE

Proof-of-concept repo that provisions a regional GKE cluster and deploys the [OpenTelemetry Demo](https://github.com/open-telemetry/opentelemetry-demo) with Grafana, Prometheus, OpenSearch and Jaeger enabled.

## Prerequisites
- Google Cloud project with billing enabled
- [gcloud](https://cloud.google.com/sdk/docs/install), [terraform](https://developer.hashicorp.com/terraform/downloads), [kubectl](https://kubernetes.io/docs/tasks/tools/), [helm](https://helm.sh/docs/intro/install/)
- [Task](https://taskfile.dev/), `tflint`, `markdownlint-cli2`, `cspell`

## Environment Variables
Copy `.env.example` to `.env` and fill in values:

```bash
cp .env.example .env
```

Key variables:
- `GCP_PROJECT_ID` – your project ID
- `BASE_DOMAIN` – optional base DNS domain. When unset, ingress uses `nip.io` with the static IP
- `OTELDEMO_KUBECONFIG_SECRET` – name of GSM secret used for kubeconfig

## Usage

### Terraform
```bash
task terraform:init
task terraform:plan
# creates resources
task terraform:apply
# destroy with confirmation
task terraform:destroy
```
After `apply`, store kubeconfig:
```bash
task kubeconfig:store
```

### Helm
Fetch kubeconfig from GSM and install charts:
```bash
task kubeconfig:fetch
# deploy demo
task helm:install
# remove
task helm:uninstall
```

### Linting
Run all linters:
```bash
task lint:all
```

### DNS
If `BASE_DOMAIN` is set, Terraform creates a Cloud DNS managed zone. Delegate the zone to Google Cloud DNS by updating your registrar. Without `BASE_DOMAIN`, hostnames fall back to `<service>.<STATIC_IP>.nip.io`.

### GitHub Actions
Workflows provide linting, Terraform plan/apply, and Helm deployment using OIDC authentication. Set CI environment variables for Workload Identity Federation in repository secrets.

## Cleanup
To remove all resources:
```bash
task helm:uninstall
task terraform:destroy
```
