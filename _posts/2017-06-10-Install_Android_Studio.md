---
layout:     post
title:      "【记录】Ubuntu 16.04安装Android Studio"
date:       2017-06-10 07:44:26 +0800
categories: 技术
tags: ["记录",Ubuntu,Android]
---
从这个地方下载android-studio-ide-162.4069837-linux.zip：<br>
[Android studio 2.2.3 下载地址](https://developer.android.google.cn/studio/index.html)

目前这个页面国内可以访问，可参考这个页面进行安装：<br>
[Install Android Studio](https://developer.android.google.cn/studio/install.html)

下载后解压并将其移动到 /opt 文件夹下
```
$ sudo mv android-studio /opt
```

按照Guide提示，安装必要的库：
```
sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386
```

然后进入 android-studio 的 bin目录下并运行 studio.sh
```
$ cd /opt
$ cd android-studio/bin/
$ ./studio.sh 
```
遇到error，`Unable to access Android SDK add-on list`，点Cancle继续。

下载，`Downloading Components`

点击菜单栏的 Tools -> Create Desktop Entry 建立桌面快捷方式

完成～
