#!/bin/bash

cd ~/libs
git clone https://github.com/rakshasa/libtorrent
cd libtorrent
git checkout 0.13.6
ls -al
./autogen.sh
./configure
make
make install
