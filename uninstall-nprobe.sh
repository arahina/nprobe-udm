#!/bin/sh

# Podman Cleanup and Removal script
# Stop and Remvoe running nProbe containers and then remove images

# Default nprobe on br0
export CONTAINERNAME="nprobe-udm-br0"
podman stop $CONTAINERNAME; podman rm $CONTAINERNAME; podman rmi localhost/nprobe-udm:latest

# Additional nprobe on br50
export CONTAINERNAME="nprobe-udm-br50"
podman stop $CONTAINERNAME; podman rm $CONTAINERNAME; podman rmi localhost/nprobe-udm:latest

# Remove Debian images installed by the build process
podman rmi docker.io/library/debian:buster-slim

# Display images so we can confirm all is completed
podman images
