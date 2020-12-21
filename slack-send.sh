#!/bin/sh
#
# (c) 2020 Yoichi Tanibayashi
#
MYNAME=`basename $0`
MYDIR=`dirname $0`

URL_FNAME=".webhook-url"

URL_FILE=${HOME}/${URL_FNAME}
CHANNEL="#notify-ip"
BOTNAME=$MYNAME
EMOJI=":computer:"
TITLE="[NOTIFY]\n"
URL=
VERBOSE=no
MSG_TMP=`mktemp -t ${MYNAME}XXX`

#
# functions
#
usage () {
    echo
    echo -n "usage: $MYNAME"
    echo -n " [-w WEBHOOK_FILE]"
    echo -n " [-c CHANNEL]"
    echo -n " [-e EMOJI]"
    echo -n " [-t TITLE]"
    echo " [MESSAGE_FILE]"
    echo
}

#
# main
#
while getopts w:n:c:e:u:t:hv OPT; do
      case $OPT in
      w) URL_FILE=$OPTARG; shift;;
      n) BOTNAME=$OPTARG; shift;;
      c) CHANNEL=$OPTARG; shift;;
      e) EMOJI=$OPTARG; shift;;
      u) URL=$OPTARG; shift;;
      t) TITLE="[$OPTARG]\n"; shift;;
      v) VERBOSE=yes;;
      h) usage; exit 0;;
      *) usage; exit 1;;
      esac
      shift
done

if [ "$VERBOSE" = "yes" ]; then
    echo "URL_FILE=$URL_FILE"
    echo "CHANNEL=$CHANNEL"
    echo "BOTNAME=$BOTNAME"
    echo "EMOJI=$EMOJI"
    echo "TITLE=$TITLE"
    echo "MSG_TMP=$MSG_TMP"
fi

if [ -z "$URL" ]; then
    URL=`cat ${URL_FILE}`
    if [ $? -ne 0 ]; then
        exit 1
    fi
fi
if [ "$VERBOSE" = "yes" ]; then
    echo "URL=$URL"
fi

trap "rm -v $MSG_TMP" 0

if [ ! -z $1 ]; then
    cat $* > $MSG_TMP
else
    echo '===== Please, type message ====='
    cat - > $MSG_TMP
fi

MSG1=`cat $MSG_TMP | tr '\n' '\\' | sed 's/\\\\/\\\\n/g'`
MSG='```'${MSG1}'```'
if [ "$VERBOSE" = "yes" ]; then
    echo "MSG=$MSG"
fi

# make json payload
PAYLOAD="payload={
    \"channel\": \"${CHANNEL}\",
    \"username\": \"${BOTNAME}\",
    \"icon_emoji\": \"${EMOJI}\",
    \"text\": \"${TITLE}${MSG}\"
}"
if [ "$VERBOSE" = "yes" ]; then
    echo "PAYLOAD=$PAYLOAD"
fi

# send message
curl -v -S -X POST --data-urlencode "${PAYLOAD}" $URL
