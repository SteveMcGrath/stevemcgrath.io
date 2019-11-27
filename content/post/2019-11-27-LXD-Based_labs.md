+++
title = "Building a local LXD-based Lab"
tags = ["lxd", "linux", "vm"]
date = "2019-11-27 12:25:00"
+++

I often have the need to spin up a Linux host to perform some quick testing for something, and the amount of legwork and time to get a simple VM up and running is often as time-consuming as getting the software installed to interact with it.  I needed something that was quicker to get me bootstrapped, simple enough to not require me to learn a whole ton to get going, and repeatable enough for me to even write some dirty scripts to make standing something up repeatable.

With that in mind I had already converted my massive ESXi host into an Ubuntu box running LXD and started using it to stand up things quickly, however I had issue of working on things when I was away from my home lab, as I'd either have to VPN in, or stand up some cloud instance and incur the costs of that when I have plenty of perfectly usable compute time on my laptop locally.

What I settled on was building the virtual machine to run LXD within using a newer tool that Canonical had released called [Multipass][multipass].  It uses whatever default hypervisor is for the OS, which means I don't have to install yet another hypervisor in order to use it.  Secondly the VMs are lightweight, already tuned for the hypervisor, and can be launched with a single command.  Lastly the ability to provide a simple config file to inform Multipass how to pre-configure the OS meant that I can repeatedly re-build the host if I need to, satisfying my desire to not have to treat any part of this setup as a pet.

If you're on a Linux host already, then the only reason to go through the hassle of running Multipass to do this is for isolating your own system from the host running LXD.  Otherwise, just install and use the LXD service available through the [Snapcraft][snap-lxd] store.

## Setting up the Lab

### Step 1: Install a Package Manager

If you haven't already installed one of these, then you're missing out on doing things the easy way.  On MacOS, the universal standard is [Homebrew][brew].  On Windows I almost only ever heard about [Chocolatey][choco].  For Linux users, [Snap][snap] is what I generally hear about the most.

### Step 2: Install Multipass

As mentioned before, Multipass is our tool to manage the [Ubuntu][ubuntu]-based virtual machine.

* **MacOS**: `brew install multipass`
* **Windows**: `choco install multipass`
* **Linux**: `snap install multipass`

### Step 3: Install the LXD Client

For MacOS and Windows, this will install only the client.  In the case of Linux however, you'll get both the client and the backend-service.  Unless you initialize the service on Linux, it wont be in a usable state however.

* **MacOS**: `brew install lxc`
* **Windows**: `choco install lxc`
* **Linux**: `snap install lxd`

### Step 4: The Cloud-Init Config

Create a [Cloud Init][cloud-init] configuration file for Multipass to use.  Thanks to an older version of LXD being pre-installed in Ubuntu, the only way I found to reliably always get the VM loaded how I wanted was to embed everything into the `runcmd` declaration.  This means it's not as nicely laid out as I would like, however it always builds correctly, so I'll just call this a win and move on.

Copy the following yaml config and save it into `lxd_cloud_init.yaml`.  Note that ``--storage-create-loop`` and ``--storage-backend`` options will effectively create a ZFS pool of 40Gb.  While in my experiences with Multipass on MacOS has lead me to believe that the disk images are sparse images (they grow as needed), you can adjust that number down if you need to.

Also note that the password set to the LXD subsystem is **lxd-island**.  We will need this later.

```yaml
#cloud-config

# These things all need to happen in this order.  Sadly this seems to be the
# only way to get all of this to work correctly.
runcmd:
  - [sudo, apt, -y, remove, lxd, lxd-client]
  - [sudo, snap, install, lxd]
  - [sudo, lxd, init, --auto, --network-address, "[::]", --trust-password, "lxd-island", --storage-backend=zfs, --storage-create-loop=40]
  - [usermod, -aG, lxd, multipass]
```

### Step 5: Start up the VM

Depending on the containers that you'll be running (and resources that you have available), you may want to adjust the sizing of the VM you're creating.  For my purposes, I have been using 2 CPUs, 6Gb Ram, and 50Gb disk.  This will likely take a few minutes so be patient as it provisions the host.

```bash
multipass launch -c 2 -m 6G -d 50G -n lxd --cloud-init lxd_cloud_config.yaml
```

### Step 6: Link the LXC Client to the VM

Now to link the VM to your client installed locally.  This gains the ability to interact with the VM directly on your machine.  No need to remember to shell into the VM or to remote in via SSH.  We will need the IP of the VM however, so you will first need to grab that by running `multipass list` and noting the IP of (what is likely the only) the vm with the name of **lxd**.

As you can have the client talk to multiple remote LXD hosts, we will have to name this remote host in order to uniquely identify it.  For the purposes of this walk-through, I will be calling it **labbox**.

```bash
lxc remote add labbox 192.168.64.3 --accept-certificate --password "lxd-island"
```

### Step 7 (Optional): Make the VM your default remote

This last step is optional, however unless you intend on talking to a lot of other LXD hosts, I generally recommend making the local lab you just created the default LXD service when using the client.

```bash
lxc remote switch labbox
```

## Getting started with LXD

Now that you have a system setup, getting a new container up and running is really quite simple.  To spin up a container its just:

```bash
lxc launch images:ubuntu/18.04 example1
```

Decided ypu wanted a prompt on the container?

```bash
lxc exec example1 -- bash
```

Maybe you wanted to create a CentOS container next?

```bash
lxc launch images:centos/7 example2
```

What about installing SSH on the CentOS host?

```bash
lxc exec example2 -- yum -y install openssh-server
```

Want to expose the SSH service to port 2222 on the VM?

```bash
lxc config device add example2 ssh-proxy proxy listen=tcp:0.0.0.0:2222 connect=tcp:127.0.0.1:22
```

Maybe push a file into the container?

```bash
lxc file push example_file.txt example2/tmp
```

[brew]: https://brew.sh/
[choco]: https://chocolatey.org/
[lxd]: https://linuxcontainers.org/lxd/
[multipass]: https://multipass.run/
[snap]: https://snapcraft.io/
[snap-lxd]: https://snapcraft.io/lxd
[ubuntu]: https://ubuntu.com