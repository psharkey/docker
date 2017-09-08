FROM node:8.4-alpine

ARG HEROKU_VERSION=6.14.20
RUN apk --update add \
		bash \
		git \
		less=487-r0 \
	&& npm install -g heroku-cli@$HEROKU_VERSION

CMD ["bash"]
