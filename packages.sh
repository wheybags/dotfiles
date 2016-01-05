PACKAGES="moreutils"

OSX_PACKAGES="pyenv-virtualenv"

LINUX_PACKAGES="python-virtualenv"

unamestr=`uname`

if [ $unamestr == 'Darwin' ]; then
    echo "$PACKAGES $OSX_PACKAGES" | xargs brew install
else
    if sudo true; then
        echo "$PACKAGES $OSX_PACKAGES" | xargs sudo apt-get install
    fi
fi
