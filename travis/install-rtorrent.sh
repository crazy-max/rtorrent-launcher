#!/bin/bash

cd ~/deps

if [ ! -d "rtorrent-0.9.6" ]; then
  git clone https://github.com/rakshasa/rtorrent rtorrent-0.9.6
  cd rtorrent-0.9.6
  git checkout 0.9.6
fi

cd ~/deps/rtorrent-0.9.6
./autogen.sh
./configure --with-xmlrpc-c
make
make install
ldconfig
