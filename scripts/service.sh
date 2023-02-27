#!/bin/sh
# (c) 2023 by Crispin Tschirky <crispin.tschirky@gmail.com>
#
# Licensed under BSD-3 License, see https://opensource.org/licenses/BSD-3-Clause
#
# Replacement for shutdown on pod which invokes the operation on the real host
# can be used for qemu-guest-agent daemon pod to reboot the host in case e.g. proxmox requests it
#

LOGFILE=/var/log/qemu-ga.log

echo "Startup qemu-guest-agent" >> $LOGFILE

tail --pid=$$ -f $LOGFILE &

qemu-ga &2>1 >> $LOGFILE 
