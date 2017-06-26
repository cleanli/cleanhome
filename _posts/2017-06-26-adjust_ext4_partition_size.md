---
layout:     post
title:      "【记录】调整ext4分区大小
date:       2017-06-26 23:34:06 +0800
categories: 技术
tags: ["记录",Ubuntu]
---
记录一下调整linux ext4分区大小的命令

```
$ sudo fdisk /dev/sdb

Welcome to fdisk (util-linux 2.27.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): p
Disk /dev/sdb: 149.1 GiB, 160041885696 bytes, 312581808 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xb73e72de

Device     Boot Start      End  Sectors Size Id Type
/dev/sdb1        2048 62916607 62914560  30G 83 Linux

Command (m for help): d
Selected partition 1
Partition 1 has been deleted.

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): 

Using default response p.
Partition number (1-4, default 1): 
First sector (2048-312581807, default 2048): 
Last sector, +sectors or +size{K,M,G,T,P} (2048-312581807, default 312581807): +30G

Created a new partition 1 of type 'Linux' and of size 30 GiB.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

clean@clean-M:~$ sudo e2fsck -f /dev/sdb1
e2fsck 1.42.13 (17-May-2015)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/sdb1: 7765/1966080 files (2.1% non-contiguous), 397783/7864320 blocks
clean@clean-M:~$ sudo resize2fs -p /dev/sdb1
resize2fs 1.42.13 (17-May-2015)
The filesystem is already 7864320 (4k) blocks long.  Nothing to do!

```
