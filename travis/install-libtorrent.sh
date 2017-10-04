#!/bin/bash

cd ~/deps

if [ ! -d "libtorrent-0.13.6" ]; then
  git clone https://github.com/rakshasa/libtorrent libtorrent-0.13.6
  cd libtorrent-0.13.6
  git checkout 0.13.6
fi

cd ~/deps/libtorrent-0.13.6
./autogen.sh
./configure
make
make install
