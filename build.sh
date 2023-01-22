#!/bin/bash

IMAGE="qemu-guest-agent-talos"
VERSION="v0.0.1"

TARGET="ghcr.io/crisobal/$IMAGE:$VERSION"
TARGET_LATEST="ghcr.io/crisobal/$IMAGE:latest"

podman build -t "${IMAGE}:${VERSION}" .

podman tag $IMAGE:$VERSION $TARGET
podman tag $IMAGE:$VERSION $TARGET_LATEST
podman push $TARGET
podman push $TARGET_LATEST
