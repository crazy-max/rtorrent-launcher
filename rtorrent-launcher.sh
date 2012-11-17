#! /bin/bash

##################################################################################
#                                                                                #
#  rTorrent Launcher                                                             #
#                                                                                #
#  Author: Cr@zy                                                                 #
#  Contact: http://www.crazyws.fr                                                #
#  GitHub: https://github.com/crazy-max/rtorrent-launcher                        #
#                                                                                #
#  This program is free software: you can redistribute it and/or modify it       #
#  under the terms of the GNU General Public License as published by the Free    #
#  Software Foundation, either version 3 of the License, or (at your option)     #
#  any later version.                                                            #
#                                                                                #
#  This program is distributed in the hope that it will be useful, but WITHOUT   #
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS #
#  FOR A PARTICULAR PURPOSE. See the GNU General Public License for more         #
#  details.                                                                      #
#                                                                                #
#  You should have received a copy of the GNU General Public License along       #
#  with this program.  If not, see http://www.gnu.org/licenses/.                 #
#                                                                                #
#  Usage: ./rtorrent-launcher.sh {start|stop|status|restart|view}                #
#    - start: start rTorrent  in a screen.                                       #
#    - stop: stop rTorrent and close the screen loaded.                          #
#    - status: display the status of rTorrent (down or up).                      #
#    - restart: restart rTorrent (stop && start).                                #
#    - view: open rTorrent.                                                      #
#     To exit the view mod without stopping the program, press CTRL + A then D.  #
#                                                                                #
##################################################################################

SCREEN_NAME="rTorrent"
USER="rtorrent"

CONFIG="/home/rtorrent/.rtorrent.rc"
LOG="/var/log/rtorrent/rtorrent-launcher.log"

# Do not change this path
PATH=/usr/bin:/usr/local/bin:/usr/local/sbin:/sbin:/bin:/usr/sbin

# No edits necessary beyond this line
DAEMON="rtorrent"
EXEC_FOUND=0
SESSION=""

function dirsession {
  SESSION=`cat "$1" | grep "^[[:space:]]*session[[:space:]]*=" | sed "s/^[[:space:]]*session[[:space:]]*=[[:space:]]*//" `
  echo $SESSION
}

function echolog {
  echo "[`date +"%Y-%m-%d %H:%M:%S"`] $1" | tee -a "$LOG" >&2
}

if [ ! -x `which awk` ]
then
  echolog "ERROR: You need awk for this script (try apt-get install awk)"
  exit 3
fi

if [ ! -x `which screen` ]
then
  echolog "ERROR: You need screen for this script (try apt-get install screen)"
  exit 3
fi

for i in `echo "$PATH" | tr ':' '\n'`
do
  if [ -f $i/$DAEMON ]
  then
    EXEC_FOUND=1
    break
  fi
done

if [ $EXEC_FOUND -eq 0 ]
then
  echolog "ERROR: rtorrent does not exist or is not executable in PATH $PATH"
  exit 3
fi

if [ ! -r "${CONFIG}" ]
then
  echolog "ERROR: rtorrent config file does not exist or is not readable from ${CONFIG}."
  exit 3
else
  SESSION=`dirsession "$CONFIG"`
fi

if [ ! -d "${SESSION}" ]
then
  echolog "ERROR: session directory ${SESSION} does not exist or is not readable from ${CONFIG}."
  exit 3
fi

function start {
  if status
  then
    echolog "$SCREEN_NAME is already running"
    exit 1
  fi
  
  if [ `whoami` = root ]
  then
    su - $USER -c "screen -AmdS $SCREEN_NAME $DAEMON"
  else
    screen -AmdS $SCREEN_NAME $DAEMON
  fi
}

function stop {
  if ! status
  then
    echolog "$SCREEN_NAME could not be found. Probably not running."
    exit 1
  fi
  
  SESSION=`dirsession "$CONFIG"`
  if ! [ -s ${SESSION}/rtorrent.lock ] ; then
    return
  fi

  PID=`cat ${SESSION}/rtorrent.lock | awk -F: '{print($2)}' | sed "s/[^0-9]//g"`
  if [ `whoami` = root ]
  then
    if ps -A | grep -sq ${PID}.*rtorrent
    then
      su - $USER -c "kill -s INT ${PID}"
    fi
    tmp=$(su - $USER -c "screen -ls" | awk -F . "/\.$SCREEN_NAME\t/ {print $1}" | awk '{print $1}')
    su - $USER -c "screen -r $tmp -X quit"
  else
    if ps -A | grep -sq ${PID}.*rtorrent
    then
      kill -s INT ${PID}
    fi
    screen -r $(screen -ls | awk -F . "/\.$SCREEN_NAME\t/ {print $1}" | awk '{print $1}') -X quit
  fi
}

function status {
  if [ `whoami` = root ]
  then
    su - $USER -c "screen -ls" | grep [.]$SCREEN_NAME[[:space:]] > /dev/null
  else
    screen -ls | grep [.]$SCREEN_NAME[[:space:]] > /dev/null
  fi
}

function view {
  if ! status
  then
    echolog "$SCREEN_NAME could not be found. Probably not running."
    exit 1
  fi

  if [ `whoami` = root ]
  then
    tmp=$(su - $USER -c "screen -ls" | awk -F . "/\.$SCREEN_NAME\t/ {print $1}" | awk '{print $1}')
    su - $USER -c "screen -r $tmp"
  else
    screen -r $(screen -ls | awk -F . "/\.$SCREEN_NAME\t/ {print $1}" | awk '{print $1}')
  fi
}

function usage {
  echo "Usage: $0 {start|stop|status|restart|view}"
  echo "On view mod, press CTRL+A then D to stop the screen without stopping the program."
}

case "$1" in

  start)
    echolog "Starting $SCREEN_NAME..."
    start
    sleep 5
    echolog "$SCREEN_NAME started successfully"
  ;;

  stop)
    echolog "Stopping $SCREEN_NAME..."
    stop
    sleep 5
    echolog "$SCREEN_NAME stopped successfully"
  ;;
 
  restart)
    echolog "Restarting $SCREEN_NAME..."
    status && stop
    sleep 5
    start
    sleep 5
    echolog "$SCREEN_NAME restarted successfully"
  ;;

  status)
    if status
    then echolog "$SCREEN_NAME is UP"
    else echolog "$SCREEN_NAME is DOWN"
    fi
  ;;
 
  view)
    echolog "Open $SCREEN_NAME screen..."
    view
  ;;

  *)
    usage
    exit 1
  ;;

esac

exit 0
