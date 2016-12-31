FROM resin/rpi-raspbian:jessie

# Setup demo environment variables
ENV HOME=/root \
	DEBIAN_FRONTEND=noninteractive \
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=C.UTF-8

# Install git, supervisor, VNC, & X11 packages
RUN apt-get update && apt-get install -y \
	curl \
	git \
	net-tools \
	openjdk-8-jre \
	unzip \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Download Che and unzip
ARG CHE_URL=https://install.codenvycorp.com/che/eclipse-che-latest.zip
RUN curl -L $CHE_URL -o /tmp/che.zip \
        && unzip -j -o /tmp/che.zip -d $HOME \
	&& rm /tmp/che.zip

EXPOSE 8080
