#!/bin/bash

cd ~/libs
wget http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.10/libsigc++-2.10.0.tar.xz
tar xf libsigc++-2.10.0.tar.xz
cd libsigc++-2.10.0
ls -al
./configure
make
make install
