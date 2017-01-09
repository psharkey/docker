FROM resin/rpi-raspbian:jessie

RUN apt-get update && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        net-tools \
        openjdk-8-jre \
        vim \
    --no-install-recommends

RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
    echo "deb https://apt.dockerproject.org/repo raspbian-jessie main"  > /etc/apt/sources.list.d/docker.list && \
    apt-get update && apt-get install -y docker-engine  \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

ENV LANG=C.UTF-8 \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-armhf/jre \
    PATH=${PATH}:${JAVA_HOME}/bin \
    CHE_IN_CONTAINER=true

# Download Che
ARG CHE_VERSION=5.0.0-M8
ARG CHE_URL=https://install.codenvycorp.com/che/eclipse-che-$CHE_VERSION.tar.gz
ARG CHE_DIR=/home/user
RUN mkdir -p $CHE_DIR \
	&& curl -L -O $CHE_URL \
	&& tar zxf eclipse-che-$CHE_VERSION.tar.gz -C $CHE_DIR \
        && ln -s $CHE_DIR/eclipse-che-$CHE_VERSION $CHE_DIR/eclipse-che \
	&& rm eclipse-che-$CHE_VERSION.tar.gz

# Add a link to create a common path for CMD
# Update Che’s built-in stacks to be ARM-compatible
# Increasing timeout for workspace provisioning
#RUN ln -s $CHE_DIR /opt/eclipse-che \
#	&& sed -i 's/codenvy\/ubuntu_jdk8/kartben\/armhf-che-jdk8/g' $CHE_DIR/stacks/stacks.json \
#	&& sed -i 's/codenvy\/node/kartben\/armhf-che-node/g' $CHE_DIR/stacks/stacks.json \
#	&& sed -i 's/machine.ws_agent.max_start_time_ms=60000/machine.ws_agent.max_start_time_ms=240000/g' $CHE_DIR/conf/che.properties

EXPOSE 8000 8080
ADD https://raw.githubusercontent.com/eclipse/che/master/dockerfiles/che/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
#ENTRYPOINT ["/entrypoint.sh"]
