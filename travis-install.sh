#!/bin/bash

# xmlrpc
cd ~
git clone https://github.com/mirror/xmlrpc-c
cd xmlrpc-c
ls -al
./configure
make
make install

# libsigc++
cd ~
wget http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.10/libsigc++-2.10.0.tar.xz
tar xf libsigc++-2.10.0.tar.xz
cd libsigc++-2.10.0
ls -al
./configure
make
make install

# c-ares
cd ~
wget https://c-ares.haxx.se/download/c-ares-1.13.0.tar.gz
tar zxf c-ares-1.13.0.tar.gz
cd c-ares-1.13.0
ls -al
./configure
make
make install

# curl
cd ~
wget https://curl.haxx.se/download/curl-7.55.1.tar.gz
tar zxf curl-7.55.1.tar.gz
cd curl-7.55.1
ls -al
./configure --enable-ares
make
make install

# libtorrent
cd ~
git clone https://github.com/rakshasa/libtorrent
cd libtorrent
git checkout 0.13.6
ls -al
./autogen.sh
./configure
make
make install

# rtorrent
cd ~
git clone https://github.com/rakshasa/rtorrent
cd rtorrent
git checkout 0.9.6
./autogen.sh
./configure --with-xmlrpc-c
make
make install
ldconfig
