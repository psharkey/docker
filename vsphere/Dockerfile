FROM maven:3.5-jdk-8-alpine

# Update and install packages
RUN apk --update add \
	git \
	less=487-r0 \
	vim \
	&& rm -rf /var/cache/apk/*

# Shallow clone the project to /work
RUN git clone --depth 1 https://github.com/vmware/vsphere-automation-sdk-java.git /work/vsphere-automation-sdk-java

# Build the samples
WORKDIR /work/vsphere-automation-sdk-java/
RUN mvn initialize; mvn clean install
CMD ["/bin/bash"]
