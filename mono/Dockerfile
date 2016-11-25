FROM alpine:3.4

# mono is in testing repo
RUN echo "http://dl-6.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# Install mono
RUN apk --update --upgrade add \
	mono
