#!/bin/bash
set -e

mkdir -p ~/.bitcoin
if [ ! -s ~/.bitcoin/bitcoin.conf ]; then
    touch ~/.bitcoin/bitcoin.conf
    chmod 600 ~/.bitcoin/bitcoin.conf
    echo "printtoconsole=1" >> ~/.bitcoin/bitcoin.conf
fi

if [ "${1:0:1}" = '-' ]; then
	set -- bitcoind "$@"
fi

if [ "$1" = 'bitcoind' ]; then
    exec gosu bitcoin "$@"
fi

exec "$@"
