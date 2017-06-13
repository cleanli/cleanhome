---
layout:     post
title:      "【记录】USB硬盘安装Android x86"
date:       2017-06-13 22:54:50 +0800
categories: 技术
tags: ["记录",Android,Grub]
---
直接使用Android x86的usb-iso安装的usb移动硬盘启动不了，停留在Grub启动提示信息界面。所以直接安装grub。

安装了Android x86的移动硬盘根目录下有`/android-2017-06-09`和`/grub`目录。

尝试了两种Grub，一个版本是GNU GRUB 0.97，这个是Legacy版本，使用menu.lst配置。在Ubuntu下安装命令为：
```
$ sudo grub-install --root-directory=/media/clean/b7971baa-7bb6-4d1d-998f-7e017dc5aa4d/ /dev/sdb
Probing devices to guess BIOS drives. This may take a long time.
Installing GRUB to /dev/sdb as (hd1)...
Installation finished. No error reported.
This is the contents of the device map /media/clean/b7971baa-7bb6-4d1d-998f-7e017dc5aa4d//boot/grub/device.map.
Check if this is correct or not. If any of the lines is incorrect,
fix it and re-run the script `grub-install'.

(fd0)	/dev/fd0
(hd0)	/dev/sda
(hd1)	/dev/sdb

$ cd /media/clean/b7971baa-7bb6-4d1d-998f-7e017dc5aa4d/

$ ls
android-2017-06-09  boot  grub

$ sudo mv grub boot
```
menu.list类似如下：
```
title Android-x86 2017-06-09
        root (hd0,0)
        kernel /android-2017-06-09/kernel root=/dev/ram0 androidboot.selinux=permissive buildvariant=eng DEBUG=2 SRC=/android-2017-06-09
        initrd /android-2017-06-09/initrd.img
```

如果是grub 2.02，命令有所不同
```
$ cd /media/clean/b7971baa-7bb6-4d1d-998f-7e017dc5aa4d/

$ sudo mkdir boot

$ sudo grub-install --boot-directory=/media/clean/b7971baa-7bb6-4d1d-998f-7e017dc5aa4d/boot /dev/sdb

$ vi /boot/grub/grub.cfg
```
里面这样写：
```
set timeout=6

menuentry 'Android-x86 2017-06-09' {
set root='(hd0,msdos1)'
linux /android-2017-06-09/kernel root=/dev/ram0 androidboot.selinux=permissive buildvariant=eng SRC=/android-2017-06-09
initrd /android-2017-06-09/initrd.img
}
```

另外，如果启动不了，进入了grub命令行，可以按配置文件里面的命令尝试，同时使用tab键自动补全，找到正确的配置或所在分区和目录。

记录一下一个低级错误:<br>
【问题】在grub命令行可以启动Android x86，但写到配置文件就不能启动，提示`Error 15, can't find file`<br>
【原因】android那个目录带日期，配置文件写`/android-2017-06-09`，实际目录`/android-2017-06-07`。grub命令行是tab自动补全的，所以正确启动
