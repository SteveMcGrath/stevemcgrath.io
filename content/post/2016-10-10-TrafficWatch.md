+++
title = "TrafficWatch"
tags = ["nodejs", "google maps"]
date = "2016-10-10 19:26:00"
+++

TrafficWatch is a simple node.js app I wrote after trying to get Ian Harmon's [traffic time-lapse-helper](https://github.com/ianharmon/traffic-time-lapse-helper) project working in Python for 30min or so on MacOS, I gave up and wrote TrafficWatch in about an hour.  There are some arguments that you can specity as well if you want look at somethign other than Chicago traffic:

* **--name / -n** Name for the GIF in the upper-left corner
* **--url / -u** URL String for that we will be time-lapsing
* **--interval / -i** The time interval (in minutes)
* **--duration / -d** The number of minutes to run
* **--gifout / -g** The output filename for the GIF
* **--xoffset** X Offset for the crop (0 means centered)
* **--yoffset** Y Offset for the crop (0 means centered)
* **--font** Font for the name and time display in the upper-left corner (default is Arial)
* **--fontsize** Size of the text (default is 32)
* **--fontcolor** Color of the text (default is #000000b0)
* **--directory** Path for the individual screencaps (default is screenshots)
* **--gifdelay** The ms delay timer for the GIF animation (default 500)

An example output would look something like this:

![example-gif](/images/chicago-traffic-example.gif)