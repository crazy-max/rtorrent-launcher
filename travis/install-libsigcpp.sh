#!/bin/bash

cd ~/deps

if [ ! -d "libsigc++-2.10.0" ]; then
  wget http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.10/libsigc++-2.10.0.tar.xz
  tar xf libsigc++-2.10.0.tar.xz
fi

cd libsigc++-2.10.0
./configure
make
make install
