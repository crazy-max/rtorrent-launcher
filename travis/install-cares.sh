#!/bin/bash

cd ~/deps

if [ ! -d "c-ares-1.13.0" ]; then
  wget https://c-ares.haxx.se/download/c-ares-1.13.0.tar.gz
  tar zxf c-ares-1.13.0.tar.gz
fi

cd c-ares-1.13.0
./configure
make
make install
