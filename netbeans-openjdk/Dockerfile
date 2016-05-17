#
# NetBeans Nightly Build + OpenJDK 8.1
#
FROM maven:3.3.9-jdk-8

# Install X11 tools and those needed here for downloads.
RUN apt-get update && apt-get install -y \ 
	curl libxext-dev libxrender-dev libxtst-dev unzip wget \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/*

ARG NETBEANS_URL=http://bits.netbeans.org/download/trunk/nightly/latest/bundles/netbeans-trunk-nightly-201605160002-javase-linux.sh
ARG COOKIE="Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie"

RUN wget --progress=bar:force $NETBEANS_URL -O /tmp/netbeans.sh \
        --no-cookies --no-check-certificate --header "$COOKIE" \
        && echo "Installing NetBeans $NETBEANS_VERSION..." \
        && chmod +x /tmp/netbeans.sh; sleep 1 \
        && /tmp/netbeans.sh --silent \
        && rm -rf /tmp/* \
        && ln -s $(ls -d /usr/local/netbeans-*) /usr/local/netbeans

CMD /usr/local/netbeans/bin/netbeans
