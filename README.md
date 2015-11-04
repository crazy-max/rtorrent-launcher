# rTorrent Launcher

Init script to manage rtorrent daemon.
Tested on Debian and Ubuntu.

## Requirements

* [awk](http://en.wikipedia.org/wiki/Awk) is required.
* [screen](http://linux.die.net/man/1/screen) is required.

## Installation

Execute the following commands to download and install the script :
```console
$ cd /etc/init.d/
$ wget https://raw.github.com/crazy-max/rtorrent-launcher/master/rtorrent -O rtorrent --no-check-certificate
$ chmod +x rtorrent
$ update-rc.d -f rtorrent remove
$ update-rc.d rtorrent defaults
$ update-rc.d rtorrent enable
```

Before running the script, you must change some vars :

* **USER** - Name of the user who starts rtorrent.
* **SCRNAME** - The screen name, you can put what you want but it must be unique and must contain only alphanumeric character.
* **LOG** - Path to rtorrent-launcher log file.

## Usage

* **start** - Start rtorrent in a screen.
* **stop** - Stop rtorrent and close the screen loaded.
* **status** - display the status of rtorrent.
* **restart** - restart rtorrent.
* **info** - display several infos about rtorrent.

## License

LGPL. See ``LICENSE`` for more details.