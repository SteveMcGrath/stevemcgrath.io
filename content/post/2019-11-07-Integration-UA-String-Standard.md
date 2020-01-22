+++
title = "Integration User-Agent String Standard Proposal"
tags = ["python", "api", "rest"]
date = "2019-11-07 12:25:00"
+++

The more integrations I write the more it becomes apparent that there is no consistency in User-Agent strings for the purposes of identification of whom is making what calls.  It's something that folks are supposed to do with making API calls, yet most folks don't even bother with it.  It creates nothing but issues when the people managing the application you're talking to doesn't inform the admins who you are or what you're doing.  It seems like a minor thing, but without it, its a black hole of API calls and no one knows how to triage who and what is making these calls.

With this said, after a bit of research on how regular web browsers construct their UA strings, what they mean, and taking things like extensibility into mind, I am proposing a UA string standard for folks to use.

```
Integration/1.0 (VENDOR; PRODUCT; Build/VERSION)
```

The format allows for more attributes to be added after the Build identifier as well should the developer desire, however the base format is quite simple:

* **VENDOR**: The vendor writing the integration (this is you, not what you're integrating to).
* **PRODUCT**: The product that is handling the integration (allows the ability to distinguish between multiple products from the same vendor)
* **VERSION**: Some sort of version identifier that allows the ability to track what versions of the integration are being used.

In short, its a good start to a UA string that allows folks to know Whom wrote the integration, what product is the integration working on behalf for, and what version of the integration is being used.  Using this as a starting point, I have implemented this format within RESTfly and pyTenable (available now).  This means that identifying who you are is a simple matter of specifying the right parameters.  For example in pyTenable, all you have to do is the following:

```python
>>> from tenable.io import TenableIO
>>> tio = TenableIO(vendor='SMC Industries', product='Fancypants', build='1.0')
>>> tio._session.headers['User-Agent']
'Integration/1.0 (SMC Industries; Fancypants; Build/1.0) pyTenable/0.3.28 (pyTenable/0.3.28; Python/3.7.3; Darwin/x86_64)'
```

Note in the last line the UA string thats being passed now has not only the Integration format, but also the information for pyTenable as well.  While I bet it's not perfect, its a huge step forward and is a simple standard to work with.

For those looking to consume this string, an easy regex to process the string is as follows:

```regex
Integration\/1\.0 \((?<vendor>[^\;]+);[\W]{0,1}(?<product>[^\;]+);[\W]{0,1}Build\/(?<version>[^\;)]+)
```

I'd like to encourage other folks to start using this standard as well.  Lets make API interactions not only easy for the developers, but easy for the administrators of applications their interacting with.