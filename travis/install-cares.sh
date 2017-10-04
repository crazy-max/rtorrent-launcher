#!/bin/bash

cd ~/deps
wget https://c-ares.haxx.se/download/c-ares-1.13.0.tar.gz
tar zxf c-ares-1.13.0.tar.gz
cd c-ares-1.13.0
ls -al
./configure
make
make install
