#!/bin/bash

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -d env ]; then
    virtualenv env
    source env/bin/activate
    pip install thefuck
    deactivate
fi

source env/bin/activate
