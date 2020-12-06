---
layout:     post
title:      "【收藏】一些命令收集（持续更新）"
date:       2017-05-29 21:21:46 +0800
author:     "Clean Li"
categories: 技术
tags: ["收藏",Jekyll,Windows,Ubuntu,"虚拟机",Vim]
settop: true
header-img: "img/post-bg-01.jpg"
---

<a id="index"></a>
### 目录
+ [Android Debug](#part01)
+ [Git](#part02)
+ [Vim](#part03)
+ [Ubuntu](#part04)
+ [Windows](#part05)
+ [Virtual Box](#part06)
+ [博客技术](#part07)

<a id="part01"></a>
### Android Debug
---
CTS
```
run cts --retry ID (before Android P)
run retry --retry ID (>=Android P)
run cts --shared-count 4 (4 devices)
run cts -a arm64-v8a -m CtsCameraTestCases -t ...
```
---
自动间隔执行
```
watch -n 0.1 "adb shell cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq"
```
---

adb pull文件列表
```
adb shell ls /system/lib/*13850* | tr '\n\r' ' ' | xargs -n1 adb pull
```
adb logcat buffer
```
adb logcat -G 20M //set log buffer 20M
adb logcat -g //get log buffer size
```
---

addr2line
```
$ arm-eabi-addr2line -e libcamera.so 00007ba5
/home/aa/Project/***/vendor/***/***.c:1460
```
---

objdump
```
arm-eabi-objdump -d -S libcamera.so > /tmp/asm
```
---

[返回目录](#index)
<a id="part02"></a>
### Git
---

git退回某个文件到某个版本
```
git reset a4e215234aa4927c85693dca7b68e9976948a35e MainActivity.java
```
---

[返回目录](#index)
<a id="part03"></a>
### Vim
---

vim查找关键字并删除所有包含关键字的行
```
:g/keyword/d
```
---

[返回目录](#index)
<a id="part04"></a>
### Ubuntu
---
apt get install "too many errors"
清空 /var/lib/dpkg/info
```
sudo apt-get -f install
sudo dpkg --configure -a
```
---
tar分卷压缩
```
tar czvf - test_dir |split -d -b 10000m - test_dir.tar.gz.
```
会得到
```
test_dir.tar.gz.00
test_dir.tar.gz.01
test_dir.tar.gz.02
...
```
解压
```
cat test_dir.tar.gz.0* | tar xzv
```
---

安装deb
```
sudo dpkg -i file.deb
```
---

批量查找替换文本
```
sed -i "s/ABCD/wxyz/g" $(find ./ -name "config")
```
---

修复zip文件
```
zip -FF Log_0.51.999.1_LC4ABYA00177_Day1_SST82248.zip --out fix.zip
```
---

List apt
```
$ sudo apt list
```
---
安装gimp
```
sudo apt-get install gimp
```
---

[返回目录](#index)
<a id="part05"></a>
### Windows
---

Windows 7/8/10 打开休眠选项
```
powercfg /a
powercfg /h off
powercfg /h /size 50
powercfg /h on
```

---

[返回目录](#index)
<a id="part06"></a>
### Virtual Box
---

Ubuntu install/remove virtual box
```
$ sudo apt-get install virtualbox
$ sudo apt-get remove --purge virtualbox
```
---

Virtualbox加载真实硬盘（USB硬盘）<br>
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
---

[返回目录](#index)
<a id="part07"></a>
### 博客技术
---
生成rouge语法高亮配色文件
```
$ rougify style monokai.sublime > rouge.css
```
---

在CSS中margin是指从自身边框到另一个容器边框之间的距离，就是容器外距离；padding是指自身边框到自身内部另一个容器边框之间的距离，就是容器内距离。

---

Jekyll局域网访问
```
$ jekyll serve -w --host=0.0.0.0
...
    Server address: http://0.0.0.0:4000/cleanhome/
  Server running... press ctrl-c to stop.
```
[返回目录](#index)
