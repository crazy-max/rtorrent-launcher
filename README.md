# rTorrent Launcher

A simple script to launch rTorrent.
Tested on Debian and Ubuntu.

## Installation

Before running the script, you must change some variables.

* **SCREEN_NAME** - The screen name, you can put what you want but it must be unique and must contain only alphanumeric character.
* **USER** - Name of the user who started rTorrent.
* **CONFIG** - Path to rTorrent configuration file (.rtorrent.rc).
* **LOG** - Path to rtorrent-launcher log file.

## Usage

For the view mod, press CTRL+A then D to stop the screen without stopping rTorrent.

* **start** - Start rTorrent in a screen.
* **stop** - Stop rTorrent and close the screen loaded.
* **status** - Display the status of rTorrent (screen down or up)
* **restart** - Restart rTorrent (stop && start)
* **view** - Open rTorrent.

## License

LGPL. See ``LICENSE`` for more details.