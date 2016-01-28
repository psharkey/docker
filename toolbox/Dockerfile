FROM maven
MAINTAINER Pat Sharkey <psharkey@cleo.com>

# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install -qqy \
        ant \
        ant-optional \
	apt-transport-https \
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
ENV DOCKER_COMPOSE_VERSION 1.3.3
RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose \
	&& chmod +x /usr/local/bin/docker-compose

# Download & install the unlimited strength policy jars
RUN curl -L -o /tmp/policy.zip \
		--cookie 'oraclelicense=accept-securebackup-cookie;' \
		http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip \ 
	&& JAVA_HOME=$(update-java-alternatives --list | awk '{print $3}') \
	&& unzip -j -o /tmp/policy.zip *.jar -d $JAVA_HOME/jre/lib/security \
	&& rm /tmp/policy.zip

CMD ["/bin/bash"] 
