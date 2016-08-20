FROM	java

ARG	DIRECTOR_URL=http://eclipse.mirror.rafal.ca/tools/buckminster/products/director_latest.zip
RUN 	curl -L $DIRECTOR_URL -o /tmp/director.zip \
	&& unzip /tmp/director.zip -d /tmp \
	&& rm /tmp/director.zip

ARG	BUCKMINSTER_VERSION=4.5
RUN	/tmp/director/director \
	-r http://download.eclipse.org/tools/buckminster/headless-$BUCKMINSTER_VERSION/ \
	-d /opt/buckminster \
	-p Buckminster \
	-i org.eclipse.buckminster.cmdline.product

ENTRYPOINT ["/opt/buckminster/buckminster"]
