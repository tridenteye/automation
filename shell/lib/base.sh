#!/bin/bash
#set -eu

find-replace() {
    echo " --- replacing string --- "
    #grep -rli ${OLD_STRING} * | xargs -I@ sed -i '' "s|${OLD_STRING}|${NEW_STRING}|g" @ # works on mac
    grep -rli ${OLD_STRING} * | xargs -I@ sed -i "s|${OLD_STRING}|${NEW_STRING}|g" @ #works on linux
}