#!/bin/sh -e
### BEGIN INIT INFO
# Provides:          rtorrent
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Rtorrent Launcher
### END INIT INFO

##################################################################################
#                                                                                #
#  Rtorrent Launcher 2.0                                                         #
#                                                                                #
#  A simple bash script to launch the rTorrent daemon                            #
#                                                                                #
#  Copyright (C) 2013-2017 Cr@zy <webmaster@crazyws.fr>                          #
#                                                                                #
#  Rtorrent Launcher is free software; you can redistribute it and/or modify     #
#  it under the terms of the GNU Lesser General Public License as published by   #
#  the Free Software Foundation, either version 3 of the License, or             #
#  (at your option) any later version.                                           #
#                                                                                #
#  Rtorrent Launcher is distributed in the hope that it will be useful,          #
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

CONFIG_FILE="/etc/rtorrent-launcher.conf"

#### No edits necessary beyond this line

log() {
  if [ `whoami` = "root" ]; then
    su - ${USER} -c "echo [`date +"%Y-%m-%d %H:%M:%S"`] $1 >> $LOGFILE 2>&1"
  else
    echo "[`date +"%Y-%m-%d %H:%M:%S"`] $1" >> ${LOGFILE} 2>&1
  fi
}

altecho() {
  echo $1 && log $1
}

get_pid() {
  PID=`cat ${RTORRENT_SESSION_DIR}/rtorrent.lock | awk -F: '{print($2)}' | sed "s/[^0-9]//g"`
}

do_start() {
  if do_status; then
    altecho "$SCREEN_NAME is already running"
    RES=1
    return
  fi

  altecho "Starting $SCREEN_NAME..."
  if [ `whoami` = "root" ]; then
    su - ${USER} -c "screen -AmdS $SCREEN_NAME $DAEMON -i $WAN_IP"
  else
    screen -AmdS ${SCREEN_NAME} ${DAEMON} -i ${WAN_IP}
  fi
  sleep 2

  if do_status; then
    altecho "$SCREEN_NAME started successfully"
    get_pid;
    if [ `whoami` = "root" ]; then
      su - ${USER} -c "echo $PID > ${RTORRENT_SESSION_DIR}/rtorrent.pid"
    else
      echo ${PID} > ${RTORRENT_SESSION_DIR}/rtorrent.pid
    fi
    RES=0
    return
  fi

  altecho "ERROR: Cannot start $SCREEN_NAME. Check your rtorrent logs."
  RES=1
}

do_stop() {
  if ! do_status; then
    altecho "$SCREEN_NAME could not be found. Probably not running."
    RES=1
    return
  fi

  altecho "Stopping $SCREEN_NAME..."
  if ! [ -s ${RTORRENT_SESSION_DIR}/rtorrent.lock ]; then
    altecho "ERROR: ${RTORRENT_SESSION_DIR}/rtorrent.lock not found"
    RES=1
    return
  fi

  get_pid;
  if [ `whoami` = "root" ]; then
    if ps -A | grep -sq ${PID}.*rtorrent; then
      su - ${USER} -c "kill -s INT ${PID}"
    fi
    tmp=$(su - ${USER} -c "screen -ls" | awk -F . "/\.$SCREEN_NAME\t/ {print $1}" | awk '{print $1}')
    su - ${USER} -c "screen -r $tmp -X quit"
  else
    if ps -A | grep -sq ${PID}.*rtorrent; then
      kill -s INT ${PID}
    fi
    screen -r $(screen -ls | awk -F . "/\.$SCREEN_NAME\t/ {print $1}" | awk '{print $1}') -X quit
  fi
  sleep 2

  if ! do_status; then
    altecho "$SCREEN_NAME stopped successfully"
    rm -f "${RTORRENT_SESSION_DIR}/rtorrent.pid"
    RES=0
    return
  fi

  altecho "ERROR: Cannot stop $SCREEN_NAME"
  RES=1
}

do_status() {
  res=""
  if [ `whoami` = "root" ]; then
    res=$(su - ${USER} -c "screen -ls" | grep [.]${SCREEN_NAME}[[:space:]])
  else
    res=$(screen -ls | grep [.]${SCREEN_NAME}[[:space:]])
  fi
  if [ -z "$res" -o ! -s "${RTORRENT_SESSION_DIR}/rtorrent.lock" ]; then
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
  
  echo "- Rtorrent config       : ${RTORRENT_CONFIG}"
  echo "- Rtorrent session dir  : ${RTORRENT_SESSION_DIR}"
  echo "- Screen name           : ${SCREEN_NAME}"
  echo "- Process ID            : ${PID}"
  echo "- Memory Usage          : ${RSS_STR}"
  echo "- Active Connections    : $(netstat --ip -anp | grep -E "Proto|${DAEMON_NAME}" | wc -l)"
}

### BEGIN ###

# Default config
USER="rtorrent"
SCREEN_NAME="rtorrent"
LOG_DIR="/var/log/rtorrent"
RTORRENT_CONFIG="/home/rtorrent/.rtorrent.rc"

# Check config file
if [ ! -f "$CONFIG_FILE" ]
then
  echo "ERROR: Config file $CONFIG_FILE not found..."
  exit 1
fi

# Load config
source "$CONFIG_FILE"
USER_HOME=$(eval echo ~${USER})

# Check required packages
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
if ! type awk > /dev/null 2>&1; then altecho "ERROR: You need awk for this script (try apt-get install awk)"; exit 1; fi
if ! type screen > /dev/null 2>&1; then altecho "ERROR: You need screen for this script (try apt-get install screen)"; exit 1; fi

# Init vars
LOGFILE="$LOG_DIR/rtorrent-launcher.log"
DAEMON_NAME="rtorrent"
DAEMON_PATH=""
RTORRENT_SESSION_DIR=""
WAN_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)

# Check current user
if [ `whoami` != "root" -a `whoami` != "$USER" ]; then
  altecho "ERROR: You need to be logged as root or $USER"
  exit 1
else
  chown -R ${USER}. "$LOG_DIR"
fi

# Create log folder
if [ ! -d "$LOG_DIR" ]; then
  mkdir -p "$LOG_DIR"
fi

# Seek rtorrent daemon
for i in `echo "$PATH" | tr ':' '\n'`
do
  if [ -x "$i/$DAEMON_NAME" ]; then
    DAEMON="$i/$DAEMON_NAME"
    break
  fi
done
if [ -z "$DAEMON" ]; then
  altecho "ERROR: Cannot find $DAEMON_NAME daemon or is not executable in PATH $PATH"
  exit 1
fi

# Check rtorrent config
if [ ! -r "$RTORRENT_CONFIG" ]; then
  altecho "ERROR: rtorrent config file does not exist or is not readable from $RTORRENT_CONFIG."
  exit 1
fi

# Seek rtorrent session dir
RTORRENT_SESSION_DIR=`cat "$RTORRENT_CONFIG" | grep "^[[:space:]]*session[[:space:]]*=" | sed "s/^[[:space:]]*session[[:space:]]*=[[:space:]]*//"`
if [ ! -d "$RTORRENT_SESSION_DIR" ]; then
  altecho "ERROR: Session directory $RTORRENT_SESSION_DIR does not exist or is not readable from $RTORRENT_CONFIG."
  exit 1
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
      altecho "$SCREEN_NAME is running (PID ${PID})"
      exit 0
    else
      altecho "$SCREEN_NAME is not running"
      exit 1
    fi
  ;;
  
  info)
    altecho "$SCREEN_NAME infos :"
    do_info
  ;;

  *)
    echo "Usage: $0 {start|stop|restart|status|info}"
    exit 1
  ;;

esac

exit ${RES}