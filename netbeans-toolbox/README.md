# NetBeans Toolbox

NetBeans + Node + Docker

The following bash function examples:

* Determine the X11 host IP address
* Uses this IP address to set the ```DISPLAY``` environment variable
* Sets the timezone
* Creates volumes from a host 'Workspace'
* Mounts docker.sock directly & via another container running socat

```bash
netbeans-toolbox(){
        DISPLAY_MAC=`ifconfig en0 | grep "inet " | cut -d " " -f2`:0
        docker run -d -it \
                -e DISPLAY=$DISPLAY_MAC \
                -e "TZ=America/Chicago" \
                -e DOCKER_HOST=tcp://dockersock-socat:2375 \
                -v $HOME/Workspace/.netbeans:/home/toolbox/.netbeans \
                --volumes-from github \
                --volumes-from m2 \
                -v /var/run/docker.sock:/var/run/docker.sock \
                --name netbeans-toolbox \
                --net dood \
                --user toolbox \
                psharkey/netbeans-toolbox
        echo -e "Netbeans started on $DISPLAY_MAC \xF0\x9f\x8d\xba"
}
dockersock-socat(){
        docker run -d -it \
                --privileged \
                --userns=host \
                -v /var/run/docker.sock:/var/run/docker.sock \
                --net dood \
                --name dockersock-socat \
                psharkey/docker-socat
}
```

**Refer to [psharkey/novnc](https://hub.docker.com/r/psharkey/novnc/) for an alternative X11 configuration.**
