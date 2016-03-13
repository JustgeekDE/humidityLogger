#! /bin/sh
# /etc/init.d/myscript
#

cd /home/pi/humidityLogger/backend
nohub node index.js > node.pid

exit 0
