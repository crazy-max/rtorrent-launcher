#!/bin/bash

/etc/init.d/rtorrent start
timeout 180 grep -q 'rtorrent started successfully' <(tail -f /var/log/rtorrent/rtorrent-launcher.log)
/etc/init.d/rtorrent stop