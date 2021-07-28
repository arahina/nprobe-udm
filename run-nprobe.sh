#!/bin/sh

# This script prefers to be passed in something like "./runbr50.sh br50" ie the interface on the UDM to probe

if [ -z $1 ]; 
then
    echo "UDM interface to run was not passed in - assuming br0"
    export INTERFACE="br0"
    export CONTNAME="nprobe-udm-$INTERFACE"
    export FULLNAME="localhost/nprobe-udm:latest"
else
    echo "UDM interface to run is: $1"
    export INTERFACE=$1
    export CONTNAME="nprobe-udm-$INTERFACE"
    export FULLNAME="localhost/nprobe-udm:latest"
fi


# Set this for the interface to probe
$export INTERFACE="br50"

# Run the container which uses the correct nprobe-conf file for the interface to avoid listener port overlaps
podman run -d --net=host --restart always \
   --name $CONTNAME \
   -v /mnt/data_ext/nprobe/nprobe-$INTERFACE.conf:/etc/nprobe/nprobe.conf \
   -v /mnt/data_ext/nprobe/nprobe.license:/etc/nprobe.license \
   -v /mnt/data_ext/nprobe/GeoIP.conf:/etc/GeoIP.conf \
   $FULLNAME

# Look at logs to see if its running and looks right
podman logs $CONTNAME
