---
layout:     post
title:      "【收藏】自己修改编译ubuntu终端"
date:       2017-05-22 22:22:06 +0800
author:     "Clean Li"
categories: 技术
tags: ["收藏",Ubuntu]
header-img: "img/post-bg-01.jpg"
---

从一个论坛看到修改编译ubuntu终端的方法，收藏一下。

 1 Download the gnome-terminal source package
```console
$ apt-get source gnome-terminal
```
 2 Install the build dependencies required for gnome-terminal
```console
$ sudo apt-get build-dep gnome-terminal
```
 3 Rollback the change below

<https://github.com/GNOME/gnome-terminal/commit/468a18f5e21b42ee0efedf3d86203fbc4e02807eo>

 4 Repackage the source code
```console
$ tar zcf gnome-terminal_3.14.2.orig.tar.gz gnome-terminal-3.14.2
```
 5 Build new gnome-terminal package
```console
$ debuild -b
```
 6 Install the new gnome-terminal package
```console
$ sudo dpkg -i gnome-terminal_xxx.deb
```
 
源文档 <https://askubuntu.com/questions/620061/gnome-terminal-multi-tab-title-position>
