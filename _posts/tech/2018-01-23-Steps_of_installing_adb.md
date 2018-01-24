---
layout: post
title: "【记录】Win8安装adb"
date: 2018-01-23 22:45:39 +0800
categories: "技术"
tags: ["记录","Android"]
---
记录一下win8安装adb的步骤。

#### 一、下载

从Android官网下载两个文件：

adb的驱动包：`latest_usb_driver_windows.zip`

adb的软件包：`platform-tools-latest-windows.zip`

官方下载为Google：

[`https://dl-ssl.google.com/android/repository/latest_usb_driver_windows.zip`](https://dl-ssl.google.com/android/repository/latest_usb_driver_windows.zip)

[`https://dl.google.com/android/repository/platform-tools-latest-windows.zip`](https://dl.google.com/android/repository/platform-tools-latest-windows.zip)

本地下载：

[latest\_usb\_driver\_windows.zip](http://cleanli.github.io/osdegd/downloads/soft/adb/latest_usb_driver_windows.zip)<br>
[platform-tools-latest-windows.zip](http://cleanli.github.io/osdegd/downloads/soft/adb/platform-tools-latest-windows.zip)

#### 二、adb软件包安装

把adb的软件包解压到一个目录，这里解压到`C:\g\adb\adb-platform-tools`

在“我的电脑”图标右键，选择“属性”，选“高级系统设置”-“高级”-“环境变量”

![图片]({{ site.baseurl }}/images/adb_inst/sysprop.png)<br>
添加一个变量`adb_path`为刚才adb软件所在的目录

![图片]({{ site.baseurl }}/images/adb_inst/adbpath.png)<br>
把该目录变量`%adb_path%`加入电脑的Path环境变量

![图片]({{ site.baseurl }}/images/adb_inst/path.png)<br>
设置好后，打开cmd窗口就可以使用adb了

#### 三、安装adb驱动

连接手机到电脑，手机打开adb调试选项。如果没有adb调试选项，要在手机的“设置”-“关于”-“软件信息”-“更多”-“内部版本号”上多次点击，直到出现“你已经成为开发人员”的提示。返回到设置界面，会出现“开发人员选项”，勾选“USB调试”，手机adb调试选项就打开了。

打开设备管理器，找到“其他设备”-“Android Phone”，右键“更新驱动程序软件”

![图片]({{ site.baseurl }}/images/adb_inst/updatedrv.png)<br>
选“浏览计算机以查找驱动程序软件”

![图片]({{ site.baseurl }}/images/adb_inst/drv2.png)<br>
“从计算机的设备驱动程序列表中选取”

![图片]({{ site.baseurl }}/images/adb_inst/drv3.png)<br>
“下一步”

![图片]({{ site.baseurl }}/images/adb_inst/drv4.png)<br>
出现“Generic Usb Hub”，点“从磁盘安装”

![图片]({{ site.baseurl }}/images/adb_inst/drv5.png)<br>
选择刚刚adb驱动包解压出来的目录下的`usb_driver`，再点选`android_winusb.inf`，确定

![图片]({{ site.baseurl }}/images/adb_inst/drv6.png)<br>
出现三个Android的型号，点“下一步”

![图片]({{ site.baseurl }}/images/adb_inst/three_type.png)<br>
出现警告，确定安装

![图片]({{ site.baseurl }}/images/adb_inst/warn.png)<br>
![图片]({{ site.baseurl }}/images/adb_inst/warn2.png)<br>
adb驱动就安装好了。

![图片]({{ site.baseurl }}/images/adb_inst/drvok.png)<br>
