FROM maven
MAINTAINER Pat Sharkey <psharkey@cleo.com>

# Download & install the unlimited strength policy jars
RUN curl -L -o /tmp/policy.zip \
		--cookie 'oraclelicense=accept-securebackup-cookie;' \
		http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip \ 
	&& JAVA_HOME=$(update-java-alternatives --list | awk '{print $3}') \
	&& unzip -j -o /tmp/policy.zip *.jar -d $JAVA_HOME/jre/lib/security \
	&& rm /tmp/policy.zip

# Add ant and vim to java, maven, git, & svn
# Finish with some simple tool tests showing their versions 
RUN apt-get update && apt-get install -y --no-install-recommends \
        ant \
        ant-optional \
        vim \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/* \
	&& ant -version \
	&& git --version \
	&& java -version \
	&& mvn --version \
	&& svn --version \
	&& vi --version
