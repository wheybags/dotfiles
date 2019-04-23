#!/usr/bin/env python3

import subprocess
import pathlib

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
    Host('wheybags.com', 'id_factorio_desktop', name='office', port=2223),
    Host('github.com', 'id_github', username='git'),
    Host('gist.github.com', 'id_github', username='git'),
    Host('gitlab.com', 'id_gitlab', username='git'),
    Host('192.168.0.6', 'id_vmroot', name='vmroot'),
    Host('192.168.0.3', 'id_naspi', name='naspi-local'),
    Host('wheybags.com', 'id_naspi', name='naspi', port=2224),
    Host('office.factorio.com', 'id_factorio', name='jenkins', port=2222),
    Host('10.0.0.11', 'tank', name='tank', username='deploy'),
    Host('forums.factorio.com', 'lua_docs_upload', username='deploy'),
    Host('eu1.factorio.com', 'release_server_key', username='deploy')
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
