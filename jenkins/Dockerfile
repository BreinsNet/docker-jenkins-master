FROM breinsnet/base:latest

# Mantainer:
MAINTAINER Breinlinger Juan Paulo <juan.brein@breins.net>

# Some Environment Variables
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

# Ansible repository
RUN apt-add-repository -y ppa:ansible/ansible

# Update package metadata
RUN apt-get -y update

# Install required packages
RUN apt-get install -y \
  ansible \
  nginx

# Install ruby:
RUN su - root -c "curl -sSL https://rvm.io/mpapis.asc | gpg --import - " && \
    su - root -c "curl -sSL https://get.rvm.io | bash -s stable" && \
    su - root -c "rvm install 2.1.2"

# Install jenkins plugins:
RUN dpkg-remote-install.sh http://mirrors.jenkins-ci.org/debian/jenkins_1.628_all.deb 

# jquery plugin locked to 1.7.2: https://issues.jenkins-ci.org/browse/JENKINS-28358
RUN install_jenkins_plugins.sh \
      build-pipeline-plugin=latest \
      parameterized-trigger=latest \
      jquery=1.7.2-1 \
      dashboard-view=latest \
      maven-plugin=latest \
      javadoc=latest \
      git-client=latest \
      scm-api=latest \
      git=latest \
      greenballs=latest \
      rebuild=latest \
      ssh-agent=latest \
      mask-passwords=latest \
      email-ext=latest \
      next-build-number=latest \
      copyartifact=latest \
      simple-theme-plugin=latest \
      dynamicparameter=latest \
      ansicolor=latest \
      nested-view=latest \
      workflow-step-api=latest \
      scriptler=latest \
      git-server=latest \
      token-macro=latest \
      credentials=latest \
      plain-credentials=latest \
      github-api=latest \
      github=latest \
      github-oauth=latest \
      extensible-choice-parameter=latest

# Pin credentials plugin so the script installation
# is not overwritten by the internal jenkins installation
# (see https://issues.jenkins-ci.org/browse/JENKINS-19927):
RUN touch /opt/jenkins/plugins/credentials.hpi.pinned

# Add all the files
ADD .root.tar.gz /

# Post configuration steps after files were added
RUN chmod 755 /usr/local/bin/*sh start.sh

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Persistent data:
VOLUME /var/lib/jenkins

# Entry point:
CMD "/start.sh"
