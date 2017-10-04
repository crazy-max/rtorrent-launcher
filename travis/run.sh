#!/bin/bash

service rtorrent start
timeout 180 grep -q 'rtorrent started successfully' <(tail -f /var/log/rtorrent/rtorrent-launcher.log)
service rtorrent stop
