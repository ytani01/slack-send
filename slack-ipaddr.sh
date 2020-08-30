#!/bin/sh -eu
#
# (c) 2020 Yoichi Tanibayashi
#
export PATH=$PATH:/sbin:/usr/sbin:$HOME/bin
echo $PATH

SLACK_SEND_CMD=slack-send.sh

export CHANNEL='#notify-ip'
export EMOJI=':computer:'
export HEAD="[IPアドレス通知] `hostname`\n"

TMP_FILE=`mktemp`

date +'start: %F %T %Z' > $TMP_FILE
echo >> $TMP_FILE

IPADDR=""
COUNT=0
COUNT_MAX=60

while [ -z "$IPADDR" ]; do
    if [ $COUNT -ge $COUNT_MAX ]; then
	date +'abandon: %F %T %Z' >> $TMP_FILE
	mv $TMP_FILE $HOME
	exit 1
    fi

    sleep 1
    IPADDR=`ifconfig -a | grep inet | grep -v inet6 | grep -v '127.0.0.1' | sed 's/^ *//' | cut -d ' ' -f 2`
    COUNT=`expr $COUNT + 1`
done

date +'get  : %F %T %Z' >> $TMP_FILE
echo -n "IP addrs: " >> $TMP_FILE
ifconfig -a | grep inet | grep -v inet6 | grep -v '127.0.0.1' | sed 's/^ *//' | cut -d ' ' -f 2 >> $TMP_FILE

cat $TMP_FILE | $SLACK_SEND_CMD
rm -f $TMP_FILE
