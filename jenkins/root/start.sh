#!/bin/bash -ex

# Set up volume permissions
chown -R jenkins:jenkins /var/lib/jenkins

# Run supervisord
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
