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
update framework.jar
```
$ adb root
$ adb remount
$ adb push framework.jar /system/framework
$ adb shell rm -rf /system/framework/arm
$ adb shell rm -rf /system/framework/arm64
$ adb shell rm -rf /data/dalvik-cache/arm
$ adb shell rm -rf /data/dalvik-cache/arm64
$ adb reboot
```
---
CTS
```
run cts --retry ID (before Android P)
run retry --retry ID (>=Android P)
run cts --shared-count 4 (4 devices)
run cts -a arm64-v8a -m CtsCameraTestCases -t ...
```
---
VTS & STS
```
vts-tf> run vts -m VtsHalCameraProviderV2_4Target
run sts-engbuild
run sts-userbuild
```
---
Sepolicy
```
$ adb shell setenforce 0/1
$ adb shell getenforce
$ adb logcat | grep avc
$ adb logcat -b kernel | grep avc

build/make/core/version_defaults.mk
    PLATFORM_SECURITY_PATCH := 2019-07-01
```
Check security on device: settings -> about

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
adb其他相关命令 
```
adb logcat -G 20M //set log buffer 20M
adb logcat -g //get log buffer size
adb shell input draganddrop 700 2400 400 2400 40000
adb shell input keyevent 4
adb shell input tap 900 1600
adb disable-verity
adb shell dumpsys package
adb shell am start -n com.android.camera.pro/.Main
adb shell am start -n com.clean.goldcamera/.MainActivity
```
---
adb "insufficient permission for device: verify udev rules"
```
$ sudo chmod +s adb
$ lsusb
$ sudo vi /etc/udev/rules.d/51-android.rules
SUBSYSTEM=="usb", ATTR{idVendor}=="0bb4", ATTR{idProduct}=="0c81", MODE="0666", OWNER="xxx"
$ sudo chmod a+x /etc/udev/rules.d/51-android.rules
$ adb kill-server
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
查看进程栈
```
debuggerd -b [<tid>]
```
---

[返回目录](#index)
<a id="part02"></a>
### Git
---
```
repo manifest -o snapshot.xml -r
repo forall -p -c <git_cmd>
```
---

git退回某个文件到某个版本
```
git reset a4e215234aa4927c85693dca7b68e9976948a35e MainActivity.java
```
---
本地添加远程仓库并push
```
git init
git add *
git commit -m "first"
git remote add origin https://github.com/cleanli/xxx.git
git push -n origin master
```
本地创建远程仓库branch
```
git remote add origin https://github.com/cleanli/xxx.git
git push origin new_branch
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
多行缩进：
'V'进入Visual模式，'>' indent, '<' deindent

其他命令
```
:let Tlist_WinWidth=80
:set mouse=a //开启鼠标
:set expandtab //空格取代tab，个数由tabstop定义
:set tabstop=4
:retab //设置expandtab后，运行此命令原有的tab也会变成空格
:set shiftwidth=4 //回车后自动缩进宽度
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
其他
```
ssh-keygen
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
win10备份/恢复驱动
```
C:\dism /online /export-driver /destinaton:E\Dirvers
C:\dism /online /Add-driver /Driver:E:\Drivers /Recurse
```
---
windows安装文件install.vim文件如果大于4G，不能放在fat32文件系统，需要拆分。<br>
拆分命令(2000M=2G)
```
C:\dism /Split-Image /ImageFile:E:\sources\install.vim /SWMFile:D:\install.swm /FileSize:2000
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
