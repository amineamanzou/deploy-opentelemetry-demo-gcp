# Research for Repository Agents Feature

## 1. Versioning Strategy

**Decision**: Adopt semantic versioning `MAJOR.MINOR.PATCH` across Terraform modules, Helm chart packages, and documentation, using constitution v3.0.0 as the authoritative baseline for governance changes.
**Rationale**: Aligns with constitution governance rules and enables clear communication of breaking infra or process changes; Terraform and Helm both support SemVer tagging and changelog workflows.
**Alternatives considered**:
- Calendar versioning (e.g., YYYY.MM.DD) — rejected because it obscures breaking vs. minor documentation changes.
- Separate version streams per subsystem — rejected to avoid divergence between Terraform, Helm, and docs guidance.

**Research Tasks Completed**:
- Reviewed HashiCorp guidance on module versioning and Helm SemVer recommendations.
- Defined bump rules: MAJOR for principle redefinitions or incompatible infra guidance, MINOR for new agent responsibilities or added docs, PATCH for corrections/typo fixes.
- Documented requirement to record version bumps in Sync Impact Report and release notes.

## 2. TDD Enforcement in IaC

**Decision**: Enforce a RED→GREEN→REFACTOR lifecycle using `task terraform:plan` with `terraform plan -detailed-exitcode`, `helm lint`, and repository lint suites as the failure-first gates; add Terratest and Helm unittest hooks where functional coverage is required.
**Rationale**: Plans and linting expose drift before apply, satisfying "tests fail first" for infra; automated Terratest suites provide executable tests for modules and Helm templates, enabling measurable RED/GREEN cycles.
**Alternatives considered**:
- Manual review without automated tests — rejected due to inconsistency and inability to guarantee RED phase.
- Custom shell scripts per feature — rejected because Taskfile targets already centralize the workflow and keep automation maintainable.

**Research Tasks Completed**:
- Validated `terraform plan -detailed-exitcode` usage for failing on drift or new resources.
- Confirmed Terratest patterns for GKE module validation and Helm unittest plugin availability.
- Established rule: write or update tests/plan expectations before modifying Terraform/Helm code; ensure CI workflows execute these gates on every PR.

## 3. Performance Goals

**Decision**: Set infrastructure automation targets of ≤10 minutes for Terraform plan, ≤15 minutes for Terraform apply on a clean environment, ≤8 minutes for Helm install/upgrade, and ≤2 minutes for lint suites; track deviations via CI metrics.
**Rationale**: Provides actionable SLOs for operator expectations while accounting for regional GKE provisioning times; aligns with observability goals to detect regressions quickly.
**Alternatives considered**:
- No explicit timing goals — rejected because it hinders early detection of regressions or quota issues.
- Aggressive sub-minute targets — rejected as unrealistic for regional GKE operations.

**Research Tasks Completed**:
- Benchmarked prior runs and community references for GKE regional cluster creation timings.
- Documented expectation that long-running applies require issue tracking and capacity review.

## 4. Technology Versions

**Decision**: Standardize on Terraform 1.8.x, Google provider 5.39+, Helm 3.15+, Task 3.37+, kubectl 1.30+, gcloud 480+, and Helm chart dependencies pinned via `Chart.lock`.
**Rationale**: Matches current stable releases with long-term support, ensuring compatibility with GKE 1.30 control planes and modern OIDC integrations.
**Alternatives considered**:
- Staying on Terraform 1.6.x / Helm 3.12 — rejected to avoid missing critical bug fixes and security patches.
- Auto-updating to latest nightly/tool versions — rejected to maintain reproducibility.

**Research Tasks Completed**:
- Reviewed release notes for Terraform 1.8.x, Helm 3.15, and GKE compatibility matrix.
- Confirmed Task and kubectl versions supported on macOS/Linux developer environments.

## 5. Observability - Error Context

**Decision**: Require all automation to emit structured JSON logs with correlation IDs, include Terraform workspace, Helm release, and Kubernetes namespace metadata, and publish failure summaries to Grafana Loki dashboards linked from the quickstart.
**Rationale**: Structured, contextual logs accelerate triage for failed applies or releases and satisfy the constitution’s observability mandate.
**Alternatives considered**:
- Plain stdout logging — rejected because it lacks searchable context in centralized logging.
- Only referencing cloud provider logs — rejected as it fragments troubleshooting workflows.

**Research Tasks Completed**:
- Identified existing Loki stack in the OpenTelemetry demo and confirmed compatibility with JSON logs.
- Collected guidance for surfacing Terraform/Helm command output via Taskfile wrappers and CI artifacts.
