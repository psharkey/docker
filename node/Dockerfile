FROM psharkey/ansible-alpine:2.3.0.0-less

ARG NODE_VERSION=6.10.3-r1
RUN apk update && apk add \
	nodejs=$NODE_VERSION \
	nodejs-npm=$NODE_VERSION \
	&& rm -rf /var/cache/apk/*
