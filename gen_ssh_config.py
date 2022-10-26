#!/usr/bin/env python3

import subprocess
import pathlib
import os

class Host:
    def __init__(self, host, key, name=None, port=None, username=None):
        name = name or host
        port = port or 22
        username = username or 'wheybags'

        self.host = host
        self.key = key
        self.name = name
        self.port = port
        self.username = username

hosts = [
    Host('wheybags.com', 'id_sirvore_2'),
    Host('github.com', 'id_github', username='git'),
    Host('gist.github.com', 'id_github', username='git'),
    Host('gitlab.com', 'id_gitlab', username='git'),
    Host('wheybags.com', 'id_naspi', name='naspi', port=2224),
    Host('home.wheybags.com', 'id_compi', name='compi'),
    Host('192.168.1.1', 'id_compi', name='compi-local'),
    Host('100.72.40.36', 'id_compi', name='compi-tail'),
    Host('192.168.1.115', 'id_powder_ml1', name='powder-local', port=443),
    Host('31.204.81.125', 'id_powder_ml1', name='powder', port=443),
    Host('192.168.1.231', 'id_powder_ml1', name='ml2', port=22),
]


try:
    lines = subprocess.check_output(['ssh-add', '-L']).splitlines()
except subprocess.CalledProcessError:
    exit(0)

pubkeys = { x.split()[2] : x for x in lines }



homedir = str(pathlib.Path.home())

os.makedirs(homedir + '/.ssh', exist_ok=True)
for key in pubkeys:
    with open(homedir + "/.ssh/" + key.decode('UTF-8') + ".pub", "wb") as f:
        f.write(pubkeys[key])


config = []
for host in hosts:
    config.append('Host {}\n'
                  '    HostName {}\n'
                  '    User {}\n'
                  '    Port {}\n'
                  '    IdentityFile ~/.ssh/{}\n'
                  '    CheckHostIP no\n'
                  '\n'.format(host.name, host.host, host.username, host.port, host.key))

additional_config = """
Host *
    IdentitiesOnly yes
"""

with open(homedir + '/.ssh/config', 'w') as f:
    f.write(''.join(config))
    f.write(additional_config)
