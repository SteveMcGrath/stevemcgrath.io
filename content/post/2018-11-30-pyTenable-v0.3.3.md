+++
title = "pyTenable v0.3.3 Released"
tags = ["python", "tenable", "tenable.io", "container_security", "security_center", "pysecuritycenter", "tenable.sc", "pytenable"]
date = "2018-11-30 14:03:00"
+++

The pyTenable library has been rapidly evolving over the past few months.  The library has seen a lot of expansion and maturation over the last several weeks.  Going from version 0.1.0 at the time of last post to now 0.3.3, there has been a lot of work done to lay scaffolding for the SecurityCenter package.  SecurityCenter (recently re-branded as _**Tenable.sc**_) is as large, if not larger a project as Tenable.io was.  Further complicated by the fact that, while more mature in many regards, Tenable.sc is a much older API layout, and wasn't necessarily built for programmatic interaction into all aspects of it, so there is a lot of digging and validating that needs to happen while the various modules are being built against the public API documents.

With everything there said, there have already been leaps and bounds in terms of what has been written already within the Tenable.sc package.

* Analysis endpoint was written into multiple methods in order to make better assumptions on defaults and to reduce the overall amount of parameters that are needed to be set for each call.  This was a hard requirement for me to deprecate pySecurityCenter.
* File endpoints have been written in such a way as to be used both internally within the rest of the package, but also externally for random file uploads into Tenable.sc.
* Feed endpoints have been written to facilitate programmatically uploading feed updates into Tenable.sc and initiating feed updates outside of the primary schedule.
* Alerting endpoints were written to support programmatic CRUD of Tenable.sc alerts.
* Scans endpoints have been written to handle all of the available endpoints managing Scan Definitions.
* Scan Instance endpoints (the SC API calls the model ScanResult) have been written to handle management of scan instance functions.

Some minor changes to the Tenable.io package is as follows:

* The `workbenches.assets_with_vulns` method has been renamed to `workbenches.vuln_assets` and has been reworked to properly handle validation of the **vulnerability** filters instead of the **asset** filters.
* The `scanners.linking_key` property has been reworked into a method, which is more logical as it communicates to the API.
* The `tenable.io` package as a whole now has a battery of 530+ unit tests, covering almost all inputs and outputs.  A couple of small gaps still remain, and will be closed up before 1.0.

Some over-arching changes:

* The sub-package naming convention has changed.  `tenable.tenable_io` is now simply `tenable.io`.  This also applies to other sub-packages such as `tenable.security_center` vs. `tenable.sc` and `tenable.container_security` vs. `tenable.cs`.  The thought behind these changes is that it's early enough to make a breaking change like this, its less things to write for developers, and also allows for effectively importing based on the name of the platform your interfacing to.
* All of the documentation for the library has been in-lined into the code itself.  This means that from the library developer's perspective, its a singular point to goto when making changes.  This means that the docs are more likely to be kept up to date, and don't require all the hassle that maintaining all of those restructured text files entailed.
* Almost every method has an associated example code block.  This is something I had wanted to do form the get-go, but waited until the code-base settled into a predictable pattern.

Still on the **TODO** list:

* Finish writing the Tenable.sc package and unit test it all out.
* Rewrite the Container Security package once the v2 APIs are documented.
* Write a WAS package (likely heavily borrowing from the Tenable.io package).
* Write a Nessus package.
* Add in Python 3.7 into the testing battery.
* Get a repeatable Tenable.sc docker image setup to test against for unit testing.
* Rework a lot of the Travis-ci pipelining to support all of this additional testing.

With so much to do yet, I honestly expect this to take a good way through 2019 before I get to my 1.0 milestone.

* [pyTenable Github](https://github.com/tenable/pyTenable)
* [pyTenable ReadTheDocs Site](https://pytenable.readthedocs.io)
* [pyTenable Travis Builds](https://travis-ci.org/tenable/pyTenable)