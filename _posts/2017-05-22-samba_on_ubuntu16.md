---
layout:     post
title:      "Setup Samba server on ubuntu 16.04"
date:       2017-05-22 12:32:15 +0800
categories: tech
tags: [Ubuntu,Samba]
header-img: "img/post-bg-02.jpg"
---

记录一下过程中使用的命令。
```console
$ sudo apt-get install samba
$ sudo vi /etc/samba/smb.conf
```
加上如下配置 
```
#======================= Share Definitions =======================
[czshare]
    comment = All
    browseable = yes
    path = /home/pc
    read only = no
    valid users = @pc
    create mask = 0777
    directory mask = 0777
```
然后增加pc这个user 
``` console
$ sudo smbpasswd -a pc
New SMB password:
Retype new SMB password:
Failed to add entry for user pc.
```
出错是因为要先在系统里面增加这个user 
```console
$ sudo groupadd pc -g 6000
$ sudo useradd pc -u 6000 -g 6000 -s /sbin/nologin -d /dev/null
$ sudo smbpasswd -a pc
$ cd /home
$ sudo mkdir pc
$ sudo chown -R pc:pc /home/pc
$ sudo systemctl restart smbd.service nmbd.service
```
完成~
