# Phase 4 – Configuration Management with Ansible

## Objective

This phase introduces **configuration management** using Ansible to replace EC2 bootstrap logic previously handled by cloud-init user-data.

The objective is to ensure system configuration is:
- Idempotent
- Repeatable
- Auditable
- Decoupled from infrastructure provisioning

At this stage, **Terraform is responsible only for infrastructure**, while **Ansible manages system configuration and application deployment**.

---

## Technologies Used

- Ansible
- SSH (key-based authentication)
- Ubuntu Server LTS
- AWS EC2
- GitHub (configuration source of truth)

---

## Configuration Scope

Ansible is responsible for configuring the EC2 instance to run the system monitoring service. Specifically, it manages:

- Creation of a non-interactive service user (`sysmonitor`)
- Deployment of the system health monitoring script
- Creation of application and log directories
- Enforcement of file ownership and permissions
- Configuration of scheduled execution using cron
- Idempotent re-application of configuration

No manual configuration is performed directly on the instance.

---

## Repository Structure

04-ansible/
├── ansible.cfg
├── inventories/
│ └── production
├── playbooks/
│ └── sysmonitor.yml
├── roles/
│ └── sysmonitor/
│ ├── tasks/
│ │ └── main.yml
│ ├── files/
│ │ └── system_health_check.sh
│ ├── handlers/
│ ├── defaults/
│ └── vars/


---
> Note: The real Ansible inventory is excluded from version control.  
> A sanitized example inventory is provided as `inventories/production.example`.

## Role-Based Design

All configuration logic is encapsulated within a reusable **Ansible role**:

- Roles enforce separation of concerns
- Configuration logic is modular and reusable
- Files deployed via roles are treated as immutable artifacts
- Playbooks act only as orchestration layers

This structure aligns with production Ansible best practices.

---

## Execution Flow

1. Ansible connects to the EC2 instance using SSH key authentication
2. Privilege escalation is performed using `become`
3. The `sysmonitor` role is applied
4. System state is enforced declaratively
5. Cron executes the monitoring script every five minutes

---

## Validation and Idempotency

The following validations were performed:

- Successful Ansible connectivity and privilege escalation
- Role execution completed without errors
- Second execution resulted in **zero changes**
- Monitoring logs confirmed periodic execution of the script

Idempotency confirms that the configuration is **safe to reapply** at any time.

---

## Design Decisions

- Service users are non-interactive and non-privileged
- No manual file transfers (e.g., SCP)
- No configuration logic embedded in Terraform
- GitHub is the single source of truth
- Clear separation between provisioning and configuration layers

---

## Known Limitations

- Single-host static inventory
- No secrets management
- No dynamic inventory
- No CI/CD integration yet

These limitations are intentional and addressed in subsequent phases.

---

## Status

Phase 4 complete and validated.

