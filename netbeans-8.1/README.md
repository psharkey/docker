Based on [fgrehm/netbeans](https://hub.docker.com/r/fgrehm/netbeans/~/dockerfile/) and [dirichlet/netbeans](https://hub.docker.com/r/dirichlet/netbeans/) but uses [NetBeans 8.1 + JDK 1.8u71 bundle](http://www.oracle.com/technetwork/articles/javase/jdk-netbeans-jsp-142931.html) instead.

The following bash function example:
* Determines the X11 host IP address (using the active machine)
* Uses this IP address to set the ```DISPLAY``` environment variable
* Sets the timezone
* Creates volumes from a host 'Workspace'
```bash
netbeans(){
    ACTIVE_MACHINE=$(docker-machine ls | grep '*' | awk '{print $1}')
    X11HOST="$(docker-machine inspect $ACTIVE_MACHINE \
        | grep HostOnlyCIDR \
        | awk '{print $2}' \
        | sed 's/"//g' \
        | cut -f1 -d"/")"
    docker run -d -it \
        -e DISPLAY=$X11HOST:0.0 \
        -e "TZ=America/Chicago" \
        -v $HOME/Workspace/.netbeans:/root/.netbeans \
        -v $HOME/Workspace/.m2:/root/.m2 \
        -v $HOME/Workspace/github/<your repo name>:/root/repo \
        --name netbeans \
        psharkey/netbeans
}
```


Refer to [Dockerfile](https://github.com/psharkey/docker/blob/master/netbeans-8.1/Dockerfile) for building images with other versions. NetBeans 8.0.2 + JDK 1.7u80 is provided as an example alternative [tag](https://hub.docker.com/r/psharkey/netbeans-8.1/tags/).
