#!/bin/bash
set -eo pipefail
IFS=$'\n'
if [ $# -ne 1 ]; then
    echo "usage: dedup.sh [PATH]"
fi
DIR=$1
cd $DIR

echo "~~ deduplicating $PWD ~~"
echo "current size: $(du -hs .)"

CUR_HASH=
CUR_PATH=

for ENTRY in $(find . ! -empty -type f -name '*.so*' -exec md5sum {} + | sort | uniq -w32 -dD); do
    NEXT_HASH=$(echo $ENTRY | cut -f1 -d' ')
    NEXT_PATH=$(echo $ENTRY | cut -f3 -d' ')

    if [ "$NEXT_HASH" != "$CUR_HASH" ]; then
        CUR_HASH=$NEXT_HASH
        CUR_PATH=$NEXT_PATH
    else
        diff $CUR_PATH $NEXT_PATH
        echo linking $NEXT_PATH to $CUR_PATH
        RELPATH=$(realpath --relative-to="$(dirname $NEXT_PATH)" $CUR_PATH)
        rm $NEXT_PATH
        ln -s -T $RELPATH $NEXT_PATH
        diff $CUR_PATH $NEXT_PATH
    fi
done

echo "after size: $(du -hs .)"
echo "~~ deduplicating done ~~"
