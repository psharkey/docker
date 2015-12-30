Based on [fgrehm/netbeans](https://hub.docker.com/r/fgrehm/netbeans/~/dockerfile/) and [dirichlet/netbeans](https://hub.docker.com/r/dirichlet/netbeans/) but uses [NetBeans 8.1 + JDK 1.8u65 bundle](http://www.oracle.com/technetwork/articles/javase/jdk-netbeans-jsp-142931.html) instead.

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












