#!/bin/bash

LOG_FILE=/var/log/jenkins/jenkins.log

# Script error handling and output redirect
set -e                               # Fail on error
set -o pipefail                      # Fail on pipes
exec >> $LOG_FILE                    # stdout to log file
exec 2>&1                            # stderr to log file

rsync -a --delete /opt/jenkins/plugins/ /var/lib/jenkins/plugins/

su - jenkins -c "JENKINS_HOME=/var/lib/jenkins /usr/bin/java  -Duser.timezone=Europe/London -Djava.awt.headless=true -jar /usr/share/jenkins/jenkins.war --webroot=/var/cache/jenkins/war --httpPort=8080 --ajp13Port=-1 "
