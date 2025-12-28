# System Health Check Script

## Overview

This Bash script performs a basic system health check by monitoring key system resources:

- Disk usage of the root (`/`) partition
- Memory usage percentage
- CPU load average

The script prints a summarized status to the terminal and appends the results to a log file located at:
/var/log/system_health.log


If disk or memory usage exceeds predefined thresholds, the system status is reported as `WARNING`.

---

## Why These Checks Matter in DevOps

In DevOps environments, proactive monitoring is essential to maintain system reliability and performance.

- **Disk Usage:** Prevents outages caused by full disks, commonly due to log or data growth.
- **Memory Usage:** Helps detect resource pressure before applications become unstable or crash.
- **CPU Load:** Indicates performance degradation and capacity constraints.

These checks act as early warning indicators, allowing engineers to take corrective action before issues impact users or services.

---

## How to Run the Script

1. Save the script as `system_health_check.sh`
2. Make it executable:
   ```bash
   chmod +x system_health_check.sh
3. Execute the script
./system_health_check.sh

## Example output
**When system resources are within acceptable limits**

Status: OK | Disk: 45% | Memory: 62% | CPU Load: 0.35

**If thresholds are exceeded**

Status: WARNING | Disk: 82% | Memory: 77% | CPU Load: 1.20


## Linux Operational Considerations

- The script is executed using a dedicated system user (`sysmonitor`) to follow the principle of least privilege.
- Files and directories are placed under `/opt/sysmonitor` to separate operational scripts from user home directories.
- Logs are written to `/var/log/sysmonitor/` with restricted permissions to ensure security and auditability.

## Source Control vs Deployment

The script is version-controlled within this Git repository.  
For execution, it is deployed to `/opt/sysmonitor/bin/`, which mirrors common Linux production practices where source code and runtime artifacts are separated.

### Deployment Consideration

The script is maintained in source control and copied to `/opt/sysmonitor/bin/` for execution.
Changes made in the repository must be redeployed to the runtime location to take effect.


## Automation with Cron

The system health check script is scheduled using `cron` to run every five minutes under the `sysmonitor` user account.  
This ensures continuous monitoring without manual intervention while maintaining a controlled execution context.





