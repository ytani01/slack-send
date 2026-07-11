#!/usr/bin/env bash
#
# (c) 2026 Yoichi Tanibayashi
#
MYNAME=$(basename "$0")

WEBHOOK_URL_FNAME=".webhook-url"

WEBHOOK_URL_FILE=${HOME}/${WEBHOOK_URL_FNAME}
CHANNEL="#notify-ip"
BOTNAME=$MYNAME
EMOJI=":computer:"
TITLE="[NOTIFY]"
URL=
VERBOSE=no
MSG_FILE=
MSG_TMP=$(mktemp "/tmp/${MYNAME}.XXX")
trap 'rm -f $MSG_TMP' EXIT

#
# functions
#
usage() {
    echo
    echo "Usage:"
    echo -n " $MYNAME"
    echo -n " [-vh]"
    echo -n " [-w WEBHOOK_FILE]"
    echo
    echo -n "              "
    echo -n " [-n BOTNAME]"
    echo -n " [-c CHANNEL]"
    echo -n " [-e EMOJI]"
    echo -n " [-t TITLE]"    
    echo
    echo -n "              "
    echo -n " [-f MSGFILE]"
    echo -n " [MSG] ..."
    echo
    echo
}

#
# main
#
while getopts hvw:n:c:e:u:t:f: OPT; do
      case $OPT in
          w) WEBHOOK_URL_FILE=$OPTARG;;
          n) BOTNAME=$OPTARG;;
          c) CHANNEL=$OPTARG;;
          e) EMOJI=$OPTARG;;
          u) URL=$OPTARG;;
          t) TITLE="[$OPTARG]";;
          f) MSG_FILE=$OPTARG;;
          v) VERBOSE=yes;;
          h) usage; exit 0;;
          *) usage; exit 1;;
      esac
done
shift $((OPTIND -1))

if [ "$VERBOSE" = "yes" ]; then
    echo "WEBHOOK_URL_FILE=$WEBHOOK_URL_FILE"
    echo "CHANNEL=$CHANNEL"
    echo "BOTNAME=$BOTNAME"
    echo "EMOJI=$EMOJI"
    echo "TITLE=$TITLE"
    echo "MSG_FILE=$MSG_FILE"
    echo "MSG_TMP=$MSG_TMP"
fi

if [ -z "$URL" ]; then
    URL=$(cat "${WEBHOOK_URL_FILE}")
    if [ $? -ne 0 ]; then
        exit 1
    fi
fi
if [ "$VERBOSE" = "yes" ]; then
    echo "URL=$URL"
fi

if [ ! -z "$MSG_FILE" ]; then
    cat "$MSG_FILE" > "$MSG_TMP"
    if [ $? -ne 0 ]; then
        exit 1
    fi
elif [ -n "$1" ]; then
    printf "%s\n" "$*" > "$MSG_TMP"
else
    # echo '===== Please, type message ====='
    cat - > "$MSG_TMP"
fi

# make json payload
PAYLOAD=$(jq -n \
  --arg channel "$CHANNEL" \
  --arg username "$BOTNAME" \
  --arg icon_emoji "$EMOJI" \
  --arg title "$TITLE" \
  --rawfile msg "$MSG_TMP" \
  '{channel: $channel, username: $username, icon_emoji: $icon_emoji, text: ($title + "\n```\n" + $msg + "```")}')
if [ "$VERBOSE" = "yes" ]; then
    echo "PAYLOAD=$PAYLOAD"
fi

# send message
exec curl -v -S -X POST -H "Content-Type: application/json" -d "${PAYLOAD}" "$URL"  > /dev/null 2>&1
