debian_packages="moreutils htop python3-virtualenv vim sl pv build-essential cmake gdb mono-complete valgrind apt-file tmux tig unrar-free rsync curl wget dnsutils procmail ccache clang aptitude imagemagick socat"
debian_packages_gui="sm dconf-cli git-gui meld gmrun vlc k4dirstat gparted seafile-gui gnome-shell-extensions peek"

debian=1
uname -a | grep Debian && debian=0
uname -a | grep raspberrypi && debian=0
uname -a | grep Ubuntu && debian=0

if [ -e /etc/issue ]; then
    cat /etc/issue | grep Ubuntu && debian=0
fi

windows=1
uname -a | grep MINGW && windows=0

wsl=1
uname -a | grep WSL && wsl=0


if [ $[!$wsl] ]; then
    debian_packages="$debian_packages mlocate"
else
    debian_packages="$debian_packages git-gui"
fi



if [ $have_sudo -eq 0 -a $debian -eq 0 ]; then
    sudo apt install $debian_packages

    ./setup_root_mail.sh

    if [ $have_gui -eq 0 ]; then
        sudo apt install $debian_packages_gui
    fi
fi

if [ $wsl ]; then
    ./install-choco.sh
fi

if [ ! -e thirdparty ]; then
    mkdir thirdparty
fi

if [ $[!$windows] -a $have_gui -eq 0 -a $[!$wsl] ]; then
    pushd thirdparty

    if [ ! -e firefox ]; then
        wget "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-GB" -O firefox.tar.bz2
        tar xvf firefox.tar.bz2
    fi
    
    popd
fi
