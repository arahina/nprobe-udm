#!/bin/sh

# This Script File builds the container and then copies it to the UDM

export CONTAINERMANAGER="podman"
export UDMPROHOSTNAME="arahina-udmpro.arahina.network"
export UDMPROUSERNAME="root"

# We use latest because its just easier when writing these scripts but you can change it to a version number
export TAGVERSION="latest"
export TAGNAME="nprobe-udm"
export MAINTAG="$TAGNAME:$TAGVERSION"
export FULLTAG="localhost/$TAGNAME:$TAGVERSION"

# Build - Tested on RPi4b with 8GB of RAM running Ubuntu 20.04
#docker buildx build --platform linux/arm64 -t nprobe-udm:latest --load .
$CONTAINERMANAGER build --platform linux/arm64 -t $MAINTAG docker/.

# If you want to export the image uncomment this, for exampl
#CONTAINERMANAGER save -o ./nprobe-udm.tar nprobe-udm:latest 

# Uncomment this to copy the image file somewhere useful
#scp nprobe-udm.tar  $UDMPROUSERNAME@$UDMPROHOSTNAME

# Config Files for the container
#tar cvf nprobe-files.tar GeoIP.conf run.sh

# Run what we just built for interface br0 and br50 (Arahina uses multiple subnets)
./run-nprobe.sh br0
./run-nprobe.sh br50


