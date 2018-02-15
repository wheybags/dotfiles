debian_packages="moreutils htop python-virtualenv vim sl pv build-essential cmake gdb mono-complete valgrind"
debian_packages_gui="sm dconf-cli git-gui meld gmrun"

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


if [ $[!$windows] -a $have_gui ]; then
    pushd thirdparty

    if [ ! -e pycharm ]; then
        wget "https://download-cf.jetbrains.com/python/pycharm-community-2017.3.2.tar.gz" -O pycharm.tar.gz
        tar xvf pycharm.tar.gz
        mv "pycharm-community-2017.3.2" pycharm
    fi

    if [ ! -e firefox ]; then
        wget "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-GB" -O firefox.tar.bz2
        tar xvf firefox.tar.bz2
    fi
    
    curr_plugin_ver=1
    plugin_ver=0
    if [ -f firefox_plugin_ver ]; then
        plugin_ver=`cat firefox_plugin_ver`
    fi

    if [ $plugin_ver -lt $curr_plugin_ver ]; then
        killall firefox || true
        sleep 5
        killall -9 firefox || true

        firefox/firefox -private-window "https://addons.mozilla.org/en-US/firefox/addon/adblocker-ultimate/" &
        firefox/firefox -private-window "https://addons.mozilla.org/en-US/firefox/addon/keefox/" &

        for job in `jobs -p`; do
            wait $job
        done

        printf "$curr_plugin_ver" > firefox_plugin_ver
    fi

    popd
fi
