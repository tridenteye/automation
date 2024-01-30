#!/bin/bash
#set -eu

## Find and replace
export OLD_STRING="latest-rhnode16"
export NEW_STRING="latest-rhnode18"

find-replace() {
    echo " --- replacing string --- "
    #grep -rli ${OLD_STRING} * | xargs -I@ sed -i '' "s|${OLD_STRING}|${NEW_STRING}|g" @ # works on mac
    grep -rli ${OLD_STRING} * | xargs -I@ sed -i "s|${OLD_STRING}|${NEW_STRING}|g" @ #works on linux
}