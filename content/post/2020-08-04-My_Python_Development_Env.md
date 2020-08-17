+++
title = "My Development Setup"
tags = ["python", "macos"]
date = "2020-08-17 11:07:00"
+++

I have been asked many times over the year how I have my python development
environment setup, and while some of the tooling has changed a little over the
years, the changes have been surprisingly minor.  I figured it was about time
to document what I'm using, and how I have it all setup.

### What I Use

I have been using a Mac as my primary workstation since some time in 2004, so
I will warn that some of this tooling is fairly MacOS specific, however most of
it should be usable regardless of the operating system you're on.

* **[Visual Studio Code](https://code.visualstudio.com/)**: Over the years I
  have switched code editors many times, most recently switching from Sublime
  Text to VSCode.  I know a lot of folks like using PyCharm as well, however
  I personally found it making too many assumptions and getting in my way.
* **[iTerm2](https://iterm2.com/)**: The default Apple Terminal.app is just
  _ok_.  iTerm2 on the other-hand has tons of options to customize it to your
  heart's content and it's been my goto for many years.
* **[Git Tower](https://www.git-tower.com/)**: I know most folks just say "use
  the command-line git commands", and I can't argue that.  I just personally
  don't want to have to think about what the command is that I want to use.
  Tower is really powerful and has been my goto GUI client for git for a few
  years now.  I still need to drop into the cli every now and again, but it's
  rare.
* **[Homebrew](https://brew.sh/)**: Homebrew is the package management tool that
  almost should be installed on Macs by default in my opinion.  Almost everyone
  I talk to installs Homebrew as one of their primary basic tools, and it makes
  managing applications on MacOS just that much easier.
* **[PyEnv](https://github.com/pyenv/pyenv)**: If you ever want to work with a
  Python version other than the system-installed Python interpreter, PyEnv is
  almost a must.  It'll install almost any version of python you wish, and makes
  it trivial to switch between them once installed.
* **[VirtualEnv](https://pypi.org/project/virtualenv/)**: Similarly to PyEnv,
  virtualenv allows you to silo your Python package indexes into different
  environments.  They are lightweight, simple to setup, and easy to work with.
  A goto in any Python developer's toolbelt.
* **[bPython](https://bpython-interpreter.org/)**: I know a lot of folks like
  iPython, and I think its more popular because of it's inclusion in Jupyter.
  I've honestly preferred something lightweight myself, and have found that
  bPython seems to strike that balance when I want to work directly within the
  interpreter.  Syntax highlighting, history, tab completion, and docstring
  tooltips have made this invaluable to me while I work out something.
* **[Antigen](https://github.com/zsh-users/antigen)**: Not a Python-specific
  tool per-say, however antigen is what I use manage my ZSH shell for me.

## Setting it all up

The script example below is excepts taken from my MacOS system setup script.  I generally use this every time I setup a new Mac or rebuild my existing Mac to clean out whatever cruft may have collected from my near constant tinkering.

I do also use a solution like Dropbox or Strongsync to synchronize my dotfiles to the host.  I didn't include that here as it may negatively impact someone's setup if they just blindly copy/pasted.  I may cover that as a later post.

Some other bits I mentioned above you wont see in the script below (such as bpython) as I typically install those within the virtualenv that I'm working within.

```bash
#!/bin/bash

echo "You will need to provide your password so that we can"
echo "maintain the sudo auth tokens for the rest of the script."
echo ""
echo "This prevents having to randomly type in the sudo password"
echo "during the script's run cycle."
trap "exit" INT TERM
trap "kill 0" EXIT
sudo -v || exit $?
sleep 1
while true; do
    sleep 60
    sudo -nv
done 2>/dev/null &

clear
echo "Please verify that you are signed into the MacOS App Store.";read continue
clear

# Install X-Code CLI Tools
xcode-select --install && sleep 1
osascript                                                       \
    -e 'tell application "System Events"'                       \
    -e 'tell process "Install Command Line Developer Tools"'    \
    -e 'keystroke return'                                       \
    -e 'click button "Agree" of window "License Agreement"'     \
    -e 'end tell'                                               \
    -e 'end tell'
clear

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Install packages from homebrew
brew install            \
    mas                 \
    antigen             \
    pyenv               \
    pyenv-virtualenv

# Install Amphetamine from the App Store and then caffeinate the system so that
# it won't sleep while the rest of the script runs.
mas install 937984704
caffeinate -dims &
CAFFEINE_PID=$!

# Install casks
brew cask install       \
    visual-studio-code  \
    tower               \
    docker              \
    iterm2

# Install python versions
pyenv install 3.8.0
pyenv install 3.7.5
pyenv install 3.6.9
pyenv install 3.5.8
pyenv install 3.4.10
pyenv install 2.7.17

# Shim the current environment with pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Install the VSCode Extensions
code --install-extension eamodio.gitlens
code --install-extension magicstack.MagicPython
code --install-extension ms-python.python
code --install-extension ms-python.vscode-pylance
code --install-extension redhat.vscode-yaml
code --install-extension samuelcolvin.jinjahtml
code --install-extension stevemcgrath.twilight-operator

# Stop Caffeinating
kill ${CAFFEINE_PID}
```

My zshrc file would at its simplest look like this:

```bash
# environment variables
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export DEFAULT_USER="steve"

# python Shims
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Setup the iTerm2 shell integration
if [ -f "${HOME}/.iterm2_shell_integration.zsh" ];then
    source "${HOME}/.iterm2_shell_integration.zsh"
fi

# travis support
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

# Setup the ZSH Shell
source /usr/local/share/antigen/antigen.zsh
antigen use oh-my-zsh
antigen bundle command-not-found
antigen bundle zsh-users/zsh-syntax-highlighting
antigen theme eendroroy/nothing
antigen apply

# some simple helper functions
regex() { perl -ne "/$1/ && print \"\$1\n\"" }
it2prof() { echo -e "\033]50;SetProfile=$1\a" }
iterm2_print_user_vars() {
    iterm2_set_user_var pyenv $(pyenv version-name)
    iterm2_set_user_var pythonVersion $(python --version 2>&1 | cut -d " " -f 2)
}
alias docker-mac-stop="test -z \"$(docker ps -q 2>/dev/null)\" && osascript -e 'quit app \"Docker\"'"
alias docker-mac-start="open --background -a Docker"
```