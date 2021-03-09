#!/bin/sh
ansible_versions="2.4.6 2.5.15 2.6.20 2.7.18 2.8.19 2.9.18 2.10.7 3.0.0"
main() {
    [ -d Dockerfiles ] || mkdir Dockerfiles
    for tag in $ansible_versions
    do
        dump_dockerfile > Dockerfiles/Dockerfile.$tag-alpine
        dump_dockerfile_slim > Dockerfiles/Dockerfile.$tag-slim
    done
}

dump_dockerfile () {
cat <<END
FROM alpine:latest
RUN apk add -U \$(apk -U info -Rq ansible) py3-pip py3-wheel \\
    && pip3 --no-cache-dir install ansible==$tag ansible-lint \\
    && rm -rf /var/cache/apk/*
END
}

dump_dockerfile_slim () {
cat <<END
FROM python:3.7-slim-buster as builder
RUN pip3 install ansible==$tag ansible-lint

FROM python:3.7-slim-buster
COPY --from=builder /usr/local/lib/python3.7/site-packages /usr/local/lib/python3.7/site-packages
COPY --from=builder /usr/local/bin/ansible /usr/local/bin
COPY --from=builder /usr/local/bin/ansible-lint /usr/local/bin
END
}

main "$@"

# vim: set et ts=4 sw=4 sts=4:
