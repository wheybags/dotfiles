PACKAGES="moreutils"

OSX_PACKAGES="pyenv-virtualenv"

LINUX_PACKAGES="python-virtualenv vim sl sm dconf-cli git-gui pv"

unamestr=`uname`

if [ $unamestr == 'Darwin' ]; then
    echo "$PACKAGES $OSX_PACKAGES" | xargs brew install
else
    if sudo true; then
        echo "$PACKAGES $LINUX_PACKAGES" | xargs sudo apt-get install -yy
    fi
fi
