#!/bin/bash

IMAGE="qemu-ga-talos"
VERSION="v0.0.1"

TARGET="docker.io/e3ag/$IMAGE:$VERSION"
TARGET_LATEST="docker.io/e3ag/$IMAGE:latest"

podman build -t "${IMAGE}:${VERSION}" .

podman tag $IMAGE:$VERSION $TARGET
podman tag $IMAGE:$VERSION $TARGET_LATEST
podman push $TARGET
podman push $TARGET_LATEST
