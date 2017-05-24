---
layout:     post
title:      "Ubuntu16.04下设置终端的标题"
date:       2017-05-19 14:06:25 +0800
author:     "Clean Li"
categories: tech
tags: [Ubuntu,Terminal]
header-img: "img/post-bg-03.jpg"
---

以前旧版本的Ubuntu下的终端可以右键在标题栏上点击，菜单里就有一项可以改终端的标题。在Ubuntu 16.04下发现竟然没有这一项了。在网上找了一下，发现原来是可以在终端里面使用命令改的。方法是在Home目录的`.bashrc`里面加上如下代码：
```shell
st ()
{
        echo
        if [ -z "$ORIG" ]; then
                ORIG=$PS1
        fi
        TITLE="\[\e]2;$*\a\]"
        PS1=${ORIG}${TITLE}
}
```
然后，在终端里面输入命令：
```console
$ st NewTitle
```
就可以看到标题已经改成“NewTitle”了。

源文档 <https://askubuntu.com/questions/774532/how-to-change-terminal-title-in-ubuntu-16-04>
