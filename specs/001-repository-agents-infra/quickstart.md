# Quickstart: Interacting with Repository Agents

This guide explains how to collaborate with each agent while honoring Constitution v3.0.0 principles.

## 1. Infra Agent

```
You are the Infra Agent. Keep GKE regional (3 zones) on e2-standard-4 nodes. Use pinned Terraform providers, remote state, and least-privilege IAM. Never install Helm from Terraform.
```

Steps:
1. Ensure `.env` has `GCP_PROJECT_ID`, Terraform remote state backend settings, and GSM secret names populated.
2. Run `task terraform:init` and `task terraform:plan` to produce the RED phase (plan must be reviewed before apply).
3. After approval, execute `task terraform:apply` and store kubeconfig with `task kubeconfig:store` (writes to GSM).
4. Capture plan artifacts and confirm the regional three-zone topology remains intact before handing off to other agents.

## 2. Helm Agent

```
You are the Helm Agent. Deploy the OpenTelemetry demo stack (Grafana, Prometheus, OpenSearch, Jaeger) via the umbrella chart. Maintain collector pipelines (kubeletstats, hostmetrics, kube-state-metrics scrape) and default GLBC ingress unless Traefik override approved.
```

Steps:
1. Fetch kubeconfig securely with `task kubeconfig:fetch` (reads from GSM).
2. Run `task helm:lint` and review output before upgrading.
3. Deploy or upgrade with `task helm:install -- --dry-run` first, then remove `--dry-run` when manifests look correct.
4. Verify Grafana, Prometheus, OpenSearch Dashboards, and Jaeger are reachable at `<service>.<BASE_DOMAIN>` (or `<service>.<STATIC_IP>.nip.io` when no domain).
5. Confirm the OTel Collector DaemonSet reports kubeletstats, hostmetrics, and kube-state-metrics scrape targets as healthy.

## 3. CI/CD Agent

```
You are the CI/CD Agent. Use OIDC, cache dependencies, reuse Taskfile commands, enforce lint/plan/deploy gates, and require confirmation for destructive operations.
```

Steps:
1. Mirror Taskfile commands in GitHub Actions (`task lint:all`, `task terraform:plan`, `task helm:install -- --dry-run`).
2. Configure Workload Identity Federation/OIDC in repository secrets and workflows.
3. Publish Terraform plan artifacts for reviewers and gate `terraform:apply`/`terraform:destroy` behind approvals.
4. Ensure destructive jobs prompt for confirmation and are restricted to protected environments.

## 4. Docs Agent

```
You are the Docs Agent. Ensure quickstarts, DNS guidance, and Taskfile documentation match the live platform and constitution.
```

Steps:
1. Update README, `.env.example`, and docs/quickstart instructions whenever inputs, outputs, or commands change.
2. Maintain ADRs capturing major infra or governance decisions.
3. Verify links and references after each change and highlight ingress/DNS expectations for operators.

## 5. Security Agent

```
You are the Security Agent. Use GSM for secrets, avoid service account keys, validate IAM scope, and document security reviews for each change.
```

Steps:
1. Review Terraform IAM diffs for least-privilege scope on every change.
2. Confirm no service account keys are generated; rely on OIDC/Workload Identity and GSM secrets.
3. Document security review notes and inject them into PRs or CHANGELOG entries.
4. Trigger follow-up audits if temporary exceptions are granted.

## Validation Checklist
- Run `task lint:all` after collaborating with agents to ensure formatting and linting remain clean.
- Confirm Terraform/Helm outputs align with constitution gates before merging.
- Update Sync Impact Reports if governance or principle wording changes.
