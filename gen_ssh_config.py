#!/usr/bin/env python3




hosts = {
    'wheybags.com': 'id_sirvore_2',
    'github.com': 'id_github',
    'gist.github.com': 'id_github',
    '192.168.0.6': 'id_vmroot',
    'office.factorio.com': 'id_factorio'
}





import subprocess
import pathlib

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
                  '   IdentityFile ~/.ssh/{}\n'
                  '   IdentitiesOnly yes\n'
                  '\n'.format(host, hosts[host]))

with open(homedir + '/.ssh/config', 'w') as f:
    f.write(''.join(config))
