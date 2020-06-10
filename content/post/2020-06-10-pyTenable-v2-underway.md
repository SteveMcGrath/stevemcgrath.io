+++
title = "pyTenable version 2 under development"
tags = ["python", "tenable", "tenable.io", "tenable.sc", "tenable.ot", "nessus"]
date = "2020-06-10 14:20:00"
+++

As pyTenable starts to near it's 3rd birthday, I've started working on a
complete rewrite of the codebase.  For a number of reasons, the current v1 code
has become a monstrosity of tests, repeated code, and assumptions in the APIs
that are no longer correct.  Thats not to say that it doesn't work, or even work
well for what folks are using it for, just that code maintainability has been a
concern as of late.  My hope is that with this v2 codebase, that some of the
issues can be ironed out, and that the test suite can be brought under control
(1500+ tests as of writing!!).

To start, I'm removing all of the base connection logic from the library and
instead relying on the work I have been doing on the [RESTfly library][restfly].
Over the last year RESTfly has become my goto library to use when writing
wrappers for APIs, and there is no reason to exclude the library that started
this journey.  As RESTfly takes into account all of the lessons learned from
pyTenable, and then extends them, the overall amount of connection code is now
quite minimal (from [346 lines][pt1base] to [106 lines][pt2base]).

Also by leveraging some of the newer capabilities in RESTfly, the APIEndpoint
classes themselves become quite reusable, as they take advantage of the newer
private verb methods within RESTfly.  This would mean that even
[simple calls][pt1agdetails] can be condensed to a [single line][pt2agdetails].

For the purpose of validating the inputs provided by the caller, we will be
shying away from the olf check function and instead leverage the awesome
[Marshmallow library][marshmallow].  While our use-case is a bit opposite of the
traditional use-case that Marshmallow is used for, with minimal tinkering I've
been able to use it with some significant successes.  For example, the
annoyingly complicated [filter validation and transformation code][pt1filters]
code (which as I had to bolt onto it, regretted writing this way) has instead
been properly [broken down into the different filter formats][pt2filters].

Lastly as the Tenable.io API grew over time, the structure of the Tenable.io
package within the library proved to be quite constraining.  The new library
will properly break down the APIs into the apps within the platform.  This
should also solve for some of the method overloading that currently has to
happen.

The end result of all of this is that even on a simpler API (such as
access-groups), the overall number of lines that need to be written (including
the doc-strings) went from [363 lines][pt1ag] to [288 lines][pt2ag].

The v2 codebase is being written in a [bare branch][pt2] within the pyTenable
repository.  If you're interested in monitoring its progress, by all means take
a gander at the work being done.

[restfly]: https://restfly.readthedocs.io
[marshmallow]: https://marshmallow.readthedocs.io/en/stable/
[pt1base]: https://github.com/tenable/pyTenable/blob/master/tenable/base.py#L288-L634
[pt2base]: https://github.com/tenable/pyTenable/blob/v2/tenable/base/platform.py#L7-L113
[pt1agdetails]: https://github.com/tenable/pyTenable/blob/master/tenable/io/access_groups.py#L236-L246
[pt2agdetails]: https://github.com/tenable/pyTenable/blob/v2/tenable/io/vm/access_groups.py#L215-L224
[pt1filters]: https://github.com/tenable/pyTenable/blob/master/tenable/io/base.py#L9-L88
[pt2filters]: https://github.com/tenable/pyTenable/tree/v2/tenable/io/schemas/filters
[pt1ag]: https://github.com/tenable/pyTenable/blob/master/tenable/io/access_groups.py
[pt2ag]: https://github.com/tenable/pyTenable/blob/v2/tenable/io/vm/access_groups.py
[pt2]: https://github.com/tenable/pyTenable/tree/v2