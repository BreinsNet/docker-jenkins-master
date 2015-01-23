# sshd
#
# VERSION               0.0.1

FROM ubuntu:14.04
MAINTAINER Breinlinger Juan Paulo "juan@breins.net"

# make sure the package repository is up to date
RUN apt-get update

# Install necesary software:
RUN apt-get install -y \
  nginx \
  supervisor \
  wget \
  rsync \
  git \
  curl

# Add all the files
ADD files /
RUN chmod u+x /usr/bin/*sh

# Install jenkins plugins:
RUN dpkg-remote-install.sh http://pkg.jenkins-ci.org/debian/binary/jenkins_1.596_all.deb
RUN /usr/bin/install_jenkins_plugins.sh \
  ansicolor=latest \
  ant=latest \
  build-pipeline-plugin=latest \
  jenkins-multijob-plugin=latest \
  copyartifact=latest \
  dashboard-view=latest \
  dynamicparameter=latest \
  extended-choice-parameter=latest \
  external-monitor-job=latest \
  ghprb=latest \
  git-client=latest \
  git-server=latest \
  git=latest \
  github-api=latest \
  github=latest \
  greenballs=latest \
  javadoc=latest \
  jquery=latest \
  maven-plugin=latest \
  nested-view=latest \
  next-build-number=latest \
  pam-auth=latest \
  parameterized-trigger=latest \
  rebuild=1.21 \
  scm-api=latest \
  scriptler=latest \
  ssh-agent=latest \
  token-macro=latest \
  windows-slaves=latest \
  email-ext=latest \
  envinject=latest \
  conditional-buildstep=latest \
  run-condition=latest \
  script-security=latest \
  mask-passwords=latest

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Jenkins to listen on port 8000 and 8080 for jnlp
EXPOSE 8000
EXPOSE 80

# Entry point:
ENTRYPOINT "/usr/bin/supervisord"
