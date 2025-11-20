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
- `GITOPS_REPO_URL` / `GITOPS_TARGET_REVISION` – repo and branch/tag Argo CD should sync

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

### GitOps Bootstrap (Helm)

Fetch kubeconfig from GSM and bootstrap Argo CD, which in turn syncs the demo workloads:

```bash
task kubeconfig:fetch
task helm:install
```

`task helm:install` deploys the `helm/argocd-bootstrap` chart. This release installs Argo CD with an ingress and creates two Applications:

- `otel-demo` – points to the Helm chart under `helm/` in this repository (OpenTelemetry Demo + collector).
- `opentelemetry-operator` – tracks the upstream operator chart from `open-telemetry/opentelemetry-operator`.

Argo CD starts reconciling immediately. Check sync status with:

```bash
kubectl -n ${ARGOCD_NAMESPACE:-argocd} get applications
```

To remove Argo CD and halt GitOps reconciliation, run:

```bash
task helm:uninstall
```

### Linting

Run all linters:

```bash
task lint:all
```

### DNS & Hostnames

If `BASE_DOMAIN` is set, Terraform provisions a managed zone with a wildcard `*.${GCP_PROJECT_ID}.${BASE_DOMAIN}` record that targets the reserved global static IP. Delegate the zone to Google Cloud DNS by updating your registrar. Without `BASE_DOMAIN`, hostnames fall back to `<service>.<STATIC_IP>.nip.io` once the IP is allocated.

`scripts/render_hostname.sh` computes both patterns automatically. Override the defaults by setting `OTELDEMO_ROOT_DOMAIN` or `ARGOCD_HOSTNAME` in `.env` if you need custom naming.

### Ingress Endpoints

GLBC (GCE) Ingress exposes the following hosts:

- `app.oteldemo.${GCP_PROJECT_ID}.${BASE_DOMAIN}` – web storefront
- `grafana.oteldemo.${GCP_PROJECT_ID}.${BASE_DOMAIN}` – Grafana UI
- `prometheus.oteldemo.${GCP_PROJECT_ID}.${BASE_DOMAIN}` – Prometheus UI
- `jaeger.oteldemo.${GCP_PROJECT_ID}.${BASE_DOMAIN}` – Jaeger query UI
- `opensearch.oteldemo.${GCP_PROJECT_ID}.${BASE_DOMAIN}` – OpenSearch Dashboards
- `argocd.${GCP_PROJECT_ID}.${BASE_DOMAIN}` – Argo CD UI

When `BASE_DOMAIN` is unset, the same hosts are rendered against `<STATIC_IP>.nip.io`. Update `helm/values.yaml` (for new services) or `helm/argocd-bootstrap/values.yaml` (for additional Applications) if you need more endpoints or custom routing.

### GitHub Actions

Workflows provide linting, Terraform plan/apply, and Helm deployment using OIDC authentication. Set CI environment variables for Workload Identity Federation in repository secrets.

## Cleanup

To remove all resources:

```bash
task helm:uninstall
task terraform:destroy
```
