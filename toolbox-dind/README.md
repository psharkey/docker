# CLI Toolbox with DinD (Docker in Docker)
From [maven](https://hub.docker.com/_/maven/) which includes Java, Maven, Git & SVN utilities. Ant, Vim, and the [unlimited strength Java policy files](http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html) are added here. Based on (toolbox)[https://github.com/psharkey/docker/tree/master/toolbox] with DinD added.

### Bash Example (without DinD running)
Simple example which opens a bash shell inside the toolbox container-
```bash
$ docker run --rm -it --name toolbox psharkey/toolbox-dind bash
root@1b8f4106bcb8:/#
```
Then, ```exit``` will stop the container and return to the host shell - 
```sh
root@1b8f4106bcb8:/# exit
exit
$
```
### Bash with DinD
##### Function
```bash
toolbox(){
        docker run --rm -it \
                --privileged \
                --name toolbox \
                psharkey/toolbox-dind "$@"
}
```
##### Usage
With ```bash``` or other command specified DinD is not started. 
```bash
$ toolbox bash
root@1b8f4106bcb8:/#
```
With no command specified the supervisord.conf takes over:
```bash
$ toolbox
/usr/lib/python2.7/dist-packages/supervisor/options.py:296: UserWarning: Supervisord is running as root and it is searching for its configuration file in default locations (including its current working directory); you probably want to specify a "-c" argument specifying an absolute path to a configuration file for improved security.
  'Supervisord is running as root and it is searching '
2016-01-04 18:46:04,171 CRIT Supervisor running as root (no user in config file)
2016-01-04 18:46:04,171 WARN Included extra file "/etc/supervisor/conf.d/supervisord.conf" during parsing
2016-01-04 18:46:04,179 INFO RPC interface 'supervisor' initialized
2016-01-04 18:46:04,180 CRIT Server 'unix_http_server' running without any HTTP authentication checking
2016-01-04 18:46:04,180 INFO supervisord started with pid 1
2016-01-04 18:46:05,183 INFO spawned: 'docker' with pid 7
2016-01-04 18:46:05,186 INFO spawned: 'bash' with pid 8
2016-01-04 18:46:05,256 INFO success: docker entered RUNNING state, process has stayed up for > than 0 seconds (startsecs)
2016-01-04 18:46:06,357 INFO success: bash entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
```
Then ```docker exec``` can be used to execute other utilities:
```sh
$ docker exec -it toolbox git --version
git version 2.1.4
$
```
Which include docker...
```
$ docker exec -it toolbox docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
b901d36b6f2f: Pull complete
0a6ba66e537a: Pull complete
Digest: sha256:8be990ef2aeb16dbcb9271ddfe2610fa6658d13f6dfb8bc72074cc1ca36966a7
Status: Downloaded newer image for hello-world:latest

Hello from Docker.
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker Hub account:
 https://hub.docker.com

For more examples and ideas, visit:
 https://docs.docker.com/userguide/

$
```
And also docker-compose:
```
$ docker exec -it toolbox docker-compose --version
docker-compose version: 1.3.3
CPython version: 2.7.9
OpenSSL version: OpenSSL 1.0.1e 11 Feb 2013
$
```