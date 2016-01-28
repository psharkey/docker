#
# InteiilJ IDEA + OpenJDK 8
#
FROM ubuntu

# Get the python script required for "add-apt-repository"
# Configure the openjdk repo
RUN apt-get update \ 
	&& apt-get install -y software-properties-common \
	&& add-apt-repository ppa:openjdk-r/ppa

# Install curl, OpenJDK, X11 libraries, unzip, and wget
RUN add-apt-repository ppa:webupd8team/java && apt-get update \
	&& apt-get install -y \ 
		curl \
		libxext-dev libxrender-dev libxtst-dev \
		openjdk-8-jdk \
		unzip \
		wget \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/*

# Download & install the unlimited strength policy jars
RUN curl -L -o /tmp/policy.zip \
		--cookie 'oraclelicense=accept-securebackup-cookie;' \
		http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip \ 
	&& JAVA_HOME=$(update-java-alternatives --list | awk '{print $3}') \
	&& unzip -j -o /tmp/policy.zip *.jar -d $JAVA_HOME/jre/lib/security \
	&& rm /tmp/policy.zip

# wget IntelliJ IDEA 
ENV INTELLIJ_URL=https://download.jetbrains.com/idea/ideaIC-15.0.3.tar.gz
RUN wget --progress=bar:force $INTELLIJ_URL -O /tmp/intellij.tar.gz \
	&& mkdir /opt/intellij \
	&& tar -xzf /tmp/intellij.tar.gz -C /opt/intellij --strip-components=1 \
	&& rm -rf /tmp/*

CMD ["/opt/intellij/bin/idea.sh"]
