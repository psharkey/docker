FROM resin/rpi-raspbian:jessie

# Let's start with some basic stuff.
RUN apt-get update -qq && apt-get install -qqy \
	apt-transport-https \
	ca-certificates \
	curl \
	git \
	iptables \
	libxext-dev libxrender-dev libxtst-dev \
	ssh-askpass \ 
	unzip \
	wget \
	zip

# Install Docker from Docker Inc. repositories.
ARG DOCKER_VERSION=1.10.3
RUN curl -L -O https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz \
	&& tar zxf docker-${DOCKER_VERSION}.tgz -C /

# Install Docker Compose
ENV DOCKER_COMPOSE_VERSION 1.3.3
RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose \
	&& chmod +x /usr/local/bin/docker-compose

# Install Jenkins
ENV JENKINS_HOME=/var/lib/jenkins JENKINS_UC=https://updates.jenkins-ci.org HOME="/var/lib/jenkins"
RUN wget --progress=bar:force -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add - \
	&& sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list' \
	&& apt-get update && apt-get install -y jenkins \ 
	&& apt-get clean \
	&& apt-get purge \
	&& rm -rf /var/lib/apt/lists/*

# Make the jenkins user a sudoer
# Replace the docker binary with a sudo script
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers \
	&& mv /usr/local/bin/docker /usr/local/bin/docker.bin \ 
	&& printf '#!/bin/bash\nsudo docker.bin "$@"\n' > /usr/local/bin/docker \
	&& chmod +x /usr/local/bin/docker

# Copy basic configuration into jenkins
COPY config.xml credentials.xml hudson.tasks.Ant.xml hudson.tasks.Maven.xml plugins.txt $JENKINS_HOME/

# Install Jenkins plugins from the specified list
# Install jobs & setup ownership & links
COPY plugins.sh /usr/local/bin/plugins.sh 
COPY jobs/. $JENKINS_HOME/jobs
RUN chmod +x /usr/local/bin/plugins.sh; sleep 1 \
	&& /usr/local/bin/plugins.sh $JENKINS_HOME/plugins.txt \
	&& chown -R jenkins:jenkins /var/lib/jenkins

# Define the workspace - assuming the path does not contain #
ARG WORKSPACE='${ITEM_ROOTDIR}\/workspace'
RUN sed -i -- "s#\${ITEM_ROOTDIR}/workspace#${WORKSPACE}#" $JENKINS_HOME/config.xml
 
# Expose Jenkins default port
EXPOSE 8080

# Become the jenkins user (who thinks sudo is not needed for docker commands)
USER jenkins
WORKDIR /var/lib/jenkins

# Start the war
CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war"]
