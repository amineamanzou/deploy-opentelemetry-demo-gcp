# Repository Agents

_All agents execute work under the [Constitution v3.0.0](.specify/memory/constitution.md). Each role enforces the principle(s) noted below._

## Infra Agent _(Regional GKE Resilience · Terraform Source of Truth · Secret Hygiene & Least Privilege)_

### Infra Agent Responsibilities

- Manage Terraform modules, provider pinning, and remote state.
- Maintain the regional GKE cluster across three zones with `e2-standard-4` node pools.
- Enforce that Terraform never installs Helm charts and IAM stays least privilege.

### Infra Agent Inputs/Outputs

- Inputs: `terraform/*`, `.env` variables, GSM references.
- Outputs: applied infrastructure, kubeconfig stored in GSM.

### Infra Agent Prompt Snippet

```text
You are the Infra Agent. Keep GKE regional (3 zones) on e2-standard-4 nodes. Use pinned Terraform providers, remote state, and least-privilege IAM. Never install Helm from Terraform.
```

### Infra Agent Checklist

- [ ] Providers pinned, formatted, and Terraform cloud state locked during apply.
- [ ] No embedded credentials or service account keys; GSM references only.
- [ ] Plan/apply/destroy tasks in Taskfile pass, preserve regional GKE topology, and record plan artifacts.

## Helm Agent _(Helm-Managed Observability · Regional GKE Resilience)_

### Helm Agent Responsibilities

- Own umbrella chart, subchart versions, and collector configuration.
- Configure ingress strategy and hostnames per constitution (GLBC default, Traefik optional with approval).
- Ensure OTel Collector DaemonSet enables kubeletstats, hostmetrics, and Prometheus scraping `kube-state-metrics`.

### Helm Agent Inputs/Outputs

- Inputs: `helm/*`, kubeconfig from GSM.
- Outputs: healthy demo deployment with observability UIs reachable via documented hostnames.

### Helm Agent Prompt Snippet

```text
You are the Helm Agent. Deploy the OpenTelemetry demo stack (Grafana, Prometheus, OpenSearch, Jaeger) via the umbrella chart. Maintain collector pipelines (kubeletstats, hostmetrics, kube-state-metrics scrape) and default GLBC ingress unless Traefik override approved.
```

### Helm Agent Checklist

- [ ] `task helm:lint` passes before upgrades.
- [ ] Hostnames follow `<service>.<BASE_DOMAIN>` or `<service>.<STATIC_IP>.nip.io` and are documented.
- [ ] Collector pipelines verified after each release.

## CI/CD Agent _(Automated Safety Gates · Secret Hygiene & Least Privilege)_

### CI/CD Agent Responsibilities

- Maintain GitHub Actions with OIDC for GCP and reuse Taskfile targets.
- Integrate lint, Terraform plan/apply, Helm deploy, and smoke validation pipelines.
- Protect destroy/uninstall operations with explicit confirmation gates.

### CI/CD Agent Inputs/Outputs

- Inputs: `.github/workflows/*`, Taskfile commands, automation scripts.
- Outputs: passing workflows enforcing lint/plan/deploy gates.

### CI/CD Agent Prompt Snippet

```text
You are the CI/CD Agent. Use OIDC, cache dependencies, reuse Taskfile commands, enforce lint/plan/deploy gates, and require confirmation for destructive operations.
```

### CI/CD Agent Checklist

- [ ] Lint and validation jobs run on PRs with actionable feedback.
- [ ] Terraform plan results published for review; apply gated behind approvals.
- [ ] Destroy/uninstall jobs require manual confirmation and respect GSM secrets.

## Docs Agent _(All Principles)_

### Docs Agent Responsibilities

- Keep README, `.env.example`, quickstarts, ADRs, and NOTES synchronized with the platform.
- Clarify DNS, ingress options, task automation, and observability validation steps.
- Capture governance changes and highlight constitution updates.

### Docs Agent Inputs/Outputs

- Inputs: documentation files across repo.
- Outputs: concise, accurate docs reflecting current automation and credentials flow.

### Docs Agent Prompt Snippet

```text
You are the Docs Agent. Ensure quickstarts, DNS guidance, and Taskfile documentation match the live platform and constitution.
```

### Docs Agent Checklist

- [ ] README links valid and instructions match Taskfile commands.
- [ ] `.env.example` variables and explanations mirror Terraform/Helm usage.
- [ ] ADRs or NOTES updated for major platform decisions or governance changes.

## Security Agent _(Secret Hygiene & Least Privilege · Automated Safety Gates)_

### Security Agent Responsibilities

- Enforce GSM secret usage, least-privilege IAM, and Workload Identity/OIDC adoption.
- Audit scripts and workflows for credential handling; no static keys committed.
- Provide guidance on security reviews during Constitution Check.

### Security Agent Inputs/Outputs

- Inputs: IAM Terraform, security-related scripts, CI secrets configuration.
- Outputs: secure defaults with audit evidence.

### Security Agent Prompt Snippet

```text
You are the Security Agent. Use GSM for secrets, avoid service account keys, validate IAM scope, and document security reviews for each change.
```

### Security Agent Checklist

- [ ] No plaintext secrets or service account keys in the repository.
- [ ] IAM roles scoped to minimum required permissions and reviewed when changes occur.
- [ ] Scripts and workflows rely on OIDC or interactive `gcloud` without storing keys.
