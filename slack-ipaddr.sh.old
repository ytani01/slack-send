#!/bin/sh -eu
#
# (c) 2020 Yoichi Tanibayashi
#
MYNAME=`basename $0`
MYDIR=`dirname $0`

export PATH=$PATH:/sbin:/usr/sbin:$HOME/bin
echo $PATH

SLACK_SEND_CMD=slack-send.sh

CHANNEL='#notify-ip'
EMOJI=':computer:'
TITLE="IPアドレス通知 `hostname`"

TMP_FILE=`mktemp -t ${MYNAME}XXX`

trap "rm -f $TMP_FILE" 0

date +'* start: %F %T %Z' > $TMP_FILE
uname -a >> $TMP_FILE
echo >> $TMP_FILE

IPADDR=""
COUNT=0
COUNT_MAX=60

while [ -z "$IPADDR" ]; do
    if [ $COUNT -ge $COUNT_MAX ]; then
	date +'! abandon: %F %T %Z' >> $TMP_FILE
	mv $TMP_FILE $HOME
	exit 1
    fi

    sleep 1
    IPADDR=`ifconfig -a | grep inet | grep -v inet6 | grep -v '127.0.0.1' | sed 's/^ *//' | cut -d ' ' -f 2`
    COUNT=`expr $COUNT + 1`
done

date +'* get: %F %T %Z' >> $TMP_FILE
echo "[IP addr]" >> $TMP_FILE
ifconfig -a | grep inet | grep -v inet6 | grep -v '127.0.0.1' | sed 's/^ *//' | cut -d ' ' -f 2 >> $TMP_FILE

$SLACK_SEND_CMD -c "$CHANNEL" -e "$EMOJI" -t "$TITLE" $TMP_FILE
