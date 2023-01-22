FROM alpine:latest

MAINTAINER 	Crispin Tschirky <crispin.tschirky@gmail.com>

COPY ./scripts/shutdown /sbin/shutdown

RUN apk --no-cache add qemu-guest-agent && \
    wget https://github.com/siderolabs/talos/releases/download/v1.2.8/talosctl-linux-amd64 && \
    mv talosctl-linux-amd64 /usr/bin/talosctl && \
    chmod 755 /usr/bin/talosctl

USER root

ENTRYPOINT ["qemu-ga"]
