#!/bin/bash

APPID=com.iancanderson.GitWriting
if OUTPUT=`xcrun simctl get_app_container booted $APPID data` ; then
    echo $OUTPUT
    open $OUTPUT
else
    echo "$APPID not found!"
fi 2>/dev/null
