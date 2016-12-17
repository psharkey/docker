FROM alpine:3.4

RUN  apk --update add \
         libxext \
         libxtst \
         libxrender \
         virt-manager \
    && apk del build-dependencies \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/apk/*
