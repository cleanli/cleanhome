---
layout:     post
title:      "【转载】Windows shutdown command"
date:       2017-05-22 22:47:24 +0800
categories: tech
header-img: "img/post-bg-04.jpg"
---

#### 一些关机命令 shutdown的使用实例

---
```bat
shutdown -s
```
自动关机 

---

```bat
shutdown -a
```
取消自动关机

---

```bat
shutdown -s -t 360
```
解释：360秒后关机，会出现关机倒计时界面（t 指的是时间）

---

```bat
at 23:30 shutdown -s
```
解释：系统将在23:30自动关机，`shutdown -s`指关机，`at 23:30`指在23:30<br>
at命令使用条件：必须开启Task scheduler服务。开启的方法在命令界面输入


```bat
net start schedule
```
关闭输入
```bat
net stop schedule
```

---

```bat
shutdown -r
```
解释：关机重启，如果你正在使用电脑 请慎用。

---

```bat
at 23:30 Shutdown -s -c 系统挂机了，注意休息
```
解释：-c 可以输入说明文字<br>
我们可以把这个命令写到文本文档中，让后把文本改成批量处理文件。让后把这个批处理文件放到“开始-运行-启动”中，电脑就会在每天23：30自动关机了。
 
源文档 <https://jingyan.baidu.com/article/49ad8bce705f3f5834d8faec.html>
