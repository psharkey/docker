FROM  jamesnetherton/docker-atom-editor:v1.18.0

USER root

RUN	apt-get update && apt-get install -y --no-install-recommends \
		build-essential \
		ca-certificates \
		openssl \
		openssh-client \
		python-dev \
		python-pip \
		python-setuptools \
                subversion \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN 	pip install --upgrade \
		pip \
		cffi \
                virtualenv
RUN	pip install \
		ansible==2.2.1.0 \
                ansible-lint==3.4.13 \
		boto==2.45.0 \
 		boto3==1.4.4 \
		docker-py==1.10.6 \
		dopy==0.3.7 \
		pywinrm>=0.1.1 \
		pyvmomi==6.0.0.2016.6 \
		pysphere>=0.1.7

USER atom
