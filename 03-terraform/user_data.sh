#!/bin/bash
set -e

# Create sysmonitor user
useradd -m -r -s /bin/bash sysmonitor

# Create directories
mkdir -p /opt/sysmonitor/bin
mkdir -p /var/log/sysmonitor

# Set ownership
chown -R sysmonitor:sysmonitor /opt/sysmonitor
chown -R sysmonitor:sysmonitor /var/log/sysmonitor

# Basic logging
echo "Bootstrap completed at $(date)" >> /var/log/sysmonitor/bootstrap.log

