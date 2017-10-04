#!/bin/bash

cd ~/deps
wget https://curl.haxx.se/download/curl-7.55.1.tar.gz
tar zxf curl-7.55.1.tar.gz
cd curl-7.55.1
ls -al
./configure --enable-ares
make
make install
