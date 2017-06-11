---
layout:     post
title:      "【收藏】一些命令收集（持续更新）"
date:       2017-05-29 21:21:46 +0800
author:     "Clean Li"
categories: 技术
tags: ["收藏",Jekyll,Windows,Ubuntu,"虚拟机"]
header-img: "img/post-bg-01.jpg"
---
- 生成rouge语法高亮配色文件
```
$ rougify style monokai.sublime > rouge.css
```

- 在CSS中margin是指从自身边框到另一个容器边框之间的距离，就是容器外距离；padding是指自身边框到自身内部另一个容器边框之间的距离，就是容器内距离。

- Windows 7/8/10 打开休眠选项
```
powercfg /a
powercfg /h off
powercfg /h /size 50
powercfg /h on
```

- Ubuntu install virtual box
```
$ sudo apt-get install virtualbox
```

- List apt
```
$ sudo apt list
```

- Virtualbox加载真实硬盘（USB硬盘）<br>
Ubuntu
```
$ sudo chmod 666 /dev/sdb
$ VBoxManage internalcommands listpartitions -rawdisk /dev/sdb
Number  Type   StartCHS       EndCHS      Size (MiB)  Start (Sect)
1       0x83  0   /1  /1   1023/254/63        152625           63
$ VBoxManage internalcommands createrawvmdk -filename ~/mydisk.vmdk -rawdisk /dev/sdb
```
Windows
```
VBoxManage internalcommands createrawvmdk -filename mydisk.vmdk -rawdisk \.\PhysicalDrive0
```
其中\.\PhysicalDrive0是第一个物理硬盘，如果你不确定是不是这个硬盘的话你可以用下面的命令检查一下分区情况：
```
Windows:VBoxManage internalcommands listpartitions -rawdisk \.\PhysicalDrive0
```
