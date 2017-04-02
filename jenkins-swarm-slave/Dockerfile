FROM psharkey/toolbox

# Add a user & let each instance define the uid, gid, & home
# Intended for use with Jenkins but opens other possibilities
ARG TOOLBOX_USER=jenkins
ARG TOOLBOX_GROUP=jenkins
ARG TOOLBOX_UID=1000
ARG TOOLBOX_GID=1000
ARG TOOLBOX_HOME=/var/lib/jenkins
# Make the TOOLBOX_USER user a sudoer
# Replace the docker binary with a sudo script
RUN groupadd -f -g ${TOOLBOX_GID} ${TOOLBOX_GROUP} \
        && useradd -o -d ${TOOLBOX_HOME} -u ${TOOLBOX_UID} -g ${TOOLBOX_GID} -m -s /bin/bash ${TOOLBOX_USER} \
        && chown -R ${TOOLBOX_USER}:${TOOLBOX_GROUP} ${TOOLBOX_HOME} \
        && echo "root ALL=NOPASSWD: ALL" >> /etc/sudoers \
        && echo "${TOOLBOX_USER} ALL=NOPASSWD: ALL" >> /etc/sudoers \
        && mv /usr/bin/docker /usr/bin/docker.bin \
        && printf '#!/bin/bash\nsudo docker.bin "$@"\n' > /usr/bin/docker \
        && chmod +x /usr/bin/docker

# Become a swarm client
ARG SWARM_HOME=./
ARG SWARM_VERSION=2.1
RUN wget --progress=bar:force \
		http://maven.jenkins-ci.org/content/repositories/releases/org/jenkins-ci/plugins/swarm-client/${SWARM_VERSION}/swarm-client-${SWARM_VERSION}-jar-with-dependencies.jar \
		-O ${SWARM_HOME}/swarm-client-jar-with-dependencies.jar \
	&& chmod +x ${SWARM_HOME}/swarm-client-jar-with-dependencies.jar

CMD ["java", "-jar", "swarm-client-jar-with-dependencies.jar"]
