---
layout:     post
title:      "【转载】Android-x86虚拟机安装配置全攻略"
date:       2017-06-07 22:32:40 +0800
categories: 技术
tags: ["转载",Android]
---
(原文网址：[Android-x86虚拟机安装配置全攻略](http://www.oschina.net/question/565065_92851))

Android-x86虚拟机安装配置网上有很多，但是全部说明白的确不多，希望这篇文章能把主要的配置介绍给您，帮助您少走一些弯路。

本文分别针对VMWare和Virtual Box两种虚拟机介绍安装配置方法，并描述了如何使用eclipse进行调试。

### 一、安装Android-x86虚拟机

#### 1、使用vmware安装Android-x86

在http://www.android-x86.org/download下载安装包，下载eeepc版本的iso文件，本例以4.0 RC2版本为例。

运行vmware-新建虚拟机

#### 2、virtual box安装Android-x86

在 Virtual Box 中创建一台新的机器：

 -   target OS（目标 OS）: 选择 Linux
 -   target OS version（目标 OS 版本）: others
 -   我选择了 1GB 内存和 1 个 CPU（其他选项保留默认值）
 -   增加一个新的硬盘：VDI drive，动态大小，512M
 -   在 storage(存储）选项中添加一个指向所下载 iso 镜像的 CDROM

#### 3、开始安装

从 boot（启动）菜单中选择 install to hard disk（安装到硬盘）。

接下来创建分区，依次选择new、primary、bootable、write创建一个可引导的主分区。

接下来两步选择yes，其中第二步为开启GRUB管理模式，可以用于调试程序。

### 二、Android-x86 有内建的快捷键

较常用的有：

 -   Alt-F1 = 进入 console 模式
 -   Alt-F7 = 回到 GUI 模式
 -   Alt-F9 = 图形界面
 -   Alt-F10 = 画面旋转 180 度
 -   Alt-F10 = 画面旋转 180 度
 -   Alt-F11 = 画面向左旋转 90 度
 -   Alt-F12 = 画面向右旋转 90 度
 -   Ctrl-P = 开启Android设定画面
 -   "Windows 键"相当于 Android 的 Home 按钮。
 -   "Esc" 相当于 Android 的 Back 按钮
 -   F2 相当于 Android 的 Menu 按钮
 -   F3 相当于 Android 的 Search 按钮
 -   右边的菜单键（win和ctrl中间的键） = Android菜单键
  
### 三、设置虚拟机网络

#### 1、vmware设置

a、安装虚拟机时需要使用nat模式

b、如果/data/misc/dhcp目录不存在，则进入console模式创建
```
# mkdir /data/misc/dhcp
```

c、关闭虚拟机及vmware，修改vmx文件
```
ethernet0.virtualDev = "vlance"
```

d、开启虚拟机，进入console模式
```
# su 
# dhcpcd eth0
```

e、设定dns，或者设置为与宿主机的dns一致的地址
```
# setprop net.dns1 8.8.8.8
```

#### 2、virtual box设置：

使用桥接模式：

a、使用netcfg命令查看eth0设备是否已经分配ip地址

b、开启虚拟机，使用ALT+F1进入console模式，输入su切换root用户

c、指定ip地址，执行如下脚本，ip地址需要和物理主机在同一个网段中
```
# ifconfig eth0 192.168.120.200 netmask 255.255.255.0 up
```

将物理主机网关加入路由表
```
# route add default gw 192.168.120.254 dev eth0
```

d、设定dns，或者设置为与物理主机的dns一致的地址，如202.106.196.115
```
# setprop net.dns1 8.8.8.8
```

另外需要特别注意的是，如果豌豆荚等进程处于启动状态，网络设置会失败，使用netcfg命令会发现根本没有eth0设备。

所以在安装虚拟机之前一定要停止豌豆荚等软件。

如果使用NAT模式，需要使用dncpcd自动分配ip地址，dns要和物理主机一样，示例如下：
```
# dhcpcd 
# ifconfig eth0 up 
# setprop net.dns1 202.107.117.11
```

另外还需要配置端口转发

端口转发也可以在物理主机virtual box目录下使用如下命令：
```
# VBoxManage modifyvm "Your Android VB name" --natpf1 adb,tcp,*,5555,*,5555
```
 
#### 3、使设置长期生效

在console模式下的配置信息似乎不会保存，使用以下方法可以保证设置一直生效
```
# Vi /etc/init.sh
```

在文件末尾增加如下配置：
```
ifconfig eth0 192.168. 120.200 netmask 255.255. 255.0 uproute add default gw 192.168. 120.254 dev eth0setprop net.dns1 202.106. 196.115
```
 
### 四、配置分辨率，可以分别模拟手机和平板移动设备

Virtual box可以配置分辨率，vmware还没有很好的办法，因此以Virtual box为例。

#### 1、在虚拟机添加自定义分辨率

在虚拟机关闭以后进行。

方法一：对应的虚拟机的vbox文件的“<ExtraData>”下新开一行，添加以下内容
```
< ExtraDataItem name ="CustomVideoMode1" value ="480x800x16" /> < ExtraDataItem name ="CustomVideoMode2" value ="320x480x16" />
```

方法二：执行命令，其中“VM name”替换为你自己的虚拟机的名字

在dos模式下进入VirtualBox安装目录，默认为C:\Program Files\Oracle\VirtualBox，执行如下命令
```
# VBoxManage setextradata "VM name" "CustomVideoMode1" "480x800x16" 
# VBoxManage setextradata "VM name" "CustomVideoMode2" "320x480x16"
```

#### 2、修改grub的menu.lst

启动虚拟机，到debug mode下

以 RW 模式重新挂载分区
```
# mount -o remount,rw /mnt
```

编辑文件：
```
# vi /mnt/grub/menu.lst
```

如果是手机分辨率则复制MDPI的几行，平板分辨率则复制HDPI的内容。把title改为自己想要的启动项名字，如“Android-x86 480×800x16”，在“kernel”后加上：
```
UVESA_MODE=480x800
```
320×480的分辨率也类似进行。

#### 3、在debug mode下重启Android-x86

运行命令
```
# /system/bin/reboot
```
即可

### 五、配置eclipse允许使用虚拟机远程调试开发

#### 1、查询ip地址

进入cosole模式，使用netcfg或ip命令查询虚拟机的ip地址：

其中eth0表示虚拟机的网络设备，后面的ip地址即为虚拟机的ip地址。

#### 2、配置eclipse

使用Alt+F7返回图形界面。

打开eclipse，进入android开发插件的设定界面,选择ddms,勾选 Use ado host, 并在ADT host value 一栏填写虚拟机的ip地址,具体界面请参看下图：

打开devices视图，如果未加载devices视图，可以使用如下方法打开devices视图

在devices视图中选择重启adb：

或者也可以使用命令行重启adb，新版的adb命令位于platform-tools目录下：
```
# adb kill-server # adb start-server
```

重新启动后可以看到虚拟机设备已经在列表中了

#### 3、配置项目run或debug参数

运行或调试程序时就可以选择虚拟机作为调试设备了

如果eclipse找不到虚拟机设备，请检查系统是否安装豌豆荚等android连接程序，如果安装需要停止相关进程。

### 六、配置SD卡

配置SD卡可以使用多种方式。

#### 1、将文件伪装成 SD 卡

在console模式下执行如下脚本：
```
# dd if=/dev/zero of=/data/sdcard.img bs=1024 count=65536 
# losetup /dev/block/loop7 /data/sdcard.img 
# newfs_msdos /dev/block/loop7
```

其中65536表示64MB的SD卡，可以修改此数字增大SD卡大小

重新启动虚拟机进入debug模式，以 RW 模式重新挂载分区
```
# mount -o remount,rw /mnt
```

编辑文件：
```
# vi /mnt/grub/menu.lst
```

向 kernel 中添加一个参数：
```
SDCARD=/data/sdcard.img
```

#### 2、使用独立的分区

首先需要在 VirtualBox 中创建一个新的硬盘，然后将其配属给 VM：

然后以debug模式启动 VM，新建的分区默认挂载为/dev/sdb文件

创建分区前可以查询分区情况：
```
# fdisk -l /dev/sdb
```

使用 fdisk 创建一个新的分区。分区创建完成后，对它进行格式化：
```
# fdisk /dev/sdb
```

该命令后续操作包含如下参数：

 -   输入 m 显示所有命令列示。
 -   输入 p 显示硬盘分割情形。
 -   输入 a 设定硬盘启动区。
 -   输入 n 设定新的硬盘分割区。
 -   输入 e 硬盘为[延伸]分割区(extend)。
 -   输入 p 硬盘为[主要]分割区(primary)。
 -   输入 t 改变硬盘分割区属性。
 -   输入 d 删除硬盘分割区属性。
 -   输入 q 结束不存入硬盘分割区属性。
 -   输入 w 结束并写入硬盘分割区属性
 -   输入 n 开始创建分区
 -   输入 p 创建主分区

此步骤询问分区的序列号，因为sdb还没有分区，因此可以选择1

输入开始的块地址，默认即可

设置结束的块地址，该地址决定分区的大小，具体可以根据分区总大小以及此处提供的块数量

输入w写入分区并退出。

使用fat32位格式化分区：
```
# newfs_msdos /dev/sdb1
```

编辑 menu.lst 文件
```
# vi /mnt/grub/menu.lst
```

添加kernel参数：
```
SDCARD=sdb1
```

### 七、安装应用

#### 1、安装应用

如果未连接设备，可以在物理主机的命令行模式下使用如下命令连接
```
# adb connect 192.168.11.12
```

可以使用如下命令安装apk：
```
# adb install -r HelloWorld.apk
```

但有时安装的时候报如下错误：
```
more than one device and emulator
```
可以使用如下方法：

查找设备：
```
# adb devices 
List of devices attached
emulator-5554 device
```

安装
```
# adb -s emulator-5554 install -r HelloWorld.apk
```
 
#### 2、卸载
```
adb uninstall HelloWorld.apk
```

或者直接删除文件
```
# adb -s emulator-5554 shell 
# cd /data/app 
# rm HelloWorld.apk 
# exit
```

删除系统应用：
```
adb remount （重新挂载系统分区，使系统分区重新可写）。
adb shell
cd system/app
rm *.apk
```

原文链接：http://www.cnblogs.com/gao241/archive/2013/03/11/2953669.html
