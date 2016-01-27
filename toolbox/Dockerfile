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

# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

ENV NODE_VERSION=0.10.41 NPM_VERSION=2.14.1

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
	&& curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
	&& gpg --verify SHASUMS256.txt.asc \
	&& grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
	&& tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
	&& rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
	&& npm install -g npm@"$NPM_VERSION" \
	&& npm cache clear

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
