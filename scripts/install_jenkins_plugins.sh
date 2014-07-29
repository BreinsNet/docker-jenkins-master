#!/bin/bash 

# Plugins are downloaded under /opt/jenkins/plugins because 
# /var/lib/jenkins is an external volume that is mounted
# at run time. The script start.sh will then take care of copying those
# plugins when starting the container

set -e
set -o pipefail

url=http://updates.jenkins-ci.org/download/plugins

[[ ! -d /opt/jenkins/plugins ]] && mkdir -p /opt/jenkins/plugins

for plugin in $*; do 
  name=$(echo $plugin|cut -d'=' -f1)
  version=$(echo $plugin|cut -d'=' -f2)

  wget -q -O /opt/jenkins/plugins/$name.hpi $url/$name/$version/$name.hpi
done

chown jenkins:jenkins -R /opt/jenkins/plugins
