FROM alpine:3.1
RUN apk add --update socat bash && \
    rm -rf /var/cache/apk/*
ENTRYPOINT ["socat"]
CMD ["-d", "TCP-LISTEN:2375,reuseaddr,fork", "UNIX-CLIENT:/var/run/docker.sock"]
