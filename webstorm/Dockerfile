#
# WebStorm + OpenJDK 8
#
FROM ubuntu

# Get the python script required for "add-apt-repository"
# Configure the openjdk repo
RUN apt-get update \ 
	&& apt-get install -y software-properties-common \
	&& add-apt-repository ppa:openjdk-r/ppa

# Install OpenJDK 8, X11 libraries, and wget
RUN add-apt-repository ppa:webupd8team/java && apt-get update \
	&& apt-get install -y \ 
		libxext-dev libxrender-dev libxtst-dev \
		openjdk-8-jdk \
		wget \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/*

# wget WebStorm 
ENV WEBSTORM_URL=https://download.jetbrains.com/webstorm/WebStorm-2016.2.4.tar.gz
RUN wget --progress=bar:force $WEBSTORM_URL -O /tmp/webstorm.tar.gz \
	&& mkdir /opt/webstorm \
	&& tar -xzf /tmp/webstorm.tar.gz -C /opt/webstorm --strip-components=1 \
	&& rm -rf /tmp/*

CMD ["/opt/webstorm/bin/webstorm.sh"]
