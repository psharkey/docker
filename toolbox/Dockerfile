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
ENV DOCKER_COMPOSE_VERSION 1.6.2
RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose \
	&& chmod +x /usr/local/bin/docker-compose

CMD ["/bin/bash"] 
