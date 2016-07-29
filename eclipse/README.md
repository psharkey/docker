![alt text](http://www.eclipse.org/eclipse.org-common/themes/solstice/public/images/logo/eclipse-426x100.png)
# Eclipse 

## Usage

## On DockerHub / GitHub
___
* DockerHub [psharkey/novnc](https://hub.docker.com/r/psharkey/eclipse/)
* GitHub [psharkey/docker/eclipse](https://github.com/psharkey/docker/tree/eclipse/eclipse)

## Thanks

Based on [batmat/docker-eclipse](https://hub.docker.com/r/batmat/docker-eclipse/~/dockerfile/).

The following bash function example:
* Determines the X11 host IP address (using the active machine)
* Uses this IP address to set the ```DISPLAY``` environment variable
* Sets the timezone
* Creates volumes from a host 'Workspace'
```bash
netbeans(){
    ACTIVE_MACHINE=$(docker-machine active)
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

**Refer to [psharkey/novnc](https://hub.docker.com/r/psharkey/novnc/) for an alternative X11 configuration.**
