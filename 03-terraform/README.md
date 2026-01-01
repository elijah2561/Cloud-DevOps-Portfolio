
# Phase 3 – Infrastructure as Code (Terraform)

## Objective

This phase introduces **Infrastructure as Code (IaC)** using Terraform to provision and manage AWS infrastructure in a repeatable, auditable, and secure manner.

The goal is to replace manual EC2 provisioning with declarative infrastructure while deploying the previously developed **system health monitoring solution** in a controlled and automated way.

This phase intentionally focuses on **infrastructure provisioning and bootstrap automation**, leaving full configuration management for the next phase (Ansible).

---

## Technologies Used

- Terraform
- AWS EC2
- AWS Security Groups
- Cloud-init (user-data)
- Ubuntu Server LTS
- GitHub (source of truth)

---

## Architecture Overview

Local Machine
|
| SSH (restricted by IP)
v
AWS Security Group
|
v
EC2 Instance (Ubuntu)
|
|-- cloud-init (user-data)
|-- sysmonitor service user
|-- cron execution
v
System Health Monitoring Script


## Infrastructure Components

### EC2 Instance
- Instance Type: `t3.micro` (Free Tier)
- OS: Ubuntu Server LTS
- Provisioned entirely via Terraform
- Public IP enabled for SSH access

### Security Group
- Inbound:
  - SSH (TCP 22) restricted to **administrator public IP only**
- Outbound:
  - Default outbound access allowed

This follows the **principle of least privilege**.

### Authentication
- SSH key-based authentication
- No password-based SSH access
- No root login over SSH

---

## Bootstrap Strategy (User Data)

Terraform user-data is used to perform **initial bootstrapping only**:

- Install required packages (Git)
- Create a non-interactive service user (`sysmonitor`)
- Clone the GitHub repository (single source of truth)
- Deploy the monitoring script to `/opt/sysmonitor/bin`
- Create and secure log directories
- Configure cron execution

No application logic is hardcoded into Terraform itself.

---

## Monitoring Deployment Details

- Script location:

/opt/sysmonitor/bin/system_health_check.sh

- Log location:

/var/log/sysmonitor/system_health.log


- Execution:
- Runs every 5 minutes via cron
- Executed as the `sysmonitor` service user
- No interactive login or sudo access granted to the service account

---

## Validation Steps

The deployment is validated using the following checks:

1. Terraform state verification:
 - `terraform state list`
 - `terraform state show`

2. Cloud-init execution:
 - `cloud-init status`
 - `/var/log/cloud-init-output.log`

3. Script deployment verification:
 - Confirm script exists in `/opt/sysmonitor/bin`
 - Confirm correct ownership and permissions

4. Runtime validation:
 - Confirm cron job execution
 - Verify log entries are appended periodically


---

## Issues Encountered and Resolutions

### Logging Path Mismatch
A mismatch between local script paths and cloud deployment paths resulted in missing logs.

**Resolution**
- Standardized log directory: `/var/log/sysmonitor/`
- Explicit directory creation added to bootstrap logic

### Missing Script Deployment
Initial user-data did not deploy the script to the instance.

**Resolution**
- Updated user-data to clone the GitHub repository and deploy the script automatically
- Recreated the EC2 instance to ensure clean bootstrap execution

These issues were resolved without manual intervention, maintaining automation integrity.

---

## Design Decisions

- GitHub is the single source of truth
- No manual file copying (scp) to production instances
- Service users are non-interactive and non-privileged
- Terraform manages infrastructure only, not long-term configuration drift

---

## Known Limitations

- User-data is not idempotent beyond first boot
- Configuration changes require instance recreation
- No centralized monitoring or alerting yet
- No configuration drift detection

These limitations are **intentional** and addressed in the next phase.

---

## Transition to Next Phase

**Next: Phase 4 – Configuration Management (Ansible)**

In the next phase:
- Terraform will provision infrastructure only
- Ansible will handle configuration and application deployment
- User-data responsibilities will be reduced or eliminated
- Configuration drift will be managed explicitly

---

## Status

Phase 3 complete and validated.


