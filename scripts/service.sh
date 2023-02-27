!#/bin/bash

LOGFILE=/var/log/qemu-ga.log

echo "Startup qemu-guest-agent" >> $LOGFILE

tail --pid=$$ -f $LOGFILE &

qemu-ga &2>1 >> $LOGFILE 
