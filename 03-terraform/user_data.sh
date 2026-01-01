#!/bin/bash

set -e

# Install dependencies
apt-get update -y
apt-get install -y git

# Create service user
id sysmonitor || useradd -r -s /bin/false sysmonitor

# Create directories
mkdir -p /opt/sysmonitor/bin
mkdir -p /var/log/sysmonitor

# Clone repo if not already present
cd /opt
if [ ! -d Cloud-DevOps-Portfolio ]; then
    git clone https://github.com/elijah2561/Cloud-DevOps-Portfolio.git
fi

# Copy script
cp Cloud-DevOps-Portfolio/01-shell-scripting/scripts/system_health_check.sh /opt/sysmonitor/bin/

# Permissions
chown -R sysmonitor:sysmonitor /opt/sysmonitor /var/log/sysmonitor
chmod 750 /opt/sysmonitor/bin
chmod 750 /var/log/sysmonitor
chmod 750 /opt/sysmonitor/bin/system_health_check.sh

# Cron job (ensure full path to bash)
echo "*/5 * * * * /bin/bash /opt/sysmonitor/bin/system_health_check.sh" | crontab -u sysmonitor -
