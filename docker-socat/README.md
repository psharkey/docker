# docker-socat

When user namespaces are enabled in a Docker daemon, mounting the Docker API UNIX socket into the container is not directly useful. Without munging the ownership of the UNIX socket, the container will have no access to the socket for either read or write.

This `Dockerfile` builds a simple container that can use the new `--privileged` capability in Docker 1.11 (a privileged container even while the daemon has user namespaces enabled) to pass traffic from a TCP endpoint to the UNIX socket using socat.

## Build & Run

Building can be performed with a simple `docker build`:

```
docker build -t docker-socat .
```

> **NOTE**: This **requires** Docker 1.11 for the `--privileged` support for user namespaced-enabled daemon.

```bash
docker run --rm -it --name docker-socat --privileged --userns=host -v /var/run/docker.sock:/var/run/docker.sock docker-socat
```

Note that I am not portmapping the TCP listener to the host as the expectation is that inter-container communication is on and other user namespaced containers are the consumers of this service and will connect to the container IP at port :2375 for `DOCKER_HOST`.  Of course you could portmap this to the host, but this exposes your Docker engine endpoint to a broad audience with all the usual concerns and risks for doing so.

## Use from other (unprivileged) containers

To use the socket TCP->UNIX forwarding container from a user namespaced container, I will show an example using "links". If you are using modern libnetwork/overlay networking, using the embedded DNS will be the future-proof path, given "links" are a deprecated feature. For a basic example, however, it's easy to show using a simple container that has a Docker client installed:


```bash
$ docker run --rm -it --link docker-socat -e DOCKER_HOST=tcp://docker-socat:2375 psharkey/toolbox /usr/bin/docker info
Containers: 6
 Running: 3
 Paused: 0
 Stopped: 3
Images: 39
Server Version: 1.12.5
Storage Driver: aufs
 Root Dir: /var/lib/docker/aufs
 Backing Filesystem: extfs
 Dirs: 97
 Dirperm1 Supported: true
Logging Driver: json-file
Cgroup Driver: cgroupfs
Plugins:
 Volume: local
 Network: bridge host null overlay
Swarm: inactive
Runtimes: runc
Default Runtime: runc
Security Options: seccomp
Kernel Version: 4.4.39-moby
Operating System: Alpine Linux v3.4
OSType: linux
Architecture: x86_64
CPUs: 6
Total Memory: 11.71 GiB
Name: moby
ID: 34G3:TEE5:XAG3:ILYN:CNMB:IXIK:L6RF:Z45H:AU42:WTCL:VNYY:HQKC
Docker Root Dir: /var/lib/docker
Debug Mode (client): false
Debug Mode (server): true
 File Descriptors: 41
 Goroutines: 65
 System Time: 2017-01-09T14:47:56.135859864Z
 EventsListeners: 1
No Proxy: *.local, 169.254/16
Registry: https://index.docker.io/v1/
WARNING: No kernel memory limit support
Insecure Registries:
 127.0.0.0/8
$
```

## On DockerHub / GitHub
___
* DockerHub [psharkey/docker-socat](https://hub.docker.com/r/psharkey/docker-socat/)
* GitHub [psharkey/docker/docker-socat](https://github.com/psharkey/docker/tree/master/novnc)

# Thanks
___
Based on [rancher/docker-socat](https://hub.docker.com/r/rancher/socat-docker/), [estesp/Dockerfiles](https://github.com/estesp/Dockerfiles/blob/master/dockersocat/README.md), and [bobrick/socat](https://hub.docker.com/r/bobrik/socat/).
