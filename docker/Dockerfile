FROM debian:buster-slim

COPY entrypoint.sh /entrypoint.sh

# Use use the license file mounted by podman in /mnt/data_ext/nprobe so this copy is no longer used any more
#COPY nprobe.license /etc/

#RUN  mkdir -p /usr/local/lib/nprobe/plugins
#COPY lib/plugins/* /usr/local/lib/nprobe/plugins/

# This will install essentail packages, at least for GeoIP, everything isn't needed, I trimmed it from ntopng pkg list
RUN apt-get update \
        && apt-get --no-install-recommends -y install libcurl4 libpcap0.8 \
            libssl1.1 lsb-release ethtool libcap2 bridge-utils libnetfilter-conntrack3 libzstd1 libmaxminddb0 \
            libradcli4 libjson-c3 libsnmp30 udev libzmq5 libcurl3-gnutls net-tools curl procps \
        && rm -rf /var/lib/apt/lists/* \
        && curl -Lo /tmp/geoipupdate_2.3.1-1_arm64.deb  http://ftp.us.debian.org/debian/pool/contrib/g/geoipupdate/geoipupdate_2.3.1-1_arm64.deb \
        && dpkg -i /tmp/*.deb && rm /tmp/*.deb 


# This fetches the Ntop debian package for UDM, unpacks it and grabs the binary nprobe and nprobe-config and discards everything else.   I did it this way be because the .deb needs systemd which doesn't work in a container and I couldn't just install it
RUN mkdir /tmp/nprobe \
        && curl --insecure -Lo /tmp/nprobe/nprobe_9.5.210322-7188_arm64.deb https://packages.ntop.org/Ubiquity/UDMPro/nprobe_9.5.210322-7188_arm64.deb \
        && dpkg-deb -xv /tmp/nprobe/nprobe_9.5.210322-7188_arm64.deb  /tmp/nprobe/ \
        && cp /tmp/nprobe/usr/bin/nprobe* /usr/bin \
        && rm -rf /tmp/nprobe

# Last bits our housekeeping inlcuding uploading a fall-back nprobe.conf
RUN  chmod +x /usr/bin/nprobe* \
     && mkdir /etc/nprobe \
     && echo "#Default nProbe Conf\n-i=br0\n-n=none\n--zmq=tcp://*:6565\n-T=@NTOPNG@" >> /etc/nprobe/nprobe.conf  \
     && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
