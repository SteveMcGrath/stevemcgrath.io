+++
title = "pySecurityCenter 2.1 Release"
tags = ["python", "securitycenter", "tenable"]
date = "2015-07-15 00:21:00"
+++

I'm proud to announce the general availability for pySecurityCenter version 2.1.x accessible from PyPI immediately.  pySC 2.1 supports connectivity to SecurityCenter 5, which leverages a completely new RESTful API.  Because of this, the pySC SecurityCenter 5 support will be an evolving process.  Whats implemented today will not be changing, however many of the convenience functions that pySecurityCenter has for SecurityCenter 4.x have not been coded into the SC5 module, as enumeration for the API is still active.  Further I don't want to paint myself into a corner with SC5 support, as I expect the API to evolve a bit over time, and don't want pySC to need a lot of work to support multiple revisions of the SC5 API.

We shall see what happens over the long haul, however there is already a couple of examples on how to leverage the 5.x module in the examples section within the GutHub repository.

### To upgrade:

```bash
pip install -U pysecuritycenter
```

or download the tagged version and install manually.

### Usage:

Using pySecurityCenter with SecurityCenter 5 isn't all that different than using the SC4 classes.  Login is done independently now for a number of reasons, however.  To instantiate and login, you would do the following:

```python
from securitycenter import SecurityCenter5
sc = SecurityCenter5('HOSTNAME_GOES_HERE')
sc.login('USERNAME', 'PASSWORD')
```