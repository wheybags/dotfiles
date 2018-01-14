debian_packages="moreutils htop python-virtualenv vim sl pv build-essential cmake gdb"
debian_packages_gui="sm dconf-cli git-gui meld"

debian=1
uname -a | grep Debian && debian=0

windows=1
uname -a | grep MINGW && windows=0

if [ $have_sudo -a $debian ]; then
    sudo apt install $debian_packages

    if [ $have_gui ]; then
        sudo apt install $debian_packages_gui
    fi
fi

if [ ! -e thirdparty ]; then
    mkdir thirdparty
fi

echo "WINDOWS $windows"


if [ $[!$windows] -a $have_gui ]; then
    pushd thirdparty

    echo "AAAAAA"
    
    if [ ! -e pycharm ]; then
        wget "https://download-cf.jetbrains.com/python/pycharm-community-2017.3.2.tar.gz" -O pycharm.tar.gz
        tar xvf pycharm.tar.gz
        mv "pycharm-community-2017.3.2" pycharm
        pycharm/bin/pycharm.sh # start once to prompt for launcher script creation
    fi

    popd
fi
