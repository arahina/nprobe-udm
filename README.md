This project builds a container with a running Ntop nProbe on the Ubiquti UDM-Pro.  

You run everything on the UDM itself in location /mnt/data_ext (you'll need a disk in UDM).  Simply copy the file nprobe-udm-1.0.tar.gz to yor UDM Pro into /mnt/data_ext and uncompress it with tar -xvzf nprobe-udm-1.0.tar.gz and then cd to nprobe-udm and run ./install-nprobe.sh

By default it deploys two probes, one on network interface br0 (192.168.0.0/24) and one on network interface br50 (192.168.50.0/24).  These are the main networks I monitor with Ntop.  Edit the install script not to start an nprobe for br50.

Once the installer has completed you can view the running containers with "podman ps".  You then need to configure your Ntop installation runnign elsewhere to connect to the listeners on port 5557 (br0) and 5559 (br50). 
