+++
title = "Docker Containers & Network Sniffing"
tags = ["docker"]
date = "2017-07-14 17:15:00"
+++

With all of the materials out there on the web revolving around docker containers, I thought that getting some sort of a docker network that containers could promiscuously sniff would have been a relatively easy thing to find.  I was shocked to find out that, not only was this not the case, but that the general consensus was that you need to use either Docker's host networking (which means that these containers can't exist in other network namespaces), use passthrough networking (which unless you have hardware that support SR-IOV, your out of luck), or that you resort to some serious host hacking to get the interface into the container.  I figured there had to be a more elegant solution, and after quite some time of on-and-off looking around for different solutions I had the sudden realization that I was approaching the problem from the wrong angle.  Instead of trying to get docker to bend to my use case, I needed to focus on the network bridging itself.  Now with a new focus, finding the solution only took an hour or two, ended up being extremely elegant, and is very survivable.  Further, as I don't need any weird hackery, none of the containers sniffing the network need privileged access, so no need to worry about special needs containers.

As a basis for what I'm doing here, I have an Ubuntu 16.04 host running Docker CE and it has a few network interfaces:

* **ens160** - Server VLAN traffic
* **ens192** - Mirrored traffic from the Cisco switch

The first step in this little adventure is to download the [mirroring script](https://github.com/SteveMcGrath/mirror_tools) and install it onto the host.  While the method below is quick & dirty, remember to always validate what your downloading to your systems.

```bash
wget -O /usr/bin/tc-mirror https://raw.githubusercontent.com/SteveMcGrath/mirror_tools/master/tc-mirror.sh
chmod 755 /usr/bin/tc-mirror
```

Now the goal here is to push the mirrored traffic from ens192 into a docker network.  To start, we will want to create a bridge on the host which I will call _span0_.  The _/etc/network/interfaces_ configuration for this bridge looks like so:

```
auto span0
iface span0 inet manual
        bridge_stp off
        bridge_fd 0
        bridge_maxwait 0
        bridge_ageing 0
        post-up /usr/bin/tc-mirror build enp3s0 span0
        pre-down /usr/sbin/tc-mirror teardown enp3s0
```

I want to point out something here, specifically the **bridge_ageing 0** line.  This single parameter is telling the Linux kernel to disable _MAC address learning_ capability that normally comes built-in on every linux bridge.  Without this capability turned on, we have effectively disabled the MAC learning table, which is the heart of the switching capability within the bridge.  The bridge itself is now effectively a simple packet forwarder to all of the interfaces attached to the bridge, which is what we want in this case.  Now to restart the networking on the Ubuntu host to inform it to bring up the new interface (and to auto-build the bridge at boot from now on)

```bash
systemctl restart networking
```

Everything is all plumbed up now!  The next step is to create the docker network and tell docker to use the existing bridge that we have already created instead of building a new one.  We also want to make sure that we inform docker this this is not a network we want to route with, so we mark it as "internal" only.

```bash
docker network create -d bridge --internal -o com.docker.network.bridge.name=span0 span
```
``
Now if we want to test this, we can build a really simple ubuntu docker container and install tcpdump within it:

```bash
docker run -it --rm --name=spantest ubuntu:16.04 /bin/bash
```

Once the container drops you into a shell:

```bash
apt update && apt -y install tcpdump
```

Now that tcpdump is installed, lets go ahead and add the span network to the container in another window:

```bash
docker network connect span spantest
```

Lets go ahead and start tcpdump!

```bash
tcpdump -i eth1
```

If all went well, you should now see all of the mirrored traffic on the container.  No elevated privileges or hackery, just a regular old container.  Secondly this allows for multiple containers to be attached to the same single mirror, allowing for multiple tools to get the same data (which is a requirement in my case for Dofler).

It really is that simple & elegant.  I can only imagine the doors this opens up for folks, especially in the network security community with things such as snort, suricata, bro, and even Tenable's own Nessus Network Monitor.