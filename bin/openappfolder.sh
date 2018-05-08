#!/bin/bash

APPID=$1
if OUTPUT=`xcrun simctl get_app_container booted $APPID data` ; then
    open $OUTPUT
else
    echo "$APPID not found!"
fi 2>/dev/null
