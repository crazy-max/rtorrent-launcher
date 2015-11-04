#!/bin/sh -e

##################################################################################
#                                                                                #
#  rTorrent Launcher 1.3                                                         #
#                                                                                #
#  Init script to manage rtorrent daemon.                                        #
#                                                                                #
#  Copyright (C) 2013-2015 Cr@zy <webmaster@crazyws.fr>                          #
#                                                                                #
#  rTorrent Launcher is free software; you can redistribute it and/or modify     #
#  it under the terms of the GNU Lesser General Public License as published by   #
#  the Free Software Foundation, either version 3 of the License, or             #
#  (at your option) any later version.                                           #
#                                                                                #
#  rTorrent Launcher is distributed in the hope that it will be useful,          #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of                #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the                  #
#  GNU Lesser General Public License for more details.                           #
#                                                                                #
#  You should have received a copy of the GNU Lesser General Public License      #
#  along with this program. If not, see http://www.gnu.org/licenses/.            #
#                                                                                #
#  Usage: ./rtorrent.sh {start|stop|restart|status|info}                         #
#    - start: start rtorrent in a screen.                                        #
#    - stop: stop rtorrent and close the screen loaded.                          #
#    - restart: restart rtorrent.                                                #
#    - status: display the status of rtorrent.                                   #
#    - info: display several infos about rtorrent.                               #
#                                                                                #
##################################################################################

### BEGIN INIT INFO
# Provides:          rtorrent
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Init script to manage rtorrent daemon
### END INIT INFO

# System user to run as (can only use one)
USER="rtorrent"

# Name of screen session, no whitespace allowed
SCRNAME="rtorrent"

# Log path
LOGPATH="/var/log/rtorrent"

#### No edits necessary beyond this line
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
LOGFILE="$LOGPATH/rtorrent-launcher.log"
NAME="rtorrent"
DAEMON=""
BASEPATH="/home/$USER"
CONFIG="$BASEPATH/.rtorrent.rc"
SESSION=""

log() {
  if [ `whoami` = "root" ]; then
    su - $USER -c "echo [`date +"%Y-%m-%d %H:%M:%S"`] $1 >> $LOGFILE 2>&1"
  else
    echo "[`date +"%Y-%m-%d %H:%M:%S"`] $1" >> $LOGFILE 2>&1
  fi
}

altecho() {
  echo $1 && log $1
}

get_pid() {
  PID=`cat ${SESSION}/rtorrent.lock | awk -F: '{print($2)}' | sed "s/[^0-9]//g"`
}

get_session() {
  SESSION=`cat "$CONFIG" | grep "^[[:space:]]*session[[:space:]]*=" | sed "s/^[[:space:]]*session[[:space:]]*=[[:space:]]*//"`
}

do_start() {
  if do_status; then
    altecho "$SCRNAME is already running"
    RES=1
    return
  fi

  altecho "Starting $SCRNAME..."
  if [ `whoami` = "root" ]; then
    su - $USER -c "screen -AmdS $SCRNAME $DAEMON"
  else
    screen -AmdS $SCRNAME $DAEMON
  fi
  sleep 2

  if do_status; then
    altecho "$SCRNAME started successfully"
    RES=0
    return
  fi

  altecho "ERROR: Cannot start $SCRNAME. Check your rtorrent logs."
  RES=1
}

do_stop() {
  if ! do_status; then
    altecho "$SCRNAME could not be found. Probably not running."
    RES=1
    return
  fi

  altecho "Stopping $SCRNAME..."
  if ! [ -s ${SESSION}/rtorrent.lock ]; then
    altecho "ERROR: ${SESSION}/rtorrent.lock not found"
    RES=1
    return
  fi

  get_pid;
  if [ `whoami` = "root" ]; then
    if ps -A | grep -sq ${PID}.*rtorrent; then
      su - $USER -c "kill -s INT ${PID}"
    fi
    tmp=$(su - $USER -c "screen -ls" | awk -F . "/\.$SCRNAME\t/ {print $1}" | awk '{print $1}')
    su - $USER -c "screen -r $tmp -X quit"
  else
    if ps -A | grep -sq ${PID}.*rtorrent; then
      kill -s INT ${PID}
    fi
    screen -r $(screen -ls | awk -F . "/\.$SCRNAME\t/ {print $1}" | awk '{print $1}') -X quit
  fi
  sleep 2

  if ! do_status; then
    altecho "$SCRNAME stopped successfully"
    RES=0
    return
  fi

  altecho "ERROR: Cannot stop $SCRNAME"
  RES=1
}

do_status() {
  res=""
  if [ `whoami` = "root" ]; then
    res=$(su - $USER -c "screen -ls" | grep [.]$SCRNAME[[:space:]])
  else
    res=$(screen -ls | grep [.]$SCRNAME[[:space:]])
  fi
  if [ -z "$res" -o ! -s "${SESSION}/rtorrent.lock" ]; then
    return 1
  fi
  return 0
}

do_info() {
  PID="N/A"
  RSS_STR="N/A"
  
  if do_status; then
    get_pid
    RSS="`ps -p ${PID} --format rss | tail -n 1 | awk '{print $1}'`"
    RSS_STR="`expr ${RSS} / 1024` Mb (${RSS} kb)"
  fi
  
  echo "- Base Path             : ${BASEPATH}"
  echo "- Config File           : ${CONFIG}"
  echo "- Screen Session Name   : ${SCRNAME}"
  echo "- Session Path          : ${SESSION}"
  echo "- Process ID            : ${PID}"
  echo "- Memory Usage          : ${RSS_STR}"
  echo "- Active Connections    : "
  netstat --ip -anp | grep -E "Proto|${NAME}"
}

if [ ! -d $LOGPATH ]; then
  mkdir -p "$LOGPATH"
fi

if [ `whoami` != "root" -a `whoami` != "$USER" ]; then
  altecho "ERROR: You need to be logged as root or $USER"
  exit 3
else
  chown -R $USER. $LOGPATH
fi

if [ ! -x `which awk` ]; then
  altecho "ERROR: You need awk for this script (try apt-get install awk)"
  exit 3
fi

if [ ! -x `which screen` ]; then
  altecho "ERROR: You need screen for this script (try apt-get install screen)"
  exit 3
fi

for i in `echo "$PATH" | tr ':' '\n'`
do
  if [ -x "$i/$NAME" ]; then
    DAEMON="$i/$NAME"
    break
  fi
done

if [ -z $DAEMON ]; then
  altecho "ERROR: Cannot find $NAME daemon or is not executable in PATH $PATH"
  exit 3
fi

if [ ! -r "${CONFIG}" ]; then
  altecho "ERROR: rtorrent config file does not exist or is not readable from ${CONFIG}."
  exit 3
else
  get_session
fi

if [ ! -d "${SESSION}" ]; then
  altecho "ERROR: Session directory ${SESSION} does not exist or is not readable from ${CONFIG}."
  exit 3
fi

RES=0
case "$1" in
  start)
    do_start
  ;;

  stop)
    do_stop
  ;;

  restart|force-reload)
    do_stop
    do_start
  ;;

  status)
    if do_status; then
      get_pid
      altecho "$SCRNAME is running (PID ${PID})"
      exit 0
    else
      altecho "$SCRNAME is not running"
      exit 1
    fi
  ;;
  
  info)
    altecho "$SCRNAME infos :"
    do_info
  ;;

  *)
    echo "Usage: $0 {start|stop|restart|status|info}"
    exit 1
  ;;

esac

exit $RES