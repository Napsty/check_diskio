check_diskio
============

Very simple plugin to monitor disk io.

Does not support warning/critical thresholds. This plugin is merely used for graphing the IO.


Usage/Examples
==============

Get disk io for a physical device:

    /usr/lib/nagios/plugins/check_diskio -t device -d sda
    DISKIO OK - sda 12807535 reads 69634215 writes|read=12807535 write=69634215

Get disk io for a logical volume:

    /usr/lib/nagios/plugins/check_diskio -t lvm -g vgdata -l backup
    DISKIO OK - dm-4 21537357 reads 81104613 writes|read=21537357 write=81104613

