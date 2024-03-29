#!/bin/bash -ex

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $DIR

mkdir -p thirdparty
cd thirdparty

installed="true"
grep -q "NULLMAILER FORCE FROM SCRIPT" /usr/sbin/sendmail || installed="false"
if [ "$installed" == "true" ]; then
    exit 0
fi

sudo apt install nullmailer

if [ ! -e ~/dotfiles/config/sendmail_done ]; then
    remote_config="smtp.office365.com smtp --port=587 --auth-login --starttls --insecure --user=wheybags@outlook.com --pass="

    echo -n "Password for sendmail override:" 
    read -s pass
    echo

    sudo sh -c "echo $remote_config$pass > /etc/nullmailer/remotes"
    touch ~/dotfiles/config/sendmail_done
fi
sudo service nullmailer restart

if [ ! -e nullmailer-from-patch ]; then 
    git clone https://github.com/wheybags/nullmailer-from-patch.git
fi

pushd nullmailer-from-patch

git pull
echo "FROM=wheybags@outlook.com" > config
echo "TO=wheybags@wheybags.com" >> config

sudo ./manage.sh install

popd

echo nullmailer set up | sendmail
touch nullmailer_set_up
