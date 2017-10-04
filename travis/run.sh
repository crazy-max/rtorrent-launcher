#!/bin/bash

/etc/init.d/rtorrent start
timeout 180 grep -q 'rtorrent started successfully' <(tail -f /var/log/rtorrent/rtorrent-launcher.log)
timeout 180 grep -q 'worker_rtorrent: Starting thread.' <(tail -f /var/log/rtorrent/rtorrent.log)
/etc/init.d/rtorrent stop
