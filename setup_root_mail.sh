#!/bin/bash -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $DIR

cd thirdparty

if [ -e nullmailer_set_up ]; then
    exit 0
fi

sudo apt install nullmailer

remote_config="smtp.office365.com smtp --port=587 --auth-login --starttls --insecure --user=wheybags@outlook.com --pass="

echo -n Password: 
read -s pass
echo

sudo sh -c "echo $remote_config$pass > /etc/nullmailer/remotes"
sudo systemctl restart nullmailer

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
