#!/bin/bash

IMAGE="qemu-guest-agent-talos"
VERSION="v0.0.5-SNAPSHOT"

REPO="ghcr.io/crisobal"

tag(){
    SRC=$1
    TGT=$2
    echo ""
    echo "Tag image: ${SRC} -> ${TGT}"
    podman tag ${SRC} ${TGT}
}

push(){
    TGT=$1
    echo ""
    echo "Push to: ${TGT}"
    podman push ${TGT}
}

release(){
    SRC=$IMAGE:$VERSION
    TGT=$1/${IMAGE}:$2
    tag ${SRC} ${TGT}
    push ${TGT}
}

podman build -t "${IMAGE}:${VERSION}" .


release ${REPO} ${VERSION}
release ${REPO} "latest"
