#!/bin/bash
# ------------------------------------
# HTTPSTATUS
# https://stackoverflow.com/questions/6136022/script-to-get-the-http-status-code-of-a-list-of-urls
# Modified by: Alej Calero and Jhonatan Sneider
# ------------------------------------

# PATH FILE (change path to your list)
bwlst=$(pwd)/blackweb.txt

clear
# CLEAN LIST
echo "Clean List..."
if [ ! -f cleanlst ]; then
        sed -e '/^#/d' $bwlst | sed -r '/^.\W+/d' | sed 's/^.//g' | sed '/[A-Z]/d' | sort -u > cleanlst
        echo "OK"
    else
        echo "OK"
fi

# HTTPSTATUS
echo "HTTP Status..."
progress=$(cat progress.txt 2>/dev/null || echo 1)
while read LINE; do
   curl -o /dev/null --silent --head --write-out '%{http_code}' "$LINE"
   echo " $LINE"
   progress=$(($progress+1))
   echo $progress > progress.txt
done < <(tail -n +$progress cleanlst) >> out
echo "OK"

# REPLACE BLACKWEB
echo "Replace Blackweb..."
sed '/^000/d' out | awk '{print $2}' | awk '{print "."$1}' | sort -u > $bwlst
echo Done
