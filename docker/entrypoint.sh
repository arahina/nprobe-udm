#!/bin/bash

set -e

echo "***** nProbe **********"
echo `ls -al /usr/bin/nprobe*`
echo `ls -al /etc/nprobe*`
/usr/bin/nprobe /etc/nprobe/nprobe.conf
