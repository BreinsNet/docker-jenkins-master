docker-jenkins-master
=====================

## Usage

To run the container, do the following:

    /usr/bin/docker run --name TAG -p HOST_PORT:8080 -v /path/to/data/dir:/var/lib/jenkins -v /path/to/logs:/var/log/jenkins juanbrein/jenkins-master

Your jenkins instance is now available by going to http://localhost

## Building

To build the image, simply invoke

    docker build github.com/juanbrein/jenkins-master

A prebuilt container is also available in the docker index

    docker pull juanbrein/jenkins-master

## Author

  * Juan Breinlinger (<juan@breins.net>)

## LICENSE

Copyright 2013 Juan Breinlinger

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
