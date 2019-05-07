+++
title = "RESTfly API Library"
tags = ["python", "api"]
date = "2019-05-07 14:45:00"
+++

With all of the work thats been done with the [pyTenable] library, I reached a
point where I was using [pyTenable]'s core `APISession`, `APIEndpoint`, and
`APIIterator` classes a lot for external work.  It seemed only logical to
separate these base classes from pyTenable and wrap them up into their own
library to act as a framework for folks looking to build their own API
libraries.  The end result of this is the new Python [RESTfly] library, which is
focused on providing a basic scaffolding to make writing API libraries similar
to [pyTenable]'s easy and and effective.

I ended up taking a lot of the code as-is when moving it over, however I did
find several areas to improve upon the basic premise as well.  Some examples of
these improvements are listed below:

* **Refactored `_check` Method**: The check method used for validating inputs
    actually works really well as-is, however I didn't want to make assumptions
    on regex patterns that folks may want to use, so the new method supports
    overloading the built-in patterns and a new custom pattern dictionary to
    make extending it a bit easier.

* **Refactored `APIIterator`**: The APIIterator class leveraged a lot of private
    attributes for operation in pyTenable, over time I have been re-exposing
    those as public attributes and have been leveraging them more in various
    other code bits, so I just exposed them from the onset here.  Further you
    can now use the iterator a bit more like a list in RESTfly's variant, as you
    can call the index of the current page directly and even use the `get`
    method and define a default response of the index doesn't exist.

* **Standard Exceptions based on HTTP Standards**: I took the HTTP standard
    error codes definitions and wrapped those in exceptions...almost all of
    them.  The end result is that you'll get an exception thrown for a 4xx or
    5xx error that should match the expected type of error the API is throwing.
    Now I know that not all APIs play well here, and also allowed for this
    dictionary (which is stored in the `APISession`) to be overloaded if
    necessary.  This also means that with minimal effort, you could also wrap
    the exceptions with some additional logic (like how the APIErrors in
    [pyTenable] will attempt to pull the Request-UUID header).  This is all
    fairly easy to use and should all _just work_.

* **Improved Utilities**: There are several utilities that I keep needing over
    and over again and honestly have gotten tired of constantly re-implementing
    them.  The `dict_merge` utility to merge two dictionaries together in a nice
    recursive way.  The `trunc` utility to allow for truncation of a string with
    an included suffix (if specified) and ensure the resulting length never
    exceeds the length I specify.  Generally basic stuff, but a chore to
    re-implement over and over.

* **Vastly improved documentation**: While I have been generally quite happy
    with the documentation in [pyTenable], the private functions never needed
    the same level of detail as they were only intended to be used by the guts
    of the library.  As I expect other folks to start using these various
    methods, functions, etc. I also spent some time really beefing up the
    doc-strings and the overall detail in the docs to bring it more in-line with
    my expectations for all public code.

In the end, [pyTenable] will eventually be refactored to use [RESTfly] instead
of it's own base classes, as there isn't much of a reason to keep two
independent versions of the same code.  I'd expect that to be a further down the
line problem however, as there is a lot more work to do with [pyTenable].


[pyTenable]: https://pytenable.readthedocs.io
[RESTfly]: https://restfly.readthedocs.io