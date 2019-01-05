+++
title = "VSCode Twilight Operator Theme"
tags = ["python", "vs-code"]
date = "2019-01-04 23:45:00"
+++

So I decided to start looking at Visual Studio Code with most of the folks I know dropping Sublime like it's a bad habit and see what all of the hubbub is about.  I will have to say that after some tweaking I've been pleasantly surprised with how well VSCode works.  It's taken a lot less tweaking to get it to a point where I'm happy with it than it ever did with Sublime Text, and it even has some really nice features out of the box for Python.

About the only thing that I wasn't overly happy about was the lack of Operator-aware themes that were available for VSCode.  My solution to this was to take one of my favorite dark themes that I have been using since TextMate 1, convert it to the VSCode format, and then make the minor changes needed to make it leverage some of the capabilities that Operator (or in my case Dank) uses to make your life an easy one.

With that, I present to you **Twilight Operator** version 0.0.1.

![](https://raw.githubusercontent.com/SteveMcGrath/twilight-operator/master/static/screenshot-python.png)

There have been only a few minor changes in terms of the colorization (namely that I like my doc-strings in the same color as my comments).  Other than that, most of the changes are focused around adding italics to things like class names, function names, keywords, etc.  The only real code changes so far post-conversion are [within a couple dozen lines of JSON][code].  It is published to the [Visual Studio Marketplace][marketplace] however, so feel free to pull it down and open a [Issue][issues] on Github if you have any suggestions for improvements.

### Update

Well I figured I'd also slap together a [iTerm color profile][iterm] that matches the VSCode Color Theme, so bonus ;)

![](https://raw.githubusercontent.com/SteveMcGrath/twilight-iterm/master/screenshot.png)

[iterm]: https://github.com/SteveMcGrath/twilight-iterm
[issues]: https://github.com/SteveMcGrath/twilight-operator/issues
[marketplace]: https://marketplace.visualstudio.com/items?itemName=stevemcgrath.twilight-operator
[code]: https://github.com/SteveMcGrath/twilight-operator/blob/master/themes/Twilight%20Operator-color-theme.json#L348-L378