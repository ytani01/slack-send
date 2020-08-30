#!/bin/sh -eu
#
# (c) 2020 Yoichi Tanibayashi
#

SLACK_SEND_CMD=slack-send.sh

export CHANNEL='#notify-ip'
export EMOJI=':computer:'
export HEAD="[IPアドレス通知] `hostname`\n"

TMP_FILE=`mktemp`

IPADDR=""
while [ -z "$IPADDR" ]; do
    sleep 1
    IPADDR=`ifconfig -a | grep inet | grep -v inet6 | grep -v '127.0.0.1' | sed 's/^ *//' | cut -d ' ' -f 2`
done

date +'%F %T %Z' > $TMP_FILE
echo >> $TMP_FILE
echo -n "IP addrs: " >> $TMP_FILE
ifconfig -a | grep inet | grep -v inet6 | grep -v '127.0.0.1' | sed 's/^ *//' | cut -d ' ' -f 2 >> $TMP_FILE

cat $TMP_FILE | $SLACK_SEND_CMD
rm -f $TMP_FILE
