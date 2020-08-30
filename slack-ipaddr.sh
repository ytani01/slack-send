#!/bin/sh
#
# (c) 2020 Yoichi Tanibayashi
#

SLACK_SEND_CMD=slack-send.sh

CHANNEL=${CHANNEL:-'#notify-ip'}
EMOJI=${EMOJI:-':computer:'}
HEAD=${HEAD:-"[IPアドレス通知] `hostname`\n"}

TMP_FILE=`mktemp`

date +'%F %T %Z' > $TMP_FILE
ifconfig -a | grep inet | grep -v inet6 | grep -v '127.0.0.1' | sed 's/^ *//' | cut -d ' ' -f 2 >> $TMP_FILE

cat $TMP_FILE | $SLACK_SEND_CMD
rm -f $TMP_FILE
