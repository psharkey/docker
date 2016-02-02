# InteiilJ IDEA + OpenJDK 8

Example usage:
```bash
intellij(){
	x11host
	docker run -d \
		-e DISPLAY=$X11HOST:0.0 \
		-e "TZ=America/Chicago" \
		-v $HOME/Workspace/.intellij:/root/.IdeaIC15 \
		--volumes-from github \
		--volumes-from m2 \
		--name intellij \
		psharkey/intellij
}
```
Parameter explanation:
* Set the `DISPLAY` variable using the value (from the helper function below)
* Set the timezone (to your local value)
* Map a volume to persist the Intellij IDEA preferences
* Map volumes from `github` and `m2` data containers created for [(toolbox)](https://github.com/psharkey/docker/tree/master/toolbox)
X11 helper function:
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
