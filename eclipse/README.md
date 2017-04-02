![alt text](http://www.eclipse.org/eclipse.org-common/themes/solstice/public/images/logo/eclipse-426x100.png)
# Eclipse IDE for Java Developers

The [Eclipse IDE for Java Developers](http://www.eclipse.org/downloads/packages/eclipse-ide-java-developers/neonr) includes the essential tools for any Java developer, including a Java IDE, a Git client, XML Editor, Mylyn, Maven and Gradle integration.

## System Requirements

* An X11 server (see [Usage](#usage) for an OS X example).

## Usage

Example OS X `eclipse` bash function:

```bash
eclipse(){
	# Reference - https://github.com/chanezon/docker-tips/blob/master/x11/README.md
	if [ -z "$(ps -ef|grep XQuartz|grep -v grep)" ] ; then
		open -a XQuartz
		socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
	fi
	DISPLAY_MAC=`ifconfig en0 | grep "inet " | cut -d " " -f2`:0
	docker run -d -it \
		-e DISPLAY=$DISPLAY_MAC \
		-e "TZ=America/Chicago" \
		--name eclipse \
		psharkey/eclipse
	echo -e "Eclipse started on $DISPLAY_MAC \xF0\x9f\x8d\xba"
}
```

## On DockerHub / GitHub

* DockerHub [psharkey/eclipse](https://hub.docker.com/r/psharkey/eclipse/)
* GitHub [psharkey/docker/eclipse](https://github.com/psharkey/docker/tree/eclipse/eclipse)

## Thanks

Based on [batmat/docker-eclipse](https://hub.docker.com/r/batmat/docker-eclipse/~/dockerfile/).

**Refer to [psharkey/novnc](https://hub.docker.com/r/psharkey/novnc/) for an alternative X11 configuration.**
