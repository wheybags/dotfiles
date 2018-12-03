debian_packages="moreutils htop python-virtualenv vim sl pv build-essential cmake gdb mono-complete valgrind apt-file tmux tig mlocate unrar-free rsync curl wget dnsutils"
debian_packages_gui="sm dconf-cli git-gui meld gmrun vlc k4dirstat gparted"

debian=1
uname -a | grep Debian && debian=0
uname -a | grep raspberrypi && debian=0

windows=1
uname -a | grep MINGW && windows=0



if [ $have_sudo -eq 0 -a $debian -eq 0 ]; then
    sudo apt install $debian_packages

    ./setup_root_mail.sh

    if [ $have_gui -eq 0 ]; then
        sudo apt install $debian_packages_gui
    fi
fi

if [ ! -e thirdparty ]; then
    mkdir thirdparty
fi

if [ $[!$windows] -a $have_gui -eq 0 ]; then
    pushd thirdparty

    if [ $have_sudo -a $debian ]; then
        curr_peek_ver=103010
        peek_ver=0
        if [ -f peek_ver ]; then
            peek_ver=`cat peek_ver`
        fi
        if [ $peek_ver -lt $curr_peek_ver ]; then
            if [ -e peek ]; then
                 rm -rf peek 
            fi

            sudo apt install valac libgtk-3-dev libkeybinder-3.0-dev libxml2-utils gettext txt2man

            git clone https://github.com/phw/peek.git
            cd peek
            git checkout 1.3.1
            
            mkdir build
            cd build
            cmake -DCMAKE_INSTALL_PREFIX=/usr -DGSETTINGS_COMPILE=OFF ..
            make package

            sudo apt install ./peek-*-Linux.deb

            cd ../..
            printf "$curr_peek_ver" > peek_ver
        fi
    fi

    if [ ! -e pycharm ]; then
        wget "https://download-cf.jetbrains.com/python/pycharm-community-2017.3.2.tar.gz" -O pycharm.tar.gz
        tar xvf pycharm.tar.gz
        mv "pycharm-community-2017.3.2" pycharm
    fi

    if [ ! -e firefox ]; then
        wget "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-GB" -O firefox.tar.bz2
        tar xvf firefox.tar.bz2
    fi
    
    curr_plugin_ver=2
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
        firefox/firefox -private-window "https://addons.mozilla.org/en-US/firefox/addon/tree-style-tab/" &

        for job in `jobs -p`; do
            wait $job
        done

        printf "$curr_plugin_ver" > firefox_plugin_ver
    fi

    curr_qt_ver=408000
    qt_ver=0
    if [ -f qt_ver ]; then
        qt_ver=`cat qt_ver`
    fi

    if [ $qt_ver -lt $curr_qt_ver ]; then

        if [ -e qtcreator ]; then
            rm -rf qtcreator
        fi

        wget "https://download.qt.io/development_releases/qtcreator/4.8/4.8.0-beta1/qt-creator-opensource-linux-x86_64-4.8.0-beta1.run" -O qtcreator.run
        chmod +x qtcreator.run
        ./qtcreator.run --script ../qtcreator-install-script.qs

        printf "$curr_qt_ver" > qt_ver
    fi

    curr_zb_ver=170
    zb_ver=0
    if [ -f zb_ver ]; then
        zb_ver=`cat zb_ver`
    fi

    if [ $zb_ver -lt $curr_zb_ver ]; then

        if [ -e zbstudio ]; then
            rm -rf zbstudio
        fi

        wget "https://github.com/pkulchenko/ZeroBraneStudio/archive/1.70.tar.gz" -O zbstudio.tar.gz
        tar xvf zbstudio.tar.gz
        mv "ZeroBraneStudio-1.70" zbstudio 

        printf "$curr_zb_ver" > zb_ver
    fi


    popd
fi
