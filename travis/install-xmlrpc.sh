#!/bin/bash

cd ~/deps

if [ ! -d "xmlrpc-69fa18a" ]; then
  git clone https://github.com/mirror/xmlrpc-c xmlrpc-69fa18a
  cd xmlrpc-69fa18a
  git reset --hard 69fa18a
fi

cd ~/deps/xmlrpc-69fa18a/stable
./configure
make
make install
