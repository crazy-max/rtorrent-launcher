#!/bin/bash

cd ~/libs
git clone https://github.com/rakshasa/rtorrent
cd rtorrent
git checkout 0.9.6
./autogen.sh
./configure --with-xmlrpc-c
make
make install
ldconfig
