[![GitHub release](https://img.shields.io/github/release/crazy-max/rtorrent-launcher.svg?style=flat-square)](https://github.com/crazy-max/rtorrent-launcher/releases/latest)
[![Build Status](https://img.shields.io/travis/com/crazy-max/rtorrent-launcher/master.svg?style=flat-square)](https://travis-ci.com/crazy-max/rtorrent-launcher)
[![Code Quality](https://img.shields.io/codacy/grade/3bf2380df5a447da9a2c50b1008ffcfe.svg?style=flat-square)](https://www.codacy.com/app/crazy-max/rtorrent-launcher)
[![Become a sponsor](https://img.shields.io/badge/sponsor-crazy--max-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/crazy-max)
[![Donate Paypal](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/crazyws)

## About

Today rtorrent does not have a built-in daemon but it's [in development](https://github.com/rakshasa/rtorrent/pull/446) 👷<br />
That's why i have created this simple bash script to launch 🚀 [rtorrent](https://github.com/rakshasa/rtorrent) as a daemon 😈<br />
Tested on Debian and Ubuntu.

## Requirements

* [awk](http://en.wikipedia.org/wiki/Awk) command.
* [screen](http://linux.die.net/man/1/screen) command.

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
If you change the location of the config file, do not forget to change the path in the script file for the `CONFIG_FILE` var.

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

Path to `.rtorrent.rc` config file.<br />
Example: `RTORRENT_CONFIG="/home/rtorrent/.rtorrent.rc"`

## Usage

* **start** - Start rtorrent in a screen.
* **stop** - Stop rtorrent and close the screen loaded.
* **status** - display the status of rtorrent.
* **restart** - restart rtorrent.
* **info** - display several infos about rtorrent.

Example : `/etc/init.d/rtorrent start`

## How can I help ?

All kinds of contributions are welcome :raised_hands:! The most basic way to show your support is to star :star2: the project, or to raise issues :speech_balloon: You can also support this project by [**becoming a sponsor on GitHub**](https://github.com/sponsors/crazy-max) :clap: or by making a [Paypal donation](https://www.paypal.me/crazyws) to ensure this journey continues indefinitely! :rocket:

Thanks again for your support, it is much appreciated! :pray:

## License

LGPL. See `LICENSE` for more details.
