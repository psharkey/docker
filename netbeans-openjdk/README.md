Based on [fgrehm/netbeans](https://hub.docker.com/r/fgrehm/netbeans/~/dockerfile/) and [dirichlet/netbeans](https://hub.docker.com/r/dirichlet/netbeans/) but uses [NetBeans nightly build](http://bits.netbeans.org/download/trunk/nightly/latest/) on top of the Maven/OpenJDK official image.

The following bash function example for Docker/native OS X:
* Determines the DISPLAY variable (reference https://github.com/chanezon/docker-tips/blob/master/x11/README.md)
* Sets the timezone
* Creates volumes from a host 'Workspace'
* Uses volumes from other data containers (see [toolbox](https://github.com/psharkey/docker/blob/master/toolbox/README.md))
* Shares docker.sock for [DooD](https://github.com/psharkey/docker/tree/master/jenkins-dood)
* Assumes the `startx` bash helper function has been executed once

```bash
netbeans(){
        del_stopped netbeans-dev
	DISPLAY_MAC=`ifconfig en0 | grep "inet " | cut -d " " -f2`:0
        docker run -d -it \
                -e DISPLAY=$DISPLAY_MAC \
                -e "TZ=America/Chicago" \
                -v $HOME/Workspace/.netbeans:/root/.netbeans \
                --volumes-from github \
                --volumes-from m2 \
                -v /var/run/docker.sock:/var/run/docker.sock \
                --name netbeans \
                psharkey/netbeans:latest
}
startx() {
    if [ -z "$(ps -ef|grep XQuartz|grep -v grep)" ] ; then
        open -a XQuartz
        socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
    fi
}
```

**Refer to [psharkey/novnc](https://hub.docker.com/r/psharkey/novnc/) for an alternative X11 configuration.**
