# deploy-opentelemetry-demo-gcp Development Guidelines

Auto-generated from feature plans. Last updated: 2025-09-21

## Active Technologies
- Terraform 1.8.x with `hashicorp/google` provider 5.39+
- Helm 3.15+ deploying the OpenTelemetry demo umbrella chart
- Task 3.37+ orchestrating lint, plan, apply, Helm workflows
- Google Secret Manager (GSM) for kubeconfig and secret distribution

## Project Structure
```
terraform/               # Regional GKE (3 zones, e2-standard-4), networking, IAM, DNS
helm/                    # Umbrella chart, collector values, ingress configuration
.github/workflows/       # GitHub Actions (OIDC, lint/plan/apply/deploy, smoke)
.specify/                # Templates, scripts, constitution, agent guidance
specs/                   # Feature specs, research, plans, tasks per agent feature
Taskfile.yml             # Canonical command surface for automation
```

## Commands
- `task terraform:init|plan|apply|destroy` — Terraform source of truth workflows (plan artifacts required before apply/destroy)
- `task kubeconfig:store|fetch` — Write/read kubeconfig in GSM for cross-agent handoff
- `task helm:lint` & `task helm:install -- --dry-run` — Helm-only deployments for observability stack
- `task lint:all` — Aggregated lint (terraform fmt, tflint, helm lint, markdownlint, cspell)

## Code Style & Testing Expectations
- Enforce RED→GREEN→REFACTOR using `terraform plan -detailed-exitcode`, Helm lint, Terratest/helm unittest before implementation changes
- Structured JSON logs with correlation IDs for Terraform/Helm automation output (ingested by Loki)
- Document constitution deviations in Sync Impact Reports and PR descriptions

## Recent Changes
- 2025-09-21: Constitution v3.0.0 adopted; updated agent contracts, templates, and quickstart to align with regional GKE resilience, Helm-managed observability, automation safety gates, and secret hygiene.

<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->
