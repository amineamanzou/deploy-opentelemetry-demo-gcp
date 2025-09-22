# Implementation Plan: Repository Agents

**Branch**: `001-repository-agents-infra` | **Date**: 2025-09-21 | **Spec**: specs/001-repository-agents-infra/spec.md
**Input**: Feature specification from `/specs/001-repository-agents-infra/spec.md`

## Execution Flow (/plan command scope)
```
1. Load feature spec from Input path
   → If not found: ERROR "No feature spec at {path}"
2. Collect technical context from repository docs
   → Terraform modules (terraform/), Helm chart (helm/), Taskfile commands
   → Identify impacted agents (Infra, Helm, CI/CD, Docs, Security)
3. Populate Constitution Check with verifications for all principles (GKE resilience, Terraform source of truth, Helm observability, automation gates, secret hygiene)
   → If any item fails: document mitigation or STOP with required follow-up
4. Record Initial Constitution Check result in Progress Tracking
5. Phase 0: Research requirements and unknowns (e.g., GCP services, Helm values, IAM roles)
   → Mark any unresolved questions as NEEDS CLARIFICATION
6. Phase 1: Design changes across Terraform, Helm, CI, and Docs areas
   → Outline module updates, Helm value changes, Taskfile/workflow updates, documentation impacts
   → Update `AGENTS.md` and relevant agent guidance if responsibilities change
7. Re-run Constitution Check with updated design
   → If violations remain: iterate on design or flag blockers before proceeding
8. Describe Phase 2 task generation strategy (do NOT create tasks.md)
9. STOP - Ready for /tasks command
```

**IMPORTANT**: The /plan command STOPS at step 8. Downstream commands:
- Phase 2: /tasks command creates tasks.md
- Phase 3+: Implementation and validation follow tasks.md

## Summary
Document and synchronize repository agent contracts, data models, templates, and guidance so they fully embody Constitution v3.0.0 (regional GKE resilience, Terraform-first infra, Helm-managed observability, automation safety gates, and secret hygiene). Outputs include refreshed specs, quickstart, templates, and lint validation.

## Technical Context
**Infrastructure Scope**: Terraform configuration under `terraform/` defines GKE regional cluster, networking, IAM, DNS, static IP. Updates focus on documentation of these modules rather than new resources.  
**Runtime Scope**: Helm umbrella chart in `helm/` deploys the OpenTelemetry demo stack with collector pipelines; guidance must clarify kube-state-metrics scraping and ingress host rules.  
**Automation Scope**: Taskfile targets (`task terraform:*`, `task helm:*`, `task lint:*`) and GitHub Actions workflows enforce lint/plan/apply/deploy gates with OIDC authentication.  
**Security Scope**: Google Secret Manager stores kubeconfig and other secrets; IAM bindings managed via Terraform must maintain least-privilege; no service account keys allowed.  
**Dependencies**: Terraform ≥1.6, Helm ≥3.13, Task ≥3, gcloud SDK, GSM access, markdownlint, cspell, tflint.  
**Risk & Blast Radius**: Low — documentation and process alignment only; no infrastructure changes, but incorrect guidance could mislead future automation.  
**Open Questions**: Original constitution ratification date unknown (needs historical research).

## Constitution Check
*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Regional GKE Resilience: ✅ No infra changes; documentation will reinforce three-zone GKE with `e2-standard-4` node pools managed via Terraform.
- Terraform Source of Truth: ✅ Work limited to documents/templates emphasizing Terraform-managed infra; no Helm via Terraform introduced.
- Helm-Managed Observability: ✅ Contracts and docs already use Helm umbrella chart; updates will ensure collector receivers and ingress strategy are explicit.
- Automated Safety Gates: ✅ Plan includes Taskfile/GitHub Actions references, ensuring lint, plan, and approvals remain required; no bypass introduced.
- Secret Hygiene & Least Privilege: ✅ Guidance continues to require GSM and minimal IAM; research task will clarify any outstanding security details.

## Repository Areas
```
terraform/               # GCP infrastructure modules and state configuration
helm/                    # Umbrella chart and values for observability stack
.github/workflows/       # CI/CD pipelines (OIDC, lint, plan/apply, deploy)
Taskfile.yml             # Task automation entry points
README.md, docs/         # Developer and operator documentation
.specify/                # Templates, scripts, and constitution
```

**Structure Decision**: Work spans Terraform (docs + templates), Helm (contracts/guidance), CI/CD automation, documentation, and security processes. No new source-code directories required.

## Phase 0: Outline & Research
1. **Identify unknowns** from Technical Context → create research tasks per domain (Terraform versions, IaC TDD workflow, performance metrics, observability error context).
2. **Gather references**:
   - HashiCorp Terraform and Google provider docs for versioning guidance
   - Helm/OTel collector documentation for receiver requirements
   - Google Cloud GSM/IAM best practices
   - Existing Taskfile and workflow definitions
3. **Record findings** in `research.md` with decision, rationale, alternatives.

**Output**: `research.md` with all NEEDS CLARIFICATION resolved or delegated.

## Phase 1: Design & Contracts
*Prerequisites: research.md complete*

1. **Terraform Design**: Document how pinned providers, remote state, and plan/apply review will be communicated in updated docs/templates.
2. **Helm Design**: Capture ingress hostname rules, collector receivers, and Helm-only deployment instructions for agents and quickstart.
3. **Automation Design**: Describe Taskfile and GitHub Actions expectations, including lint/plan/deploy gates and manual approvals for destroy.
4. **Documentation Plan**: Specify updates to spec, quickstart, AGENTS.md, and constitution-driven templates.
5. **Security Review**: Confirm GSM secret storage instructions and least-privilege IAM guidance; record any IAM review checkpoints.
6. **Update agent context** incrementally:
   - Run `.specify/scripts/bash/update-agent-context.sh codex`
   - Add only new technologies or tooling introduced in this plan

**Outputs**: Updated design artifacts (data-model, contracts, quickstart) and agent guidance references.

## Phase 2: Task Planning Approach
*Describe how /tasks will break down the work — do NOT create tasks.md here*

**Task Generation Strategy**:
- Group tasks by Terraform, Helm, Automation, Docs, Security responsibilities.
- Ensure Terraform plan/test tasks precede apply; Helm lint/smoke tests precede deploy.
- Include validation tasks (`task lint:all`, documentation checks, governance summaries).

**Ordering Strategy**:
- Research completion → contract/data-model alignment → templates and repo guidance sync → documentation refresh → validation.
- Treat edits to the same file sequentially; use `[P]` only for disjoint files (individual contracts, etc.).

**Estimated Output**: 15–20 ordered tasks covering documentation, template alignment, and validation.

## Phase 3+: Future Implementation
*Beyond scope of /plan*

**Phase 3**: /tasks command generates tasks.md  
**Phase 4**: Execute tasks (Terraform, Helm, automation, docs) under constitution principles  
**Phase 5**: Validate (plans applied, Helm release healthy, smoke tests + lint pass)

## Complexity Tracking
*Complete only if Constitution Check requires exceptions*

| Violation | Why Needed | Compensating Controls |
|-----------|------------|------------------------|
| _None_ | _N/A_ | _N/A_ |

## Progress Tracking
*Update during execution*

**Phase Status**:
- [X] Phase 0: Research complete (/plan)
- [X] Phase 1: Design complete (/plan)
- [X] Phase 2: Task planning strategy captured (/plan)
- [ ] Phase 3: Tasks generated (/tasks)
- [ ] Phase 4: Implementation complete
- [ ] Phase 5: Validation passed

**Gate Status**:
- [X] Initial Constitution Check: PASS
- [X] Post-Design Constitution Check: PASS
- [X] All NEEDS CLARIFICATION resolved
- [ ] Complexity deviations documented

---
*Based on Constitution v3.0.0 - See `/memory/constitution.md`*
