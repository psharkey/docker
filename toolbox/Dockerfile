FROM maven
MAINTAINER Pat Sharkey <psharkey@cleo.com>

# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install -qqy \
        ant \
        ant-optional \
	apt-transport-https \
	bzip2 \
	ca-certificates \
	curl \
	iptables \
	ssh-askpass \ 
	sudo \
        vim \
	zip \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/*

# Install Node.js v5 via package manager
# (https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions)
RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get install -qqy nodejs

# Install Docker from Docker Inc. repositories.
RUN curl -L https://get.docker.com/ | sh

# Install Docker Compose
ENV DOCKER_COMPOSE_VERSION=1.6.2 DOCKER_SIBLINGS=TRUE
RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose \
	&& chmod +x /usr/local/bin/docker-compose

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
	&& printf '#!/bin/bash\nsudo /usr/local/bin/docker-compose "$@"\n' > ${TOOLBOX_HOME}/docker-compose \
	&& chmod +x ${TOOLBOX_HOME}/docker*

CMD ["/bin/bash"] 
