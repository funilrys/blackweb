#!/bin/bash
### BEGIN INIT INFO
# Provides:          blackweb
# Required-Start:    $local_fs $remote_fs $network
# Required-Stop:     $local_fs $remote_fs $network
# Should-Start:      $named
# Should-Stop:       $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable service provided by daemon
### END INIT INFO

# by:	maravento.com and novatoz.com

# VARIABLES
route=/etc/acl
bwpath=$(pwd)/bw
date=`date +%d/%m/%Y" "%H:%M:%S`

# DEL OLD REPOSITORY
if [ -d $bwpath ]; then rm -rf $bwpath; fi

# CREATE PATH
if [ ! -d $route ]; then mkdir -p $route; fi

# DOWNLOAD
clear
echo
echo "Download Blackweb ACL..."
svn export "https://github.com/maravento/blackweb/trunk/bw" >/dev/null 2>&1
cd $bwpath
cat blackweb.tar.gz* | tar xzf -
echo "OK"
echo
echo "Checking Sum..."
a=$(md5sum blackweb.txt | awk '{print $1}')
b=$(cat blackweb.md5 | awk '{print $1}')
	if [ "$a" = "$b" ]
	then
		echo "Sum Matches"
		# ADD OWN LIST
		#sed '/^$/d; / *#/d' /path/blackweb_own.txt >> blackweb.txt
		cp -f  blackweb.txt $route/blackweb.txt >/dev/null 2>&1
		echo "OK"
		echo "Blackweb for Squid: Done $date" >> /var/log/syslog
		cd
		rm -rf $bwpath
		echo
		echo "Done"
	else
		echo "Bad Sum"
		echo "Blackweb for Squid: Abort $date Check Internet Connection" >> /var/log/syslog
		cd
		rm -rf $bwpath
		echo
		echo "Abort"
		exit
fi