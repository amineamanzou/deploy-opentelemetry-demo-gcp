# Tasks: Repository Agents

**Input**: Design documents from `/specs/001-repository-agents-infra/`
**Prerequisites**: plan.md (required), research.md, design notes, updated agent guidance

## Execution Flow (main)
```
1. Load plan.md from feature directory
   → If not found: ERROR "No implementation plan found"
   → Extract: impacted domains (Terraform, Helm, Automation, Docs, Security)
2. Load supporting documents:
   → research.md: capture decisions and constraints
   → design notes/data-model.md: identify resources, values, IAM changes
3. Generate tasks grouped by constitution principles:
   → Terraform Source of Truth tasks
   → Helm-Managed Observability tasks
   → Automation & Safety Gate tasks
   → Secret Hygiene & Documentation tasks
4. Apply task rules:
   → Terraform plan before apply, Helm lint before upgrade
   → Tests/validations precede state-changing operations
   → Use `[P]` only when tasks touch independent directories with no dependency
5. Number tasks sequentially (T001, T002...)
6. Build dependency graph (Terraform → Helm → Automation → Docs)
7. Provide parallel execution examples where safe
8. Validate completeness:
   → Every requirement from spec covered by a task
   → Constitution checks represented explicitly
9. Return: SUCCESS (tasks ready for execution)
```

## Format: `[ID] [P?] Description`
- **[P]**: Safe to run in parallel (different directories, no shared state)
- Include exact commands or file paths when meaningful (e.g., `terraform/`, `helm/values.yaml`)

## Phase 3.1: Terraform Preparation
- [X] T001 Update `specs/001-repository-agents-infra/plan.md` to adopt the v3.0.0 planning template, documenting constitution gates, impacted agents, and repository areas.
- [X] T002 Resolve every `NEEDS RESEARCH` item in `specs/001-repository-agents-infra/research.md`, recording decisions for versioning, IaC TDD workflow, performance targets, tooling versions, and observability error context.

## Phase 3.2: Helm & Observability
- [X] T003 [P] Refresh `specs/001-repository-agents-infra/contracts/infra-agent.md` so responsibilities, inputs/outputs, and prompt match the new constitution requirements (regional GKE resilience, Terraform-only infra, GSM usage).
- [X] T004 [P] Refresh `specs/001-repository-agents-infra/contracts/helm-agent.md` to capture Helm-exclusive deployments, collector receivers (kubeletstats, hostmetrics, kube-state-metrics), and ingress strategy.
- [X] T005 [P] Refresh `specs/001-repository-agents-infra/contracts/cicd-agent.md` to mandate lint/plan/deploy gates, OIDC auth, and gated destroy workflows.
- [X] T006 [P] Refresh `specs/001-repository-agents-infra/contracts/docs-agent.md` with documentation responsibilities for DNS guidance, Taskfile alignment, and constitution updates.
- [X] T007 [P] Refresh `specs/001-repository-agents-infra/contracts/security-agent.md` to enforce GSM secrets, least-privilege IAM, and OIDC-based credential handling.

## Phase 3.3: Automation & Safety Gates
- [X] T008 Update `specs/001-repository-agents-infra/data-model.md` so every agent instance mirrors the refreshed contracts (responsibilities, prompt snippets, checklist language).
- [X] T009 Align `.specify/templates/plan-template.md`, `.specify/templates/spec-template.md`, and `.specify/templates/tasks-template.md` with the updated constitution and agent responsibilities, ensuring downstream tooling surfaces the new gates.
- [X] T010 Sync `AGENTS.md` with the revised agent data model, adding principle badges, updated prompts, and checklists that reference constitution v3.0.0.

## Phase 3.4: Security & Documentation
- [X] T011 Update `specs/001-repository-agents-infra/quickstart.md` to explain how to engage each agent, reference GSM-secured kubeconfig flows, and highlight ingress hostname rules.
- [X] T012 Rebuild `specs/001-repository-agents-infra/spec.md` using the current spec template, capturing operator scenarios, platform requirements, and affected components tied to each agent.
- [X] T013 Refresh `GEMINI.md` (and other agent files under `.specify/` if present) so runtime guidance matches the new agent contracts and recent changes.

## Phase 3.5: Validation & Cleanup
- [ ] T014 Run `task lint:all` to confirm Terraform, Helm, markdown, and spell checks pass after documentation updates.
- [ ] T015 Capture a short summary of constitution alignment and pending follow-ups in the feature change log or PR description before requesting review.

## Dependencies
- T001 → T002 → T008 to keep foundational documents consistent before updating downstream artifacts.
- Contract updates (T003-T007) must finish before syncing data-model (T008) and AGENTS.md (T010).
- Template and repo guidance updates (T009-T013) depend on T001-T008 completing.
- Validation tasks (T014-T015) run only after all content edits land.

## Parallel Example
```
# After plan and research documents are finalized (T001-T002), tackle these in parallel:
$EDITOR specs/001-repository-agents-infra/contracts/infra-agent.md    # T003 [P]
$EDITOR specs/001-repository-agents-infra/contracts/helm-agent.md     # T004 [P]
$EDITOR specs/001-repository-agents-infra/contracts/cicd-agent.md     # T005 [P]
$EDITOR specs/001-repository-agents-infra/contracts/docs-agent.md     # T006 [P]
$EDITOR specs/001-repository-agents-infra/contracts/security-agent.md # T007 [P]
# Validate the markdown edits alongside the contract work
task lint:md
```

## Notes
- `[P]` tasks target separate contract files and can run concurrently once plan/research updates set the source of truth.
- Ensure refreshed documents reference Constitution v3.0.0 and remove stale prompts or checklists.
- Document any unresolved historical data such as the original ratification date in the Sync Impact Report until sourced.

## Task Generation Rules
*Applied during main() execution*

1. **Terraform Source of Truth**:
   - Foundation documents (plan, research) must confirm Terraform remains exclusive infra source with provider pinning.

2. **Helm-Managed Observability**:
   - Contracts and quickstart must reiterate Helm-only deployments and required collector receivers.

3. **Automation & Safety Gates**:
   - Templates and AGENTS.md must promote lint/plan/deploy gates and OIDC approvals.

4. **Secret Hygiene & Documentation**:
   - Docs and guidance must direct users to GSM for kubeconfig and forbid static keys.

## Validation Checklist
*GATE: Checked by main() before returning*

- [ ] Plan, research, and data model updated to remove placeholders and reference Constitution v3.0.0.
- [ ] Every agent contract, AGENTS.md, and quickstart share the same responsibilities, prompts, and checklists.
- [ ] Templates under `.specify/templates/` encode the new gates so future specs/plans/tasks inherit them.
- [ ] Runtime guidance files mirror GSM usage, ingress rules, and automation commands.
- [ ] Lint suite (`task lint:all`) succeeds after the edits.
- [ ] Outstanding historical data (e.g., ratification date) captured as explicit TODOs if still unknown.
