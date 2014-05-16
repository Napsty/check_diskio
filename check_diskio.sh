#!/bin/bash
################################################################################
# Script: check_diskio
# Author: Claudio Kuenzler (www.claudiokuenzler.com)
# Purpose: Very simple way of monitoring some disk io
# 2014-05-15 - Rewrote plugin, accepts device, lvm and partition types
################################################################################
# Get user-given variables
while getopts "t:d:l:g:h" Input;
do
case ${Input} in
 t) type=${OPTARG};;
 d) device=${OPTARG};;
 l) lv=${OPTARG};;
 g) vg=${OPTARG};;
 h) echo -e "Usage: $0 -t [device|lvm] [-d name of device or partition] [-l lvname][-g vgname]";;
 *) echo -e "${help}"; exit $STATE_UNKNOWN;;
esac
done
################################################################################
case ${type} in

device)
  # Check if device exists and is a block device
  if [ -b /dev/$device ]
  then
    cat /proc/diskstats | egrep "$device " | awk '{print "DISKIO OK - "$3" "$4" reads "$8" writes|read="$4" write="$8}'
    exit 0
  else
    echo "DISKIO CRITICAL - $device is not a block device"
    exit 2
  fi
  ;;

lvm)
  # Check for lv and vg names
  if [ -z $lv ]; then echo "DISKIO UNKNOWN - No Logical Volume name given"; exit 3; fi
  if [ -z $vg ]; then echo "DISKIO UNKNOWN - No Volume Group name given"; exit 3; fi

  # Lets try /dev/mapper first
  if [ -h /dev/mapper/${vg}-${lv} ]
  then
    dm=$(readlink /dev/mapper/${vg}-${lv} | awk -F/ '{print $2}')
    cat /proc/diskstats | egrep "$dm " | awk '{print "DISKIO OK - "$3" "$4" reads "$8" writes|read="$4" write="$8}'
    exit 0
  # /dev/mapper not available, let's do /dev/VG then
  elif [ -h /dev/${vg}/${lv} ]
  then
    dm=$(readlink /dev/${vg}/${lv} | awk -F/ '{print $2}')
    cat /proc/diskstats | egrep "$dm " | awk '{print "DISKIO OK - "$3" "$4" reads "$8" writes|read="$4" write="$8}'
    exit 0
  else echo "DISKIO CRITICAL - Could not find Logical Volume ($lv) in Volume Group ($vg)"; exit 2
  fi
  ;;

esac
