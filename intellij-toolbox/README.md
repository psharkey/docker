# IntelliJ IDEA + OpenJDK 8 + Docker + Node

## Example usage:
```bash
intellij-toolbox(){
        displayMac
        GATEWAY=`docker network inspect dood | sed -n -e '/"Gateway":/ s/^.*"\(.*\)".*/\1/p'`
        docker run -d -it \
                -e DISPLAY=$DISPLAY_MAC \
                -e "TZ=America/Chicago" \
                -e DOCKER_HOST=tcp://dockersock-socat:2375 \
                -v $HOME/Workspace/.intellij:/home/toolbox/.IdeaIC15 \
                --volumes-from github \
                --volumes-from m2 \
                -v /var/run/docker.sock:/var/run/docker.sock \
                --name intellij-toolbox \
                --net dood \
                --user toolbox \
                psharkey/intellij-toolbox
        echo -e "IntelliJ IDEA started on gateway:$GATEWAY display:$DISPLAY_MAC \xF0\x9f\x8d\xba"
}
```

## Parameter explanation:
* Set the `DISPLAY` variable using the value (from the helper function below)
* Set the timezone (to your local value)
* Map a volume to persist the IntelliJ IDEA preferences
* Map volumes from `github` and `m2` data containers created for [toolbox](https://github.com/psharkey/docker/tree/master/toolbox)
* Shares the docker.sock via a volume & with another container on the same network 

## X11 helper function:
```bash
displayMac() {
        DISPLAY_MAC=`ifconfig en0 | grep "inet " | cut -d " " -f2`:0
}
dockersock-socat(){
        del_stopped docker-socat
        docker run -d -it \
                --privileged \
                --userns=host \
                -v /var/run/docker.sock:/var/run/docker.sock \
                --net dood \
                --name dockersock-socat \
                psharkey/docker-socat
}
```

## X11 Alternative
**Refer to [psharkey/novnc](https://hub.docker.com/r/psharkey/novnc/) for an alternative X11 configuration.**
