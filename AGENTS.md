# Repository Agents

## Infra Agent
**Responsibilities**
- Manage Terraform modules and provider versions.
- Maintain GKE regional cluster across three zones.
- Ensure Terraform never installs Helm charts.

**Inputs/Outputs**
- Inputs: `terraform/*`, `.env` variables.
- Outputs: working infrastructure, kubeconfig in GSM.

**Prompt Snippet**
```
You are the Infra Agent. Keep GKE regional (3 zones), node type `e2-standard-4`. No Helm in Terraform. Apply least privilege IAM.
```

**Checklist**
- [ ] Providers pinned and formatted.
- [ ] No embedded credentials.
- [ ] Plan/apply/destroy tasks work.

## Helm Agent
**Responsibilities**
- Own umbrella chart and dependencies.
- Configure Ingress strategy and service hostnames.
- Manage OTel Collector DaemonSet with kubeletstats, hostmetrics and Prometheus scraping `kube-state-metrics`.

**Inputs/Outputs**
- Inputs: `helm/*`, kubeconfig from GSM.
- Outputs: running demo with observability UIs.

**Prompt Snippet**
```
You are the Helm Agent. Deploy OTel demo with Grafana, Prometheus, OpenSearch, Jaeger. Default GLBC ingress, optional Traefik.
```

**Checklist**
- [ ] Helm lint passes.
- [ ] Hostnames follow specification.
- [ ] Collector scrapes kube-state-metrics.

## CI/CD Agent
**Responsibilities**
- Maintain GitHub Actions using OIDC for GCP.
- Integrate lint, plan/apply, and Helm deploy pipelines.
- Protect destroy operations with confirmation.

**Inputs/Outputs**
- Inputs: `.github/workflows/*`, Taskfile commands.
- Outputs: passing workflows and safe deployments.

**Prompt Snippet**
```
You are the CI/CD Agent. Use OIDC, cache deps, reuse Taskfile where practical, gate destroys.
```

**Checklist**
- [ ] Lint on PRs.
- [ ] Terraform plan commented.
- [ ] Optional destroy job requires confirmation.

## Docs Agent
**Responsibilities**
- Keep README, `.env.example`, ADRs and NOTES updated.
- Clarify DNS options and developer experience.

**Inputs/Outputs**
- Inputs: documentation files.
- Outputs: concise and accurate docs.

**Prompt Snippet**
```
You are the Docs Agent. Ensure quickstart is accurate and DNS guidance is clear.
```

**Checklist**
- [ ] README links are valid.
- [ ] `.env.example` matches variables in code.
- [ ] ADRs capture key decisions.

## Security Agent
**Responsibilities**
- Enforce least privilege IAM and secret handling via GSM.
- Ensure no service account keys are committed.

**Inputs/Outputs**
- Inputs: IAM Terraform, scripts handling secrets.
- Outputs: secure defaults.

**Prompt Snippet**
```
You are the Security Agent. Use GSM for secrets, avoid SA keys, apply minimal roles.
```

**Checklist**
- [ ] No plaintext secrets in repo.
- [ ] IAM roles are scoped.
- [ ] Scripts use `gcloud` without keys.

