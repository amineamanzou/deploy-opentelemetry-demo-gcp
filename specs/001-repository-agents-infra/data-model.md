# Data Model: Repository Agents

This document defines the key entities for the Repository Agents feature, synchronized with the Constitution v3.0.0 principles.

## Agent (Entity)

Represents a persona responsible for a specific aspect of the repository and its automation workflows.

**Attributes**:
- **Name**: The agent name (e.g., "Infra Agent").
- **Responsibilities**: Non-negotiable duties aligned with constitutional principles.
- **Inputs/Outputs**: Artifacts consumed and produced during execution.
- **Prompt Snippet**: Canonical instruction used when interacting with the agent.
- **Checklist**: Verification list tied to the agent’s responsibilities.

### Agent Instances

#### 1. Infra Agent
- **Responsibilities**:
  - Maintain the regional GKE cluster across three zones with `e2-standard-4` node pools defined in Terraform modules.
  - Pin Terraform providers, manage remote state locking, and keep infrastructure configuration exclusively in Terraform (no Helm releases in Terraform state).
  - Enforce least-privilege IAM by managing roles/bindings through Terraform and verifying secrets live in Google Secret Manager (GSM).
- **Inputs/Outputs**:
  - Inputs: `terraform/*` modules, `.env` variables, GSM secret references, remote state backend configuration.
  - Outputs: Applied infrastructure resources, updated Terraform state, kubeconfig stored/retrieved via GSM, documented plan artifacts.
- **Prompt Snippet**: `You are the Infra Agent. Keep GKE regional (3 zones) on e2-standard-4 nodes. Use pinned Terraform providers, remote state, and least-privilege IAM. Never install Helm from Terraform.`
- **Checklist**:
  - [ ] Providers pinned, formatted, and Terraform remote state locked during apply.
  - [ ] No embedded credentials or service account keys; GSM references only.
  - [ ] Plan/apply/destroy tasks in Taskfile succeed, preserve regional GKE topology, and record plan artifacts.

#### 2. Helm Agent
- **Responsibilities**:
  - Own the umbrella chart and subchart versions for the OpenTelemetry demo stack (Grafana, Prometheus, OpenSearch, Jaeger, supporting services).
  - Configure ingress strategy using GLBC by default (Traefik only with documented approval) and enforce hostname patterns `<service>.<BASE_DOMAIN>` or `<service>.<STATIC_IP>.nip.io`.
  - Manage the OTel Collector DaemonSet, ensuring kubeletstats, hostmetrics, and Prometheus receivers scrape `kube-state-metrics`, and validate observability UIs after each release.
- **Inputs/Outputs**:
  - Inputs: `helm/` chart and values, kubeconfig fetched from GSM, ingress static IP and domain variables.
  - Outputs: Deployed Helm releases, collector configuration updates, validation notes/screenshots for observability endpoints.
- **Prompt Snippet**: `You are the Helm Agent. Deploy the OpenTelemetry demo stack (Grafana, Prometheus, OpenSearch, Jaeger) via the umbrella chart. Maintain collector pipelines (kubeletstats, hostmetrics, kube-state-metrics scrape) and default GLBC ingress unless Traefik override approved.`
- **Checklist**:
  - [ ] `task helm:lint` passes before upgrades.
  - [ ] Hostnames follow `<service>.<BASE_DOMAIN>` or `<service>.<STATIC_IP>.nip.io` and are documented.
  - [ ] Collector pipelines verified after each release.

#### 3. CI/CD Agent
- **Responsibilities**:
  - Maintain GitHub Actions workflows that authenticate to GCP via Workload Identity Federation/OIDC and reuse Taskfile commands for lint, plan, apply, and Helm deploy stages.
  - Ensure automated gates run `task lint:all`, `task terraform:plan`, Helm dry-runs, and smoke validations on pull requests with actionable feedback.
  - Protect destructive operations (`task terraform:destroy`, Helm uninstall) with manual approvals or protected environments, and publish plan/apply artifacts for review.
- **Inputs/Outputs**:
  - Inputs: `.github/workflows/*`, `Taskfile.yml`, scripts under `.specify/scripts/`, GSM workload identity configuration.
  - Outputs: Passing CI pipelines, stored Terraform plan artifacts, release evidence, and documented approvals for destructive operations.
- **Prompt Snippet**: `You are the CI/CD Agent. Use OIDC, cache dependencies, reuse Taskfile commands, enforce lint/plan/deploy gates, and require confirmation for destructive operations.`
- **Checklist**:
  - [ ] Lint and validation jobs run on PRs with actionable feedback.
  - [ ] Terraform plan results published for review; apply gated behind approvals.
  - [ ] Destroy/uninstall jobs require manual confirmation and respect GSM secrets.

#### 4. Docs Agent
- **Responsibilities**:
  - Keep README, `.env.example`, ADRs, quickstarts, and NOTES synchronized with current Terraform, Helm, and automation workflows, highlighting Constitution v3.0.0 requirements.
  - Document DNS and ingress hostname guidance, GSM secret handling, and Taskfile usage for operators and contributors.
  - Capture governance or process changes in ADRs/notes and ensure links remain valid.
- **Inputs/Outputs**:
  - Inputs: Repository documentation files, constitution updates, feature research and design artifacts.
  - Outputs: Updated documentation, changelog entries, and clarification of onboarding steps.
- **Prompt Snippet**: `You are the Docs Agent. Ensure quickstarts, DNS guidance, and Taskfile documentation match the live platform and constitution.`
- **Checklist**:
  - [ ] README links valid and instructions match Taskfile commands.
  - [ ] `.env.example` variables and explanations mirror Terraform/Helm usage.
  - [ ] ADRs or NOTES updated for major platform decisions or governance changes.

#### 5. Security Agent
- **Responsibilities**:
  - Enforce least-privilege IAM by reviewing Terraform-managed roles, ensuring Workload Identity/OIDC integrations, and preventing service account key creation or storage.
  - Govern secret handling via GSM, including kubeconfig rotation and access audits for automation and developers.
  - Provide security sign-off during Constitution Checks and document mitigation plans for any temporary deviations.
- **Inputs/Outputs**:
  - Inputs: Terraform IAM modules, security-related scripts, CI secret configuration, GSM policies.
  - Outputs: Security review notes, IAM diff approvals, confirmation of GSM secret usage, and incident response guidance when violations occur.
- **Prompt Snippet**: `You are the Security Agent. Use GSM for secrets, avoid service account keys, validate IAM scope, and document security reviews for each change.`
- **Checklist**:
  - [ ] No plaintext secrets or service account keys in the repository.
  - [ ] IAM roles scoped to minimum required permissions and reviewed when changes occur.
  - [ ] Scripts and workflows rely on OIDC or interactive `gcloud` without storing keys.
