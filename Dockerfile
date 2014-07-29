# sshd
#
# VERSION               0.0.1

FROM     ubuntu:14.04
MAINTAINER Breinlinger Juan Paulo "juan@breins.net"

# This is a non interactive installation
ENV DEBIAN_FRONTEND noninteractive

# make sure the package repository is up to date
RUN apt-get -qq update

# Install base tools
RUN apt-get -qq -y install wget rsync > /dev/null

# Docker configuration:
ENV jenkins_version 1.573

# Install jenkins
RUN wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
RUN echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list
RUN apt-get -qq update
RUN apt-get -qq -y install jenkins=$jenkins_version > /dev/null

# Install jenkins plugins:
ADD scripts/install_jenkins_plugins.sh /usr/bin/install_jenkins_plugins.sh
ADD scripts/start.sh /usr/bin/start.sh
RUN chmod 755 /usr/bin/install_jenkins_plugins.sh /usr/bin/start.sh
RUN /usr/bin/install_jenkins_plugins.sh \
  ansicolor=0.4.0 \
  ant=1.2 \
  build-pipeline-plugin=1.4.3 \
  copyartifact=1.31 \
  dashboard-view=2.9.3 \
  dynamicparameter=0.2.0 \
  extended-choice-parameter=0.34 \
  external-monitor-job=1.2 \
  ghprb=1.12 \
  git-client=1.10.0 \
  git-server=1.3 \
  git=2.2.2 \
  github-api=1.55 \
  github=1.9.1 \
  greenballs=1.14 \
  javadoc=1.1 \
  jquery=1.7.2-1 \
  maven-plugin=2.5 \
  nested-view=1.14 \
  next-build-number=1.1 \
  pam-auth=1.1 \
  parameterized-trigger=2.25 \
  rebuild=1.21 \
  scm-api=0.2 \
  scriptler=2.7 \
  ssh-agent=1.4.1 \
  token-macro=1.10 \
  windows-slaves=1.0

# Jenkins to listen on port 80
EXPOSE 8080

# Volume to be exported
VOLUME /var/log/jenkins
VOLUME /var/lib/jenkins

# Run jenkins
ENTRYPOINT /usr/bin/start.sh
