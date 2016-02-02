#
# NetBeans 8.1 + JDK 1.8u65 bundle
#
FROM ubuntu

# Install X11 tools and those needed here for downloads.
RUN apt-get update && apt-get install -y \ 
	curl libxext-dev libxrender-dev libxtst-dev unzip wget \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/*

ENV NETBEANS_VERSION=8.1 \
	COOKIE="Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
	NETBEANS_URL=http://download.oracle.com/otn-pub/java/jdk-nb/8u65-8.1/jdk-8u65-nb-8_1-linux-x64.sh

RUN wget --progress=bar:force $NETBEANS_URL -O /tmp/netbeans.sh \
	--no-cookies --no-check-certificate --header "$COOKIE" \
	&& echo "Installing NetBeans $NETBEANS_VERSION..." \
	&& chmod +x /tmp/netbeans.sh; sleep 1 \
	&& /tmp/netbeans.sh --silent \
	&& rm -rf /tmp/*

# Download & install the unlimited strength policy jars
RUN curl -L -o /tmp/policy.zip \
		--cookie 'oraclelicense=accept-securebackup-cookie;' \
		http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip \ 
	&& JAVA_HOME=/usr/local/jdk1.8.0_65 \
	&& unzip -j -o /tmp/policy.zip -d $JAVA_HOME/jre/lib/security \
	&& rm /tmp/policy.zip

CMD /usr/local/netbeans-$NETBEANS_VERSION/bin/netbeans
