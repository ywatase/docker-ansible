#!/bin/sh
#ansible_versions="2.4.6 2.5.15 2.6.20 2.7.18 2.8.19 2.9.18 2.10.7 3.0.0 3.1.0"
ansible_versions="3.1.0 3.2.0 3.3.0 3.4.0 4.0.0 4.1.0 4.2.0 4.3.0 4.4.0 4.5.0 4.6.0"
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
FROM python:3.9-slim as builder
RUN pip3 install ansible==$tag ansible-lint

FROM python:3.9-slim
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /usr/local/bin/ansible /usr/local/bin
COPY --from=builder /usr/local/bin/ansible-* /usr/local/bin
END
}

main "$@"

# vim: set et ts=4 sw=4 sts=4:
