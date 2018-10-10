#!/usr/bin/env python3

import subprocess
import pathlib

class Host:
    def __init__(self, host, key, name=None, port=None):
        name = name or host
        port = port or 22

        self.host = host
        self.key = key
        self.name = name
        self.port = port

hosts = [
    Host('wheybags.com', 'id_sirvore_2'),
    Host('wheybags.com', 'id_factorio_desktop', 'office', 2223),
    Host('github.com', 'id_github'),
    Host('gist.github.com', 'id_github'),
    Host('gitlab.com', 'id_gitlab'),
    Host('192.168.0.6', 'id_vmroot', 'vmroot'),
    Host('192.168.0.3', 'id_naspi', 'naspi-local'),
    Host('wheybags.com', 'id_naspi', 'naspi', 2224),
    Host('office.factorio.com', 'id_factorio', 'jenkins', 2222)
]


try:
    lines = subprocess.check_output(['ssh-add', '-L']).splitlines()
except subprocess.CalledProcessError:
    exit(0)

pubkeys = { x.split()[2] : x for x in lines }



homedir = str(pathlib.Path.home())

for key in pubkeys:
    with open(homedir + "/.ssh/" + key.decode('UTF-8') + ".pub", "wb") as f:
        f.write(pubkeys[key])


config = []
for host in hosts:
    config.append('Host {}\n'
                  '    HostName {}\n'
                  '    Port {}\n'
                  '    IdentityFile ~/.ssh/{}\n'
                  '    IdentitiesOnly yes\n'
                  '\n'.format(host.name, host.host, host.port, host.key))

with open(homedir + '/.ssh/config', 'w') as f:
    f.write(''.join(config))
