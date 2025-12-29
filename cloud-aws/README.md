## AWS EC2 – System Monitoring Deployment
### Overview

This stage demonstrates the manual deployment of a Linux-based system monitoring solution on AWS EC2.

The objective is to build a strong foundation in cloud infrastructure and Linux operations before introducing automation tools such as Terraform and Ansible.

An EC2 instance is provisioned, secured, and configured to run a previously developed system health monitoring script under a dedicated service account with scheduled execution.

### Architecture Summary

Cloud Provider: AWS

Service: EC2

Operating System: Ubuntu Server LTS

Instance Type: t3.micro (Free Tier eligible)

Access Method: SSH (key-based authentication)

### Infrastructure Components

### EC2 Instance

A single Ubuntu-based EC2 instance hosts the monitoring script.

The instance is assigned a public IP address to allow secure administrative SSH access.

### Security Group

Inbound traffic is restricted to:

SSH (TCP 22) from the administrator’s IP address only.

No additional inbound ports are exposed, minimizing the attack surface.

### Authentication

SSH key-based authentication is enforced.

Password-based SSH access remains disabled by default on the AMI.

### System Configuration
Service User

A dedicated system user (sysmonitor) is created to execute the monitoring script.

This follows the principle of least privilege and avoids running operational workloads as the root user.

### Script Deployment

Source code is cloned from GitHub, which acts as the single source of truth.

The monitoring script is deployed to:

/opt/sysmonitor/bin/


Ownership and permissions are restricted to the sysmonitor user.

### Logging

Logs are written to:

/var/log/sysmonitor/system_health.log


Log permissions allow write access only to the service user.

### Automation

### Cron Scheduling

The monitoring script is scheduled using cron to execute every five minutes:

*/5 * * * * /opt/sysmonitor/bin/system_health_check.sh


This enables continuous system health monitoring without manual intervention.

### Validation

The deployment is validated by confirming:

Successful SSH access using key-based authentication

Manual execution of the script produces expected output

Log entries are correctly appended to the log file

Cron execution is verified by observing periodic log updates

### Design Rationale

This stage is intentionally implemented without automation to:

Reinforce understanding of AWS EC2 fundamentals

Practice secure Linux system administration

Establish a reference architecture for Infrastructure as Code

### Next Steps

In the next phase, this infrastructure will be fully automated using Terraform, including:

- EC2 instance provisioning

- Security group configuration

-  SSH key management

- Repeatable, version-controlled deployments

This manual setup serves as the baseline for automation.


