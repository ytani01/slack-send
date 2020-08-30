#!/bin/sh -eu
#
# (c) Yoichi Tanibayashi
#
MYNAME=`basename $0`

WEBHOOKURL_FILE=${WEBHOOKURL_FILE:-$HOME/.webhook-url}

BOTNAME=${BOTNAME:-'ytani-bot'}
CHANNEL=${CHANNEL:-'#notify-mail'}
EMOJI=${EMOJI:-':e-mail:'}
HEAD=${HEAD:-"[メール通知]\n"}

URL=`cat $WEBHOOKURL_FILE`

MESSAGEFILE=`mktemp -t $MYNAME`
trap "rm ${MESSAGEFILE}" 0

# 改行コードを変換
cat - | tr '\n' '\\' | sed 's/\\/\\n/g' > ${MESSAGEFILE}
MESSAGE='```'`cat ${MESSAGEFILE}`'```'

# make json payload
payload="payload={
    \"channel\": \"${CHANNEL}\",
    \"username\": \"${BOTNAME}\",
    \"icon_emoji\": \"${EMOJI}\",
    \"text\": \"${HEAD}${MESSAGE}\"
}"

# send message
curl -v -S -X POST --data-urlencode "${payload}" ${URL}
