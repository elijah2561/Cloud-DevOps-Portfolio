# Phase 7: CI/CD with GitHub Actions

## Overview

This phase introduces Continuous Integration (CI) into the Cloud-DevOps-Portfolio
using GitHub Actions. The objective is to enforce quality gates for infrastructure
and configuration code before changes are merged.

The pipeline validates Terraform and Ansible code automatically on every push
and pull request to the main branch.

---

## CI Pipeline Architecture

The pipeline consists of two independent jobs:

### 1. Terraform Validation

The Terraform job enforces infrastructure-as-code quality standards:

- `terraform fmt -check` to enforce formatting
- `terraform init` (backend disabled)
- `terraform validate` to ensure configuration correctness


All required variables are injected using environment variables or GitHub Secrets.
Sensitive files such as `.tfvars` are excluded from version control.

### 2. Ansible Syntax Check

The Ansible job ensures configuration management code is valid:

- Installs Ansible on the runner
- Runs `ansible-playbook --syntax-check`
- Does not connect to remote hosts

---

## Security and Best Practices

- No secrets are committed to the repository
- Terraform variables are supplied via `TF_VAR_*` environment variables
- SSH keys and IP addresses are excluded from source control
- CI runners do not provision or modify live infrastructure

---

## Evidence

Screenshots of successful CI pipeline executions are available in:

05-ci-cd/evidence/


---

## Outcome

This phase demonstrates the ability to design and operate a CI pipeline that
enforces infrastructure and configuration quality, aligns with industry best
practices, and supports safe, scalable DevOps workflows.

