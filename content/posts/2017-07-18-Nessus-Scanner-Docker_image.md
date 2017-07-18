+++
title = "Nessus Scanner Docker Image"
tags = ["docker"]
date = "2017-07-18 08:10:00"
draft = true
+++

A lot of the Nessus Scanner docker images in Docker Hub dont appear to be properly parameterizing a lot (or in many cases, _any_) of the required inputs to really get the scanner to run and connect up in an automated fashion.  Further most of the images that I've seen out there arent cleaning up the identifying information the scanner created as part of install (such as the UUID, the master encryption key, etc.).  As a result of this, I've released my own Nessus Scanner docker image that takes a lot of this into account.  Deploying the scanner should be a simple matter of setting up a volume for the scanner data (for persistance) and then instantiating it:

```bash
docker volume create nessus_scanner_var
docker run -d -v nessus_scanner_var:/opt/nessus/var/nessus -e LINKING_KEY=${LINKING_KEY} stevemcgrath/nessus_scanner:latest
```

For more detailed information, feel free to take a look at bothe the [Docker Hub page](https://hub.docker.com/r/stevemcgrath/nessus_scanner/) and the [Github repo](https://github.com/stevemcgrath/docker-nessus_scanner).