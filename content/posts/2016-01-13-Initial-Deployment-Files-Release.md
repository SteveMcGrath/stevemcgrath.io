+++
title = "Initial Deployment Files Release"
tags = ["python", "fabric", "deployment"]
date = "2016-01-13 10:02:00"
+++

I have started working through all of the various fabric files I have and started centralizing them and cleaning them up for general consumption.  These fabric scripts cover a variety of tasks from deployment and maintenance of various products to deploying some of my code.  I will be updating the repository as needs arise, and as always am welcome to any input.

Using my fabric files is actually pretty simple, however you need to [have fabric installed on your workstation](http://www.fabfile.org/installing.html) before anything will work.

```
git clone https://github.com/SteveMcGrath/deploy.git
cd deploy
```

Now as long as your in the deploy directory, the fab command should work for deployment and management.  To get a list of the available commands, run `fab -l`

```
(fabric)tnsmbp:deployment smcgrath$ fab -l
Available commands:

    nessus.install      Installs/Updates Nessus.
    nessus.plugin_push  Pushes plugin tarball to the remote scanner.
    nessus.prep         Prepares a vanilla system for use as a Nessus scanner.
    prep.prep           Generic preparation script for CentOS/RHEL boxen.
    prep.rmate          Installs the rmate shell script into /usr/local/bin
    prep.sshkeys        Pushes the management keys to remote server.
    prep.template       Performs the needed actions to make the host templatable.
    prep.update         Updates the OS to current
    pvs.install         Installs/Updates PVS.
    pvs.prep            Prepares a vanilla system for use as a PVS sensor.
    sc.getfeed          Pulls the plugin feeds from SecurityCenter to the local box.
(fabric)tnsmbp:deployment smcgrath$
````

Before we run anything, you will need to copy the `fabfile/config.py-dist` file to `fabfile/config.py` and make the appropriate changes in this file.  Once thats done, it should be a simple matter of running the appropriate command against a host.  Note all of the output is whats being returned back from the remote system as the commands are being run, and while generally can be ignored if everything went as expected, this output can be useful when things go awry.	

````
(fabric)tnsmbp:deployment smcgrath$ fab -H scanner1.home.cugnet.net nessus.install
[scanner1.home.cugnet.net] Executing task 'nessus.install'
[scanner1.home.cugnet.net] run: rpm -qa Nessus
[scanner1.home.cugnet.net] out: Nessus-6.5.2-es6.x86_64
[scanner1.home.cugnet.net] out:
Nessus-6.5.4-es6.x86_64.rpm
[scanner1.home.cugnet.net] put: /Users/smcgrath/Dropbox/Repositories/Projects/deployment/fabfile/../packages/Nessus-6.5.4-es6.x86_64.rpm -> /tmp/Nessus.rpm
[scanner1.home.cugnet.net] run: yum -y -q install /tmp/Nessus.rpm
[scanner1.home.cugnet.net] out: Shutting down Nessus services: [  OK  ]
[scanner1.home.cugnet.net] out:
[scanner1.home.cugnet.net] out: Unpacking Nessus Core Components...
[scanner1.home.cugnet.net] out: nessusd (Nessus) 6.5.4 [build M20044] for Linux
[scanner1.home.cugnet.net] out: Copyright (C) 1998 - 2015 Tenable Network Security, Inc
[scanner1.home.cugnet.net] out:
[scanner1.home.cugnet.net] out: Processing the Nessus plugins...
[scanner1.home.cugnet.net] out:
[scanner1.home.cugnet.net] out: [##                                                ]
[scanner1.home.cugnet.net] out: [###                                               ]
[scanner1.home.cugnet.net] out: [####                                              ]
[scanner1.home.cugnet.net] out: [#####                                             ]
[scanner1.home.cugnet.net] out: [######                                            ]
[scanner1.home.cugnet.net] out: [#######                                           ]
[scanner1.home.cugnet.net] out: [########                                          ]
[scanner1.home.cugnet.net] out: [#########                                         ]
[scanner1.home.cugnet.net] out: [##########                                        ]
[scanner1.home.cugnet.net] out: [###########                                       ]
[scanner1.home.cugnet.net] out: [############                                      ]
[scanner1.home.cugnet.net] out: [#############                                     ]
[scanner1.home.cugnet.net] out: [##############                                    ]
[scanner1.home.cugnet.net] out: [###############                                   ]
[scanner1.home.cugnet.net] out: [################                                  ]
[scanner1.home.cugnet.net] out: [#################                                 ]
[scanner1.home.cugnet.net] out: [##################                                ]
[scanner1.home.cugnet.net] out: [###################                               ]
[scanner1.home.cugnet.net] out: [####################                              ]
[scanner1.home.cugnet.net] out: [#####################                             ]
[scanner1.home.cugnet.net] out: [######################                            ]
[scanner1.home.cugnet.net] out: [#######################                           ]
[scanner1.home.cugnet.net] out: [########################                          ]
[scanner1.home.cugnet.net] out: [#########################                         ]
[scanner1.home.cugnet.net] out: [##########################                        ]
[scanner1.home.cugnet.net] out: [###########################                       ]
[scanner1.home.cugnet.net] out: [############################                      ]
[scanner1.home.cugnet.net] out: [#############################                     ]
[scanner1.home.cugnet.net] out: [##############################                    ]
[scanner1.home.cugnet.net] out: [###############################                   ]
[scanner1.home.cugnet.net] out: [################################                  ]
[scanner1.home.cugnet.net] out: [#################################                 ]
[scanner1.home.cugnet.net] out: [##################################                ]
[scanner1.home.cugnet.net] out: [###################################               ]
[scanner1.home.cugnet.net] out: [####################################              ]
[scanner1.home.cugnet.net] out: [#####################################             ]
[scanner1.home.cugnet.net] out: [######################################            ]
[scanner1.home.cugnet.net] out: [#######################################           ]
[scanner1.home.cugnet.net] out: [########################################          ]
[scanner1.home.cugnet.net] out: [#########################################         ]
[scanner1.home.cugnet.net] out: [##########################################        ]
[scanner1.home.cugnet.net] out: [###########################################       ]
[scanner1.home.cugnet.net] out: [############################################      ]
[scanner1.home.cugnet.net] out: [#############################################     ]
[scanner1.home.cugnet.net] out: [##############################################    ]
[scanner1.home.cugnet.net] out: [###############################################   ]
[scanner1.home.cugnet.net] out: [################################################  ]
[scanner1.home.cugnet.net] out: [################################################  ]
[scanner1.home.cugnet.net] out: [################################################  ]
[scanner1.home.cugnet.net] out: [##################################################]
[scanner1.home.cugnet.net] out:
[scanner1.home.cugnet.net] out: All plugins loaded (472sec)
[scanner1.home.cugnet.net] out:  - You can start Nessus by typing /sbin/service nessusd start
[scanner1.home.cugnet.net] out:  - Then go to https://scanner1.home.cugnet.net:8834/ to configure your scanner
[scanner1.home.cugnet.net] out:
[scanner1.home.cugnet.net] out:

[scanner1.home.cugnet.net] run: service nessusd stop
[scanner1.home.cugnet.net] out: Shutting down Nessus servic[FAILED]
[scanner1.home.cugnet.net] out:
[scanner1.home.cugnet.net] out:

[scanner1.home.cugnet.net] run: rm -f /tmp/Nessus.rpm
[scanner1.home.cugnet.net] put: /Users/smcgrath/Dropbox/Repositories/Projects/deployment/fabfile/../tmp/all-2.0.tar.gz -> /tmp/plugins.tar.gz
[scanner1.home.cugnet.net] run: /opt/nessus/sbin/nessuscli update /tmp/plugins.tar.gz
[scanner1.home.cugnet.net] out:
[scanner1.home.cugnet.net] out:  * Update successful.  The changes will be automatically processed by Nessus.
[scanner1.home.cugnet.net] out:

[scanner1.home.cugnet.net] run: rm -f /tmp/plugins.tar.gz
[scanner1.home.cugnet.net] run: service nessusd start
[scanner1.home.cugnet.net] out: Starting Nessus services:  [  OK  ]
[scanner1.home.cugnet.net] out:
[scanner1.home.cugnet.net] out:


Done.
Disconnecting from scanner1.home.cugnet.net... done.
(fabric)tnsmbp:deployment smcgrath$
```

You can even assign _roles_, or classes of systems if you want to work on multiple machines at once.  In general, there is a lot of power with fabric to build and maintain systems centrally without any agent installed on them (unlike Chef or Puppet) and has been my primary way to manage the hosts that I have.  I know the trade-offs between agent-based solutions and agent-less ones like fabric and ansible, and I just seem to prefer agent-less.

If you would like to see more of what fabric can do, I'd highly recommend heading to the [Fabfile.org](http://fabfile.org) website. 