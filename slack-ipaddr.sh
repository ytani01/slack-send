#!/bin/sh
#
# (c) 2020 Yoichi Tanibayashi
#
MYNAME=`basename $0`
MYDIR=`dirname $0`

export PATH=$PATH:/sbin:/usr/sbin:$HOME/bin

SLACK_SEND_CMD=slack-send.sh
WEBHOOK_URL_FNAME=".webhook-url"

WEBHOOK_URL_FILE=${HOME}/${WEBHOOK_URL_FNAME}
CHANNEL='#notify-ip'
BOTNAME=$MYNAME
EMOJI=':computer:'
TITLE="IP アドレス通知: `hostname`"

HTTP_FLAG=
URL=
URL_PATH=/
PORT=
VERBOSE=no
TMP_FILE=`mktemp -t ${MYNAME}XXX`

#
# functions
#
usage() {
    echo
    echo "send IP address (and URL) to slack"
    echo
    echo -n "usage: $MYNAME"
    echo -n " [-hsv]"
    echo -n " [-w WEBHOOK_URL_FILE]"
    echo -n " [-n BOT_NAME]"
    echo -n " [-c CHANNEL]"
    echo -n " [-e EMODJI]"
    echo -n " [-t TITLE]"
    echo -n " [-p PORT]"
    echo -n " [-u URL_PATH]"
    echo
    echo
    echo "  -h\tHTTP URL flag"
    echo "  -s\tHTTPS URL flag"
    echo "  -p\tport number of URL"
    echo "  -u\tURL path"
    echo "  -v\tverbose"
    echo
}

get_ipaddr() {
    _IPADDR=
    _COUNT=0
    _COUNT_MAX=60

    while true; do
        if [ $_COUNT -ge $_COUNT_MAX ]; then
            date +'! abandon: %F %T %Z' >> $TMP_FILE
            exit 1
        fi

        _IPADDR=`ifconfig -a | grep inet | grep -v inet6 | grep -v '127.0.0.1' | sed 's/^ *//' | cut -d ' ' -f 2`
        if [ ! -z "$_IPADDR" ]; then
            echo "$_IPADDR"
            return
        fi

        _COUNT=`expr $_COUNT + 1`
        if [ $VERBOSE = "yes" ]; then
            echo "wating IP addr ($_COUNT) .."
        fi
        sleep 1
    done

    echo ""
    return
}

#
# main
#
trap "rm -f $TMP_FILE" 0

while getopts w:c:n:e:t:hsp:u:v OPT; do
    case $OPT in
        w) WEBHOOK_URL_FILE=$OPTARG; shift;;
        c) CHANNEL=$OPTARG; shift;;
        n) BOTNAME=$OPTARG; shift;;
        e) EMOJI=$OPTARG; shift;;
        t) TITLE=$OPTARG; shift;;
        h) HTTP_FLAG=http;;
        s) HTTP_FLAG=https;;
        p) PORT=$OPTARG; shift;;
        u) URL_PATH=$OPTARG; shift;;
        v) VERBOSE=yes;;
        *) usage; exit 1;;
    esac
    shift
done

if [ ! -z "$*" ]; then
    usage
    exit 1
fi

date +'* start: %F %T %Z' > $TMP_FILE
echo >> $TMP_FILE
uname -a >> $TMP_FILE

if [ -f /etc/os-release ]; then
    . /etc/os-release 
    echo $PRETTY_NAME >> $TMP_FILE
fi

if [ "$VERBOSE" = "yes" ]; then
    echo "WEBHOOK_URL_FILE=$WEBHOOK_URL_FILE"
    echo "CHANNEL=$CHANNEL"
    echo "BOTNAME=$BOTNAME"
    echo "EMOJI=$EMOJI"
    echo "TITLE=$TITLE"
    echo "HTTP_FLAG=$HTTP_FLAG"
    echo "PORT=$PORT"
    echo "URL_PATH=$URL_PATH"
    echo "TMP_FILE=$TMP_FILE"
fi

IPADDR=`get_ipaddr`
if [ "$VERBOSE" = "yes" ]; then
    echo "IPADDR=$IPADDR"
fi
echo >> $TMP_FILE
date +'* get: %F %T %Z' >> $TMP_FILE
echo >> $TMP_FILE
echo "IP addr: $IPADDR" >> $TMP_FILE

if [ ! -z "$HTTP_FLAG" ]; then
    if [ "$HTTP_FLAG" = "http" ]; then
        URL="http://$IPADDR"
    elif [ $HTTP_FLAG = "https" ]; then
        URL="https://$IPADDR"
    else
        usage
        exit 1
    fi

    if [ ! -z "$PORT" ]; then
        URL="${URL}:${PORT}"
    fi
    URL="${URL}${URL_PATH}"

    if [ "$VERBOSE" = "yes" ]; then
        echo "URL=$URL"
    fi

    echo >> $TMP_FILE
    echo "URL:     $URL" >> $TMP_FILE
fi

cat $TMP_FILE

exec $SLACK_SEND_CMD -w "$WEBHOOK_URL_FILE"\
     -n "$BOTNAME"\
     -c "$CHANNEL"\
     -e "$EMOJI"\
     -t "$TITLE"\
     $TMP_FILE
