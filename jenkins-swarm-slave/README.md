# Jenkins Swarm Slave
___
From [psharkey/toolbox](https://hub.docker.com/r/psharkey/toolbox/) with [Jenkins Swarm](https://wiki.jenkins-ci.org/display/JENKINS/Swarm+Plugin) capabilities.

## Example Usage
___
A version of the [V2 docker-compose example](https://github.com/psharkey/docker/blob/jenkins-swarm-slave/jenkins-swarm-slave/docker-compose.yml) is shown below to illustrate how this image can be used.

1. Start the containters using `docker-compose up -d`
2. Use `docker ps -f name=jenkinsswarmslave_master_1 --format "{{.Ports}}"` to find the **address:port** for Jenkins (**0.0.0.0:10080** for the following example)- 
```
$ docker ps -f name=jenkinsswarmslave_master_1 --format "{{.Ports}}"
0.0.0.0:10080->8080/tcp
$
```
3. Browse to `http://0.0.0.0:10080/configure` *(using the **address:port** from the previous step)* and set the Jenkins URL to `http://master:8080/` and hit `Save`
4. A single slave with 5 executors should connect automatically.
5. Use `docker-compose scale slave=3` to see the 2 additional slaves.

## Teardown
___
When you're finished, use `docker-compose stop` and `docker-compose rm` to stop and remove the containers.
```bash
$ docker-compose stop
Stopping jenkinsswarmslave_slave_3 ... done
Stopping jenkinsswarmslave_slave_2 ... done
Stopping jenkinsswarmslave_master_1 ... done
Stopping jenkinsswarmslave_slave_1 ... done
$ docker-compose rm
Going to remove jenkinsswarmslave_slave_3, jenkinsswarmslave_slave_2, jenkinsswarmslave_master_1, jenkinsswarmslave_data_1, jenkinsswarmslave_slave_1
Are you sure? [yN] y
Removing jenkinsswarmslave_slave_3 ... done
Removing jenkinsswarmslave_slave_2 ... done
Removing jenkinsswarmslave_master_1 ... done
Removing jenkinsswarmslave_data_1 ... done
Removing jenkinsswarmslave_slave_1 ... done
$
```
## On DockerHub / GitHub
___
* DockerHub [psharkey/novnc](https://hub.docker.com/r/psharkey/jenkins-swarm-slave/)
* GitHub [psharkey/docker/jenkins-swarm-slave](https://github.com/psharkey/docker/tree/jenkins-swarm-slave/jenkins-swarm-slave)
