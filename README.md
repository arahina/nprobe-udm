# nProbe-udm

Onboard the M.V Arahina we have a large range of network equipment including Ubiquiti UDM-Pro, Edgerouter-4 and Switches and we use Ntopng to perform netflow monitoring to support the DPI tools built into the UDM-Pro Unifi software.  

This project was inspired by thr awesome Github project https://github.com/tusc/ntopng-udm for deploying Ntopng into a container on the UDM Pro. This project is similar but builds a podman container with a running nProbe inside its own container on the Ubiquti UDM-Pro as I found the performance overhead of running Ntopng on the UDM itself to much and so Ntopng is run on a seperate RPI4B server running RPiOS.  I also prefer running the Pro versions of Ntopng and nprobe as the extra functionlity is worth it ie purchase licenses ;-).  

**Although note to Ntop**:  Don't be stingy, include licenses for all nprobe plugins for the pro-embedded versions of nprobe since you stopped selling them standalone! 

## Preparation
The UDM Pro doesn't have git installed so in the github releases folder there is a compressed archive file to use ```nprobe-udm-1.0.tar.gz```
Copy that file to your UDM Pro with scp (```scp nprobe-udm-1.0.tar.gz root@192.168.1.1:/mnt/data_ext/```).  
You run everything on the UDM itself in the location ```/mnt/data_ext/nprobe-udm``` . 

For /mnt/data_ext to be there you'll need an external disk in your UDM-Pro otherwise edit the dockerfile and install script to be "/mnt/data" whereever you see ```/mnt/data_ext/...```  

## IMPORTANT:  
The Dockerfile fetches the UDM-Pro package from the URL https://packages.ntop.org/Ubiquity/UDMPro/nprobe_9.5.210322-7188_arm64.deb
This URL will likely go out of date and disappear soon enough as ntop.org don't keep old versions online and I'm yet to add a HTML scraper to get the URL for the latest file.  But for now the package .deb file ```nprobe_9.5.210322-7188_arm64.deb``` is hard-coded in the Dockerfile.  Edit it if you need to.  

## Installation

So, to install simply scp the file ```nprobe-udm-1.0.tar.gz``` to yor UDM Pro into ```/mnt/data_ext``` and uncompress it with ```tar -xvzf nprobe-udm-1.0.tar.gz``` and then cd to the directory ```nprobe-udm``` and run ```./install-nprobe.sh```.  Everything should then just work assuming your Ntopng collector is configured correctly for these nprobe instances.

By default the ```install-nprobe.sh``` script deploys *two* probes, one on network interface br0 (192.168.0.0/24) named nprobe-ubm-br0 and one on network interface br50 (192.168.50.0/24) named nprobe-ubm-br50.  These are the main subnets I monitor with Ntop.  Edit the install-nprobe.sh script *not* to start an nprobe for br50 or to modify it for your needs.

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
## License Files
You will need to put your ```nprobe.license``` and ```GeoIP.conf``` license files in the ```nprobe-udm``` directory, preferably *before* running the ```install-nprobe-sh``` script otherwise you'll need to stop/start the container after installation.  

If you don't buy a license for nprobe then it will operate in demo mode but support the cause, it isn't that expensive to buya licence considering all the money you've splashed on your Ubiquiti equipment

When the container is built, it installs nprobe support for GeoIP but you need to register and get a license file (which is free - see https://github.com/ntop/ntopng/blob/dev/doc/README.geolocation.md#using-geolocation-in-ntopng).  

## Running the probes
Once the installer has completed you can view the running containers with *podman ps*.  You then need to configure your Ntop installation running elsewhere to connect to the listeners on port 5557 (br0) and 5559 (br50). 

You can start and stop the containers with ```podman stop nprobe-udm-br0``` etc without continually rebuilding the images.  Run the ```uninstall-nprobe.sh``` to totally clean up and remove the containers and the nprobe image.

## Notes
My scripts aren't perfect and could be streamlined a little bit and parameterized more but everything you need to run nprobe and build the container on the UDM Pro itself is here.  This is what I run on my UDM Pro. 
