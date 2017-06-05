---
layout:     post
title:      "【记录】Ubuntu 16.04安装中文输入法"
date:       2017-06-04 23:29:25 +0800
categories: 技术
tags: ["记录",Ubuntu]
---
在网上找到这个步骤：

1 在桌面右上角设置图标中找到“System Setting”，双击打开。

2 在打开的窗口里找到“Language Support”，双击打开。

3 可能打开会说没有安装“Language Support”，这时只需要授权安装即可

4 安装完成之后，选择“Install/Remove Languages”，在弹出的窗口选择“Chinese simplified”，点击“Apply Changes”即可。

5 之后需要输入密码授权，系统会安装简体中文语言包。

6 安装IBus框架，在终端输入以下命令：
```
sudo apt-get install ibus ibus-clutter ibus-gtk ibus-gtk3 ibus-qt4
```
7 启动IBus框架，在终端输入命令：`im-switch -s ibus`。

注：没有这个命令，但有`im-config`这个命令

8 安装拼音引擎，在终端输入命令：`sudo apt-get install ibus-pinyin`，即可安装拼音。

9 设置IBus框架，在终端输入命令：`ibus-setup`，在出现的窗口选择Input Method，之后选择拼音输入法即可。

注：在这个步骤找不到中文输入法的选项，后来重新启动之后出现了

10 点击桌面右上角输入法图标，选择“Text Entry Settings”，点击左下角的“+”，把“Chinese(Pinyin)”加入，完成
