#!/bin/bash

cd ~/deps

if [ ! -d "curl-7.55.1" ]; then
  wget https://curl.haxx.se/download/curl-7.55.1.tar.gz
  tar zxf curl-7.55.1.tar.gz
fi

cd curl-7.55.1
./configure --enable-ares
make
make install
