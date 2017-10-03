<a href="https://github.com/crazy-max/rtorrent-launcher/releases/latest"><img src="https://img.shields.io/github/release/crazy-max/rtorrent-launcher.svg?style=flat-square" alt="GitHub release"></a> 
<a href="https://www.codacy.com/app/crazy-max/csgo-server-launcher"><img src="https://img.shields.io/codacy/grade/3bf2380df5a447da9a2c50b1008ffcfe.svg?style=flat-square" alt="Code Quality"></a> 
<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=P7PRCWM6MRXD8"><img src="https://img.shields.io/badge/donate-paypal-blue.svg?style=flat-square" alt="Donate Paypal"></a> 
<a href="https://flattr.com/submit/auto?user_id=crazymax&url=https://github.com/crazy-max/rtorrent-launcher"><img src="https://img.shields.io/badge/flattr-this-green.svg?style=flat-square" alt="Flattr this!"></a>

## About

A simple bash script to launch the [rtorrent](https://github.com/rakshasa/rtorrent) daemon.<br />
Tested on Debian and Ubuntu.

## Requirements

* [awk](http://en.wikipedia.org/wiki/Awk) is required.
* [screen](http://linux.die.net/man/1/screen) is required.

## Installation

Perform the following commands to download and install the script :

```
$ cd /etc/init.d/
$ wget https://raw.github.com/crazy-max/rtorrent-launcher/master/rtorrent-launcher.conf -O /etc/rtorrent-launcher.conf --no-check-certificate
$ wget https://raw.github.com/crazy-max/rtorrent-launcher/master/rtorrent-launcher.sh -O rtorrent --no-check-certificate
$ chmod +x rtorrent
$ update-rc.d -f rtorrent remove
$ update-rc.d rtorrent defaults
$ update-rc.d rtorrent enable
```

## Configuration

Before running the script, you must change some vars in the config file `/etc/rtorrent-launcher.conf`.<br />
If you change the location of the config file, do not forget to change the path in the csgo-server-launcher script file for the `CONFIG_FILE`.

#### USER

Name of the linux user who starts rtorrent.<br />
Example: `USER="rtorrent"`

#### SCREEN_NAME

The screen name, you can put what you want but it must be unique and must contain only alphanumeric character.<br />
Example: `SCREEN_NAME="rtorrent"`

#### LOG_DIR

Directory of rtorrent launcher logs.<br />
Example: `LOG_DIR="/var/log/rtorrent"`

#### RTORRENT_CONFIG

Path the `.rtorrent.rc` config file.<br />
Example: `RTORRENT_CONFIG="/home/rtorrent/.rtorrent.rc"`

## Usage

* **start** - Start rtorrent in a screen.
* **stop** - Stop rtorrent and close the screen loaded.
* **status** - display the status of rtorrent.
* **restart** - restart rtorrent.
* **info** - display several infos about rtorrent.

Example : `/etc/init.d/rtorrent start`

## License

LGPL. See `LICENSE` for more details.