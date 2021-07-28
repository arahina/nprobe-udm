# nProbe-udm

Onboard the M.V Arahina we have a large range of network equipment including Ubiqiti UDM-Pro, Edgerouter-4 and Switches and we use Ntopng to perform netflow monitoring in addition to the DPI tools in the UDM-Pro Unifi software. 

This project builds a container with a running Ntop nProbe on the Ubiquti UDM-Pro as I found the performance overhead of runnign Ntopng on the UDM itself to much and so Ntopng is run on a seperate RPI4B server running either RPiOS or sometimes in Ubuntu inside a 6 node RPI Kubernetes cluster.  

# Installation
The UDM Pro doesn't have git installed so in the releases folder is nprobe-udm-1.0.tar.gz, copy that to your UDM Pro.  You run everything on the UDM itself in location /mnt/data_ext (you'll need a disk in UDM otherwise edit the dockerfile to be "/mnt/data").  

Simply copy the file releases/nprobe-udm-1.0.tar.gz to yor UDM Pro into /mnt/data_ext and uncompress it with tar -xvzf nprobe-udm-1.0.tar.gz and then cd to the directory nprobe-udm and run ./install-nprobe.sh

By default it deploys *two* probes, one on network interface br0 (192.168.0.0/24) named nprobe-ubm-br0 and one on network interface br50 (192.168.50.0/24) named nprobe-ubm-br50.  These are the main subnets I monitor with Ntop.  Edit the install-nprobe.sh script *not* to start an nprobe for br50.

Once installed ```podman images``` should look like this:

```
# podman images
REPOSITORY                 TAG           IMAGE ID       CREATED          SIZE                       R/O
localhost/nprobe-udm       latest        8775505907f6   13 seconds ago   186 MB                     false
docker.io/library/debian   buster-slim   9e410c2519d5   6 days ago       66.8 MB                    false
localhost/unifi-os         latest        22b86e7e778a   2 weeks ago      1.46 GB                    true
localhost/unifi-os         default       22b86e7e778a   2 weeks ago      1.46 GB                    true
localhost/unifi-os         current       bd0702c64796   2 months ago     unable to determine size   false
```
And  to view the running containers you use ```podman ps``` like this:
```
# podman ps
CONTAINER ID  IMAGE                        COMMAND     CREATED        STATUS            PORTS  NAMES
113aac517981  localhost/nprobe-udm:latest              2 minutes ago  Up 2 minutes ago         nprobe-udm-br50
4ccc793788a7  localhost/nprobe-udm:latest              2 minutes ago  Up 2 minutes ago         nprobe-udm-br0
67cfa24a2625  localhost/unifi-os:latest    /sbin/init  2 weeks ago    Up 9 days ago            unifi-os
```
# License Files
You will need to put your nprobe.license and GeoIP.conf license files in the nprobe-udm directory, preferably *before* running the install-nprobe-sh script otherwise you'll need to stop/start the container afer installation.  When the container is built, it installs support for GeoIP but you need to register and get a license file (which is free).  If you don't buy a liccense for nprobe then it will operate in demo mode.

# Running the probes
Once the installer has completed you can view the running containers with *podman ps*.  You then need to configure your Ntop installation running elsewhere to connect to the listeners on port 5557 (br0) and 5559 (br50). 

You can start and stop the containers with ```podman stop nprobe-udm-br0``` etc without continually rebuilding the images.  Run the ```uninstall-nprobe.sh``` to totally clean up and remove the containers and the nprobe image.

# Notes
My scripts aren't perfect and could be streamlined a little bit and parameterized more but everything you need to run nprobe and build the container on the UDM Pro itself is here.  This is what I run on my UDM Pro. 
