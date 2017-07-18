+++
title = "TrafficWatch"
tags = ["nodejs", "google maps"]
date = "2016-10-10 19:26:00"
+++

TrafficWatch is a simple node.js app I wrote after trying to get Ian Harmon's [traffic time-lapse-helper](https://github.com/ianharmon/traffic-time-lapse-helper) project working in Python for 30min or so on MacOS, I gave up and wrote TrafficWatch in about an hour.  There are some arguments that you can specity as well if you want look at somethign other than Chicago traffic:

* __--name / -n__ Name for the GIF in the upper-left corner
* __--url / -u__ URL String for that we will be time-lapsing
* __--interval / -i__ The time interval (in minutes)
* __--duration / -d__ The number of minutes to run
* __--gifout / -g__ The output filename for the GIF
* __--xoffset__ X Offset for the crop (0 means centered)
* __--yoffset__ Y Offset for the crop (0 means centered)
* __--font__ Font for the name and time display in the upper-left corner (default is Arial)
* __--fontsize__ Size of the text (default is 32)
* __--fontcolor__ Color of the text (default is #000000b0)
* __--directory__ Path for the individual screencaps (default is screenshots)
* __--gifdelay__ The ms delay timer for the GIF animation (default 500)

An example output would look something like this:

![example-gif](/images/chicago-traffic-example.gif)