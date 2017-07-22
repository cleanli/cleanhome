---
layout:     post
title:      "【记录】调整virtual box硬盘大小"
date:       2017-05-22 14:37:00 +0800
author:     "Clean Li"
categories: 技术
tags: ["记录","虚拟机"]
header-img: "img/post-bg-05.jpg"
---

今天调整了一下vbox虚拟机的硬盘大小，还是比较容易的，命令记录一下：
```console
$ VBoxManage list hdds
UUID:           9ca97416-71ab-41cd-b8c1-1890ac4f7d28
Parent UUID:    base
State:          created
Type:           normal (base)
Location:       /a_part/vbox/xp/zj.vdi
Storage format: VDI
Capacity:       102400 MBytes
 
UUID:           cc37beaa-74a1-4382-a2cb-e32bff0ec78e
Parent UUID:    base
State:          created
Type:           normal (base)
Location:       /j_part/win8_vbox/win8.vdi
Storage format: VDI
Capacity:       25600 MBytes
 
$ VBoxManage modifyhd /j_part/win8_vbox/win8.vdi --resize 40000
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
$ VBoxManage list hdds
UUID:           9ca97416-71ab-41cd-b8c1-1890ac4f7d28
Parent UUID:    base
State:          created
Type:           normal (base)
Location:       /a_part/vbox/xp/zj.vdi
Storage format: VDI
Capacity:       102400 MBytes
 
UUID:           cc37beaa-74a1-4382-a2cb-e32bff0ec78e
Parent UUID:    base
State:          created
Type:           normal (base)
Location:       /j_part/win8_vbox/win8.vdi
Storage format: VDI
Capacity:       40000 MBytes
```
再进入win8使用磁盘管理器动态扩展C盘就可以了。 
