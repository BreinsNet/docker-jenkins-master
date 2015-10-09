# Base image to build from
FROM ubuntu:14.04

# Mantainer:
MAINTAINER Breinlinger Juan Paulo <juan.brein@breins.net>

# Some Environment Variables
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
ENV PATH /usr/local/bin:$PATH

# Update package metadata
RUN apt-get -y update

# Install necesary software:
RUN apt-get install -y \
  software-properties-common \
  python-software-properties \
  telnet \
  supervisor \
  wget \
  rsync \
  git \
  strace \
  pwgen \
  traceroute \
  htop \
  vim \
  git \
  sysstat \
  iotop \
  curl

# Add all the files
ADD .root.tar.gz / 
RUN chmod u+x /usr/local/bin/*sh start.sh

# Clean up APT when done. 
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# Entry point:
CMD "/start.sh"
