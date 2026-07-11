#!/bin/sh
#
# (c) 2026 Yoichi Tanibayashi
#

BINDIR=$HOME/bin
LOGDIR=$HOME/tmp

CMDS="slack-send.sh slack-ipaddr.sh"

cd "$(dirname $0)" || exit 1
MYDIR=$(pwd)

if [ ! -d $BINDIR ]; then
    mkdir -pv "$BINDIR"
fi

if [ ! -d $LOGDIR ]; then
    mkdir -pv "$LOGDIR"
fi

cd "$MYDIR" || exit 2
pwd
for f in $CMDS; do
    ln -sfv "$MYDIR/$f" "$BINDIR"
done
