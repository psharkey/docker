# CLI Toolbox
From [maven](https://hub.docker.com/_/maven/) which includes Java, Maven, Git & SVN utilities. Ant, Vim, and the [unlimited strength Java policy files](http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html) are added here. 
### Bash Example 
Simple example which opens a bash shell inside the toolbox container-
```bash
$ docker run --rm -it --name toolbox psharkey/toolbox bash
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
