+++
title = "Nessus Network Monitor Docker Image"
tags = ["docker"]
date = "2017-07-18 12:26:00"
+++

Considering there wasn't any Nessus Network Monitor docker images that I could find, I decided I'd create one.  Using the Nessus Scanner image as a starting point, this image should have a lot of the most common things parameterized out already.  As for sniffing traffic, I'd highly encourage you to take a look at one of the earlier posts covering Docker & packet sniffing.  Deploying the sensor should be a simple matter of setting up a volume for the sensor data (for persistence), linking it to a promiscuous interface, and then instantiating it:

```bash
docker volume create nessus_monitor_var
docker create -v nessus_monitor_var:/opt/pvs/var/pvs \
		--name=nessus_monitor \
		-e SCANNER_NAME=${SCANNER_NAME} \
		-e LINKING_KEY=${LINKING_KEY} \
		-e MONITOR_INTERFACE=eth1 \
		stevemcgrath/nessus_monitor:latest
docker network connect span nessus_monitor
docker start nessus_monitor
```

For more detailed information, feel free to take a look at both the [Docker Hub page](https://hub.docker.com/r/stevemcgrath/nessus_monitor/) and the [Github repo](https://github.com/stevemcgrath/docker-nessus_monitor).