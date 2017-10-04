#!/bin/bash

# xmlrpc
cd /usr/local/src/
git clone https://github.com/mirror/xmlrpc-c
cd xmlrpc-c
./configure
make
make install

# libsigc++
cd /usr/local/src/
wget http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.10/libsigc++-2.10.0.tar.xz
tar xf libsigc++-2.10.0.tar.xz
cd libsigc++-2.10.0
./configure
make
make install

# c-ares
cd /usr/local/src/
wget https://c-ares.haxx.se/download/c-ares-1.13.0.tar.gz
tar zxf c-ares-1.13.0.tar.gz
cd c-ares-1.13.0
./configure
make
make install

# curl
cd /usr/local/src/
wget https://curl.haxx.se/download/curl-7.55.1.tar.gz
tar zxf curl-7.55.1.tar.gz
cd curl-7.55.1
./configure --enable-ares
make
make install

# libtorrent
cd /usr/local/src/
git clone https://github.com/rakshasa/libtorrent.git
cd libtorrent
git checkout 0.13.6
./autogen.sh
./configure
make
make install

# rtorrent
cd /usr/local/src/
git clone https://github.com/rakshasa/rtorrent.git
cd rtorrent
git checkout 0.9.6
./autogen.sh
./configure --with-xmlrpc-c
make
make install
ldconfig