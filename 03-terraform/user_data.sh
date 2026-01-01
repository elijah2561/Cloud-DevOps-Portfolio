
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

# Clone repo
cd /opt
git clone https://github.com/elijah2561/Cloud-DevOps-portfolio.git

# Copy script
cp Cloud-DevOps-portfolio/01-shell-scripting/system_health_check.sh /opt/sysmonitor/bin/

# Permissions
chown -R sysmonitor:sysmonitor /opt/sysmonitor /var/log/sysmonitor
chmod 750 /opt/sysmonitor/bin
chmod 750 /var/log/sysmonitor
chmod 750 /opt/sysmonitor/bin/system_health_check.sh

# Cron job
echo "*/5 * * * * /opt/sysmonitor/bin/system_health_check.sh" | crontab -u sysmonitor -

EOF
