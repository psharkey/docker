FROM maven:3.5-alpine
MAINTAINER Pat Sharkey <psharkey@cleo.com>

ARG NODE_VERSION=6.10.3-r1
ARG DOCKER_VERSION=17.05.0-r0
# Let's start with some basic stuff.
RUN apk update && apk add \
        apache-ant \
	bzip2 \
	ca-certificates \
	curl \
	docker=$DOCKER_VERSION \
	iptables \
	make \
	nodejs=$NODE_VERSION \
	py-pip \
        shadow \
	sshpass \ 
	sudo \
        vim \
	zip \
	&& rm -rf /var/cache/apk/*

RUN pip install docker-compose

# Add a user & let each instance define the uid, gid, & home
# Intended for use with Jenkins but opens other possibilities
ARG TOOLBOX_USER=toolbox
ARG TOOLBOX_GROUP=root
ARG TOOLBOX_UID=1000
ARG TOOLBOX_GID=0
ARG TOOLBOX_HOME=/home/toolbox
ENV PATH=${TOOLBOX_HOME}:$PATH
# Make the TOOLBOX_USER user a sudoer
# Change the user's profile to execute the docker binaries with sudo scripts
RUN groupadd -f -g ${TOOLBOX_GID} ${TOOLBOX_GROUP} \
	&& useradd -d ${TOOLBOX_HOME} -u ${TOOLBOX_UID} -g ${TOOLBOX_GID} -m -s /bin/bash ${TOOLBOX_USER} \
	&& chown -R ${TOOLBOX_USER}:${TOOLBOX_GROUP} ${TOOLBOX_HOME} \
	&& echo "root ALL=NOPASSWD: ALL" >> /etc/sudoers \
	&& echo "${TOOLBOX_USER} ALL=NOPASSWD: ALL" >> /etc/sudoers \
	&& printf '#!/bin/bash\nsudo /usr/bin/docker "$@"\n' > ${TOOLBOX_HOME}/docker \
	&& printf '#!/bin/bash\nsudo /usr/bin/docker-compose "$@"\n' > ${TOOLBOX_HOME}/docker-compose \
	&& chmod +x ${TOOLBOX_HOME}/docker*

CMD ["/bin/bash"] 
