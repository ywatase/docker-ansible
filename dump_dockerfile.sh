#!/bin/sh
ansible_versions="2.3.2 2.4.0"
main() {
    [ -d Dockerfiles ] || mkdir Dockerfiles
    for tag in $ansible_versions
    do
        dump_dockerfile > Dockerfiles/Dockerfile.$tag
    done
}

dump_dockerfile () {
cat <<END
FROM alpine:latest
RUN apk add -U \$(apk -U info -Rq ansible) py-pip \\
    && pip --no-cache-dir install ansible==$tag ansible-lint \\
    && rm -rf /var/cache/apk/*
END
}

main "$@"

# vim: set et ts=4 sw=4 sts=4:
