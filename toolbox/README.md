# CLI Toolbox
From [maven](https://hub.docker.com/_/maven/) which includes Java, Maven, Git & SVN utilities. Ant, Docker, Node.js, Vim, and the [unlimited strength Java policy files](http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html) are added here. 
### Bash Example 
Simple example which opens a bash shell (using the Dockerfile default `CMD` instruction) inside the toolbox container-
```bash
$ docker run --rm -it --name toolbox psharkey/toolbox
root@1b8f4106bcb8:/#
```
Then, ```exit``` will stop the container and return to the host shell - 
```sh
root@1b8f4106bcb8:/# exit
exit
$
```
### Git
##### Function
```bash
git(){
    docker run --rm -it \
        -v $(pwd):/home/repo \
        -w /home/repo/ \
        --name toolbox-git \
        psharkey/toolbox git "$@"
}
```
##### Usage
```sh
$ git --version
git version 2.1.4
$
```
### Maven
##### Function
```bash
mvn(){
    docker run --rm -it \
        -v $HOME/Workspace/.m2:/root/.m2 \
        -v $(pwd):/home/repo\
        -w /home/repo/ \
        --name toolbox-mvn \
        psharkey/toolbox mvn "$@"
}
```
##### Usage
```sh
$ mvn --version
Apache Maven 3.3.9 (bb52d8502b132ec0a5a3f4c09453c07478323dc5; 2015-11-10T16:41:47+00:00)
Maven home: /usr/share/maven
Java version: 1.8.0_66-internal, vendor: Oracle Corporation
Java home: /usr/lib/jvm/java-8-openjdk-amd64/jre
Default locale: en, platform encoding: UTF-8
OS name: "linux", version: "4.1.13-boot2docker", arch: "amd64", family: "unix"
$
```
##### GitHub Data Container
The following is based on a [maven data container](https://github.com/evermax/maven-docker) but uses this GitHub repo as the data source. 

First, create a container using ```docker create``` to a named container ("github" for this example) which defines the volume which will be shared by other containers.
```sh
$ docker create -v /root/github/psharkey/docker --name github busybox true
78326b01c7bcdc4bddb002a855413b7fa6c35bbd0f6d0a69e738294fbacd790b
```
Use ```docker cp``` to copy the data from the local repo (assuming the current directory is the base of the repo) to the data container volume: 
```sh
$ docker cp ./ github:/root/github/psharkey/docker
```
Do a simple test from another container which has the volume available via ```volumes-from```:
```sh
$ docker run --rm -it --volumes-from github busybox ls -l /root/github/psharkey/docker
total 8
drwxr-xr-x    2 root     root          4096 Dec 30 06:15 netbeans-8.1
drwxr-xr-x    2 root     root          4096 Jan  1 00:35 toolbox
```
Now, the ```git``` utility in the toolbox container will be able to access the repository via the same volume:
```
$ docker run --rm -it --volumes-from github -w /root/github/psharkey/docker psharkey/toolbox git status
On branch vim-and-data-containers
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   toolbox/Dockerfile

no changes added to commit (use "git add" and/or "git commit -a")
```
The bash function from above can now be modified to use ```volumes-from``` instead of ```-v``` to swtich from a host directory to the data container:
```bash
git(){
    docker run --rm -it \
        --volumes-from github \
        -w /root/github/psharkey/docker \
        --name toolbox-git \
        psharkey/toolbox git "$@"
}
```
Then, the ```git``` function can be used to show the same status as above for this data container:
```sh 
$ git status
On branch vim-and-data-containers
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   toolbox/Dockerfile

no changes added to commit (use "git add" and/or "git commit -a")
$
```
##### GitHub Data Volume
Another option (with Docker Engine 1.9.0) is to use ```volume create``` to create a named volume. 
```sh
$ docker volume create --name github
github
```
Then, use a container to copy files from the host's current directory to the named volume:
```sh
$ docker run --rm -it -v github:/root/github/psharkey -v $(pwd):/root/from busybox
/ # ls -l root/from
total 0
drwxr-xr-x    1 1000     staff          170 Jan  1 01:40 docker
/ # ls -l root/github/psharkey
total 0
/ # cp -r root/from/docker root/github/psharkey
/ # ls -l root/github/psharkey
total 4
drwxr-xr-x    5 root     root          4096 Jan  1 05:24 docker
/ # exit
```
The host's bash function then becomes:
```bash
git(){
    docker run --rm -it \
        -v github:/root/github/psharkey \
        -w /root/github/psharkey/docker \
        --name toolbox-git \
        psharkey/toolbox git "$@"
}
```
And finally, when the ```git``` function is run it will be working with the repository which was copied into the named volume:
```sh
$ git status
On branch vim-and-data-containers
nothing to commit, working directory clean
$
```
# Build Environment Usage
While jou may find the individual examples above to be useful, the intent is really to use this toolbox as a development environment. The following bash function uses the previous examples and includes additional arguments to make this possible:
```bash
toolbox(){
        x11host
        docker run --rm -it \
                -e DISPLAY=$X11HOST:0.0 \
                -e "TZ=America/Chicago" \
                --volumes-from github \
                --volumes-from m2 \
                -v /dev/urandom:/dev/random \
                -v /var/run/docker.sock:/var/run/docker.sock \
                -w /root/github/<YOUR REPO NAME> \
                --name toolbox \
                psharkey/toolbox "$@"
}
```
A helper `x11host` function to determine the X11 host IP address:
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
The additional arguments include:
+  `-v /dev/urandom:/dev/random` is to deal with entropy [issues](http://stackoverflow.com/questions/26021181/not-enough-entropy-to-support-dev-random-in-docker-containers-running-in-boot2d)
+ `-v /var/run/docker.sock:/var/run/docker.sock` exposes the Docker daemon socket to this container instead of using [dind](http://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/) (Docker In Docker)

The following example commands show how Docker*ish* commands are possible within the toolbox like starting a toolbox container from within a toolbox. The steps are:
+ `toolbox` - the bash function from above
+ `git status` - could be any of the utilities available in the image
+ `docker ps` - simple Docker command to test connection to the Docker daemon *(which shows __this__ toolbox as the only running container)*
+ `docker run...` - starts another toolbox container
+ `docker ps` - the new container is isolated from the Docker daemon
```bash
$ toolbox
root@0ecfd260e042:~/github/psharkey/docker# pwd
/root/github/psharkey/docker
root@0ecfd260e042:~/github/psharkey/docker# git status
On branch toolbox
nothing to commit, working directory clean
root@0ecfd260e042:~/github/psharkey/docker# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
0ecfd260e042        psharkey/toolbox    "/bin/bash"         2 minutes ago       Up 2 minutes                            toolbox-dind
root@0ecfd260e042:~/github/psharkey/docker# docker run --rm -it --name=toolbox-inside psharkey/toolbox
root@1f2936bf5f07:/# docker ps
Cannot connect to the Docker daemon. Is the docker daemon running on this host?
root@1f2936bf5f07:/#
```
The Docker daemon connection can be passed on like:
```bash
# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
c81a2eff06b2        psharkey/toolbox    "/bin/bash"         29 seconds ago      Up 28 seconds                           toolbox-dind
root@c81a2eff06b2:~/github/EFSS# docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock psharkey/toolbox
root@3610b2b96dc5:/# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED              STATUS              PORTS               NAMES
3610b2b96dc5        psharkey/toolbox    "/bin/bash"         3 seconds ago        Up 3 seconds                            hopeful_pike
c81a2eff06b2        psharkey/toolbox    "/bin/bash"         About a minute ago   Up About a minute                       toolbox-dind
root@3610b2b96dc5:/# docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock psharkey/toolbox
root@ac796da88e19:/# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
ac796da88e19        psharkey/toolbox    "/bin/bash"         10 seconds ago      Up 9 seconds                            distracted_hodgkin
3610b2b96dc5        psharkey/toolbox    "/bin/bash"         59 seconds ago      Up 58 seconds                           hopeful_pike
c81a2eff06b2        psharkey/toolbox    "/bin/bash"         2 minutes ago       Up 2 minutes                            toolbox-dind
root@ac796da88e19:/#```





