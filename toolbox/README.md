# CLI Toolbox
From [maven](https://hub.docker.com/_/maven/) which includes Java, Maven, Git, & SVN utilities. Ant and the [unlimited strength Java policy files](http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html) are added here [(from travis.yaml)](https://github.com/simi/travis-jce-unlimited-test/blob/master/.travis.yml). 
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
