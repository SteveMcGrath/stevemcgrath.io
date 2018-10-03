+++
title = "pyTenable v0.1.0 Released"
tags = ["python", "tenable", "tenable.io", "container_security", "security_center"]
date = "2018-10-03 09:12:00"
+++

After nearly 8 months of on-and-off development (mostly off, day-job work keeps my busy), I'm proud to announce that pyTenable has hit version 0.1.0.  While this may not seem like much, it's been a lot of work to bring it across this line in the journey so far.  All of the Tenable.io Vulnerability Management API are now pythonized.  Further everything in the `tenable_io` module has been tested out (_**519 tests!**_).  Tenable has also seen fit to link to pyTenable as an official module for working with our products.

The road ahead is still long however.  The Container Security module still needs to be tested out.  The mountain of work for pythonizing SecurityCenter has yet to really kick in either.  Lots to do, and what seems like never enough time to do it ;).

Installing pyTenable is easy, you just install from pip.

```bash
pip install pytenable
```

Working with the APIs are module-specific, so you only import what you need.

```python
from tenable.tenable_io import TenableIO
import os

tio = TenableIO(
    os.getenv('TIO_ACCESS_KEYS')
    os.getenv('TIO_SECRET_KEYS'))
```

The structure of the API objects are pretty straightforward, and generally try to conform to the API docs.  For example, to interact with the `scans: list` endpoint in Tenable.io, you'd make a call using `tio.scans.list()`.  There are a few deviations, however they're noted in the documentation.

I've also tried to adhere to my own rules on commenting and documentation.  The doc-strings for each method detail inputs, outputs, and [eventually] examples.  Within the method however, I tried to tell the story of how the method works, what it's trying to do, and why.  My goal here is to make the library easy to understand, and easy to follow.  If someone wanted to build their own library in a different language, they should be able to learn from what I've done and use what's here to minimize the amount of research they need to do in order to understand the various aspects of the API.

* [pyTenable Github](https://github.com/tenable/pyTenable)
* [pyTenable ReadTheDocs Site](https://pytenable.readthedocs.io)
* [pyTenable Travis Builds](https://travis-ci.org/tenable/pyTenable)