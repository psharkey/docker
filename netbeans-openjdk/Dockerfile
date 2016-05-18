# 
# NetBeans Nightly Build + OpenJDK
#
FROM maven

# Install X11 tools and those needed here for downloads.
RUN apt-get update && apt-get install -y \ 
	curl libxext-dev libxrender-dev libxtst-dev unzip wget \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/*

ARG NETBEANS_URL=http://bits.netbeans.org/download/trunk/nightly/latest/bundles
ARG COOKIE="Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"

RUN wget --progress=bar:force -O /tmp/netbeans.sh \
	$NETBEANS_URL/netbeans-trunk-nightly-$(date +"%Y%m%d")0002-javase-linux.sh \
        --no-cookies --no-check-certificate --header "$COOKIE" \
        && echo "Installing NetBeans..." \
        && chmod +x /tmp/netbeans.sh; sleep 1 \
        && /tmp/netbeans.sh --silent \
        && rm -rf /tmp/* \
        && ln -s $(ls -d /usr/local/netbeans-*) /usr/local/netbeans

CMD /usr/local/netbeans/bin/netbeans --jdkhome /usr/lib/jvm/java-8-openjdk-amd64
