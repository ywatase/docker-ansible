FROM alpine:latest
RUN apk add -U $(apk -U info -Rq ansible) py-pip \
    && pip --no-cache-dir install ansible==2.4.0 ansible-lint \
    && rm -rf /var/cache/apk/*
