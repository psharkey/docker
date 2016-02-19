# Jenkins + DOOD (Docker-Outside-Of-Docker)

This Jenkins Docker image provides Docker*ish* capabilities using [Docker-outside-of-Docker ](http://container-solutions.com/running-docker-in-jenkins-in-docker/) (dood), which allows you to run any Docker container in your Jenkins build script.  This image creates Docker sibling containers rather than children which would be created if [Docker-In-Docker](http://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/) (dind) was used. Some advantages of dood over dind: 
+ **enables sharing of images with host OS** 
  * eliminates storing images multiple times
  * makes it possible for Jenkins to automate local image creation
+ eliminate the need for supervisord (which means multiple processes)
+ eliminates a virtualization layer (lxc)
+ allows greater flexibility at runtime

**Important note: This image uses the latest Docker distribution and the host's Docker installation must be the same version.**


This Docker image is based on [Continuous Delivery with Docker on Mesos in less than a minute – Part 1](http://container-solutions.com/continuous-delivery-with-docker-on-mesos-in-less-than-a-minute/), [Running Docker in Jenkins (in Docker) ](http://container-solutions.com/running-docker-in-jenkins-in-docker/),  [killercentury/docker-jenkins-dind](https://github.com/killercentury/docker-jenkins-dind) and [jpetazzo/dind](https://registry.hub.docker.com/u/jpetazzo/dind/) instead of the offical [Jenkins](https://registry.hub.docker.com/u/library/jenkins/). Morever, [Docker Compose](https://github.com/docker/compose) is available for launching multiple containers with the CI.

Build this image (from the directory containing the Dockerfile):

```
docker build -t jenkins-dood .
```

Run it with mounted directory from host:

```
docker run -d -p 8080:8080 -v /your/path:/var/lib/jenkins --name jenkins-dood jenkins-dood
```
Bash function example with additional arguments including:
+ `-e "TZ=America/Chicago"` sets the timezone
+ -`v $HOME/Workspace/.jenkins/.ssh:/var/lib/jenkins/.ssh` for sharing your ssh key with the container
+  `-v /dev/urandom:/dev/random` is to deal with entropy [issues](http://stackoverflow.com/questions/26021181/not-enough-entropy-to-support-dev-random-in-docker-containers-running-in-boot2d)
+ `-v /var/run/docker.sock:/var/run/docker.sock` exposes the Docker daemon socket to this container instead of using [dind](http://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/) (Docker In Docker)

 

A message is displayed showing the Jenkins URL to open in a browser.
```bash
jenkins-dood(){
        x11host

        LOCAL_PORT=11080

        docker run -d \
                -e DISPLAY=$X11HOST:0.0 \
                -e "TZ=America/Chicago" \
                -v $HOME/Workspace/.jenkins/.ssh:/var/lib/jenkins/.ssh \
                -v /dev/urandom:/dev/random \
                -v /var/run/docker.sock:/var/run/docker.sock \
                --add-host='contd.cleo.com:10.10.1.57' \
                --name jenkins-dood \
                -p $LOCAL_PORT:8080 \
                jenkins-dood
        VBOX_IP=$(docker-machine ls | grep -F '*' | awk '{print $5}' | cut -f2 -d":")
        echo "Jenkins started at: http:$VBOX_IP:$LOCAL_PORT"
}
```

The `x11_host` helper function simply creates an environment variable using the Docker machine's `HostOnlyCIDR` so the Jenkins container may launch GUI applications. Note: GUI applications will require some additional [setup](https://github.com/docker/docker/issues/8710) to display on the host.

```bash
# Define a variable to use for the X11 host IP
x11host(){
        ACTIVE_MACHINE=$(docker-machine active)
        X11HOST="$(docker-machine inspect $ACTIVE_MACHINE \
        | grep HostOnlyCIDR \
        | awk '{print $2}' \
        | sed 's/"//g' \
        | cut -f1 -d"/")"
}
```

Example output from above run within a bash function named 'jenkins-dood'

```bash
$ jenkins-dood
jenkins-dood
569ba93cd7d69a654bcdb97874ea6aa95025a74d4ae92fcb3e620c23676c4d12
Jenkins started at: http://192.168.99.101:11080
$
```
