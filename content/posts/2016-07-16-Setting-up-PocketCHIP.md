+++
title = "Setting up PocketCHIP"
tags = ["linux", "chip", "pocketchip", "howto"]
date = "2016-07-16 17:58:00"
+++

So I got a couple of these fantastic little embedded systems from Next Thing, and started to try to set one of them up how I would like to see it setup.  Basically I was looking for a web browser, SSH installed, and a few aliases to make things easy to work with.

> ***NOTE:*** All of the operations below assume a basic understanding of terminal commands!

### Updating the PocketCHIP and installing the software

To start off, the PocketCHIP OS is slightly out of date as it's currently being flashed, so the first thing we need to do is update the OS to current:

```bash
sudo apt-get update
```

Now lets go ahead and install the needed packages (Note: "\" and lines are used here for page cleanliness).

```bash
sudo apt-get install openssh-client \
                     openssh-server \
                     irssi \
                     dnsutils \
                     moc \
                     dwb
```

Next we will disable SSH from starting automatically:

```bash
sudo systemctl disable ssh
```

So now technically all of the software was installed (that was easy), but now we want to make the needed configuration changes to make everything behave how we expect it to.  I'd recommend actually doing everything from hear-on out through SSH, as you'll have the benefit of a full-size keyboard.

### Setting up the Shell Environment

with the small keyboard, it makes a lot of sense to build-in some aliases to commonly-used commands.  This will save a lot of keystrokes overall and can only improve the overall experience.  I prefer to shim into the user profile in a manner that means that I'm not constantly editing the default user profiles, as there is plenty in there that you simply don't want to touch.  To do this, we will do the following:

**Step 1:** create the profile scripts directory.  This directory will house our custom additions to the shell environment and allows us to more easily extend the shell in a safer manner.
```bash
mkdir -p ~/.profile_scripts
```

**Step 2:** using either `vi` or `nano`, we will need to append the following to the end of the `~/.bashrc` file:

```bash
# This is a shim to allow for multiple profile script to exist in the
# user home.  All of the shell scripts in ~/.profile_scripts will be
# loaded into the user environment.                                    
for SCRIPT_NAME in $(ls $HOME/.profile_scripts/*.sh);do
    source $SCRIPT_NAME                                                
done                                                                     
unset SCRIPT_NAME
```

**Step 3:** Now that the user's profile is set to load anything with a .sh extension into the profile, lets create an aliases file and input the aliases that we want to use.  Using either `vi` or `nano`, create a new file at `~/.profile_scripts/aliases.sh` and input the following into the file (and feel free to modify as you see fit):

```bash
# Enable the SSH Daemon
alias sshon="sudo systemctl start ssh"

# Disable the SSH Daemon
alias sshoff="sudo systemctl stop ssh"

# Get all associated IP Addresses
alias getip=\"ip addr | awk '/inet/ {print $2}'\""

# List all files in long format
alias ll="ls -al"

# A shortcut to grep the running processes
alias pgr="ps -ef | grep"

# Install a package
alias sagi="sudo apt-get install"

# Update the repository cache
alias sagu="sudo apt-get update"

# Upgrade the current packages installed
alias sagU="sudo apt-get upgrade"

# Search for a package
alias sags="apt-cache search"
```

**Step 4**: Now to get these changes to apply to the current shell, you simply need to `source ~/.bashrc` and it will reload the shell environment based on these new settings.

### Adding the Browser to to the Home screen

Next we will want to add the browser to the home screen so that it is easily accessible for general use.  As the PocketCHIP home screen only supports 6 icons, we will need to replace the help documentation with the browser.  To do so we will need to modify the definitions file for pocket-home to point to the browser.  Using `vi` or `nano`, open `/usr/share/pocket-home/config.json` and look for the help icon and change this definition to look like below instead:

```json
         {
          "name": "Web Browser",
          "icon": "appIcons/webbrowser.png",
          "shell": "BROWSER_EXEC"
        },
```

Once you have saved the change, we will need to bounce the pocket-home GUI by typing `sudo skill pocket-home`.  If you have made an error in the configuration, you will not see the GUI come back up and just see the PocketCHIP logo on the screen (it may take a minute or so for the GUI to show up).  If this is the case, don't fret, just re-edit the file and and bounce the application again.  This is why we are making these changes over SSH, eight ;).

### Configuring the Browser

DWB is a really decent webkit-based browser (same engine thats in chrome), however we need to make some minor configuration changes to the browser to support the low resolution of the PocketCHIP and to mimick a mobile device so that we load less resource intensive pages.  To do this we much first start DWB from the PocketCHIP (using the `dwb` command) so that it will write it's initial configuration file and then `CNTRL+X` to exit it.  Once thats done, we will open the configuration file from the SSH console and make the appropriate changes.  For brevity, I have listed the relevant changes that you will need to make in the file, simply look for each line below and modify as appropriate:

```ini
default-height=272
default-width=420
user-agent=Mozilla/5.0 (Linux; U; Android 4.0.3; en-us) AppleWebKit/999+ (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30
```

As DWB is keyboard-heavy for navigation, you may want to look at the [DWB Manual](http://portix.bitbucket.org/dwb/resources/manpage.html57) in order to get a good understanding of what to do.  I personally fine the simple cheat-sheet below enough to get by for most uses:

* CNTRL+Q - Quit
* o - Enter URL (Open)
* h - Go back
* l - Go forward
* Scrolling = Arrow keys

### Finishing up...

Now with these changes in place, go ahead and attempt to launch the browser from the home screen.  If all is well, the browser should come up and everything should look good.  A good test is to goto slashdot.org or google.com and see if the page is rendering as we should expect (no scrolling, mobile site, etc).  If everything looks good, then your done!

### Errata

I have also built a script to automate all of the actions mentioned in the above post, please see the [PocketCHIP Browser Installer Script](https://bbs.nextthing.co/t/pocketchip-browser-installer-script/4832) post for information on how to use it.