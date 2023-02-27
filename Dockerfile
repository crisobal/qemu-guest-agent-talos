FROM alpine:latest

LABEL org.opencontainers.image.authors="Crispin Tschirky <crispin.tschirky@gmail.com>"
LABEL description="Provides Qemu Guest Agent using talosctl to shutdown/reboot host node. Intended as daemonset for talos running on proxmox"
LABEL org.opencontainers.image.description="Provides Qemu Guest Agent using talosctl to shutdown/reboot host node. Intended as daemonset for talos running on proxmox"

COPY ./scripts/shutdown /sbin/shutdown
COPY ./scripts/service.sh /usr/local/bin/service.sh

RUN apk --no-cache add qemu-guest-agent && \
    echo "$arch" && \
    wget https://github.com/siderolabs/talos/releases/download/v1.3.5/talosctl-linux-amd64 && \
    mv talosctl-linux-amd64 /usr/bin/talosctl && \
    chmod 755 /usr/bin/talosctl && \
    mkfifo /var/log/qemu-ga.log && \
    chmod 777 /var/log/qemu-ga.log

USER root

ENTRYPOINT ["/usr/local/bin/service.sh"]
