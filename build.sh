#!/bin/sh

set -e

CURRENT_DIR=$PWD
# locate
if [ -z "$BASH_SOURCE" ]; then
    SCRIPT_DIR=`dirname "$(readlink -f $0)"`
elif [ -e '/bin/zsh' ]; then
    F=`/bin/zsh -c "print -lr -- $BASH_SOURCE(:A)"`
    SCRIPT_DIR=`dirname $F`
elif [ -e '/usr/bin/realpath' ]; then
    F=`/usr/bin/realpath $BASH_SOURCE`
    SCRIPT_DIR=`dirname $F`
else
    F=$BASH_SOURCE
    while [ -h "$F" ]; do F="$(readlink $F)"; done
    SCRIPT_DIR=`dirname $F`
fi
# change pwd
cd $SCRIPT_DIR

LITESTREAM_VERSION=`git rev-parse HEAD`

build_bin() {
NAME=`basename $1`
CGO_ENABLED=1 go build \
-v -ldflags "-s -w -X 'main.Version=${LITESTREAM_VERSION}'" \
-o dist/$NAME $1
}

build_bin ./cmd/litestream
build_bin ./_examples/library/basic
build_bin ./_examples/library/s3
