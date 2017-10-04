#!/bin/bash

cd ~/libs
git clone https://github.com/mirror/xmlrpc-c
cd xmlrpc-c/stable
ls -al
./configure
make
make install
