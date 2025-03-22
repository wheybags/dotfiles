debian_packages="moreutils htop python3-virtualenv vim sl pv build-essential cmake gdb valgrind apt-file tmux tig unrar-free rsync curl wget dnsutils procmail ccache clang aptitude imagemagick socat bindfs keychain"
debian_packages_gui="sm dconf-cli git-gui meld gmrun vlc k4dirstat gparted seafile-gui gnome-shell-extensions peek"

debian="false"
uname -a | grep Debian && debian="true"
uname -a | grep raspberrypi && debian="true"
uname -a | grep Ubuntu && debian="true"

if [ -e /etc/issue ]; then
    cat /etc/issue | grep Ubuntu && debian="true"
fi

windows="false"; uname -a | grep MINGW && windows="true"
wsl="false"; uname -a | grep WSL && wsl="true"


if [ "$wsl" == "false" ]; then
    debian_packages="$debian_packages locate"
else
    debian_packages="$debian_packages git-gui"
fi

if [ ! -e thirdparty ]; then
    mkdir thirdparty
fi

if [ $have_sudo -eq 0 -a "$debian" == "true" ]; then
    sudo apt install $debian_packages

    ./setup_root_mail.sh

    if [ $have_gui -eq 0 ]; then
        sudo apt install $debian_packages_gui
    fi
fi

if [ "$wsl" == "true" ]; then
    ./install-choco.sh
    reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve # bring back proper right click menu
fi

if [ "$windows" == "false" -a $have_gui -eq 0 -a "$wsl" == "false" ]; then
    pushd thirdparty

    if [ ! -e firefox ]; then
        wget "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-GB" -O firefox.tar.bz2
        tar xvf firefox.tar.bz2
    fi
    
    popd
fi
