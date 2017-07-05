---
layout:     post
title:      "【转载】Android属性（property）机制"
date:       2016-06-01 00:00:00 +0800
author:     "Clean Li"
categories: 技术
tags: ["转载",Android]
header-img: "img/post-bg-01.jpg"
---

### 1. 属性简介

Android里有很多属性（property），每个属性都有一个名称和值，他们都是字符串格式。这些属性定义了Android系统的一些公共系统属性。比如：
```
[dalvik.vm.dexopt-flags]: [m=y]

[dalvik.vm.heapgrowthlimit]: [48m]

[gsm.operator.iso-country]: []

[gsm.operator.isroaming]: [false]

[gsm.operator.numeric]: []

[gsm.sim.operator.alpha]: []

[gsm.sim.operator.iso-country]: []

[gsm.sim.operator.numeric]: []
```

这些属性多数是开机启动时预先设定的，也有一些是动态加载的。

系统启动时以下面的次序加载预先设定属性：

```
/default.prop

/system/build.prop

/system/default.prop

/data/local.prop

/data/property/*

```
后加载的如果有重名的则覆盖前面的。

有两种属性值得一提：

```
persist.* : 以persist开始的属性会在/data/property存一个副本。也就是说，如果程序调property_set设了一个以persist为前缀的属性，系统会在/data/property/*里加一个文件记录这个属性，重启以后这个属性还有。如果property_set其它属性，因为属性是在内存里存，所以重启后这个属性就没有了。

ro.* :以ro为前缀的属性不能修改。
```

### 2. 应用程序属性使用方法

在java应用里设置属性：

```java
import android.os.SystemProperties;

SystemProperties.set("persist.sys.country",”china”);

```
在java里取得属性：

```java
String vmHeapSize = SystemProperties.get("dalvik.vm.heapgrowthlimit", "24m");

```
也可以用SystemProperties.getBoolean，getInt等。
 

在native C中设置属性：

```cpp
#include "cutils/properties.h"

property_set("vold.decrypt", "trigger_load_persist_props");

```
在C中取得属性：

```c
 char encrypted_state[32];

 property_get("ro.crypto.state", encrypted_state, "");

```
最后一个参数是默认值。

 

### 3. 启动脚本中属性使用方法

一般property启动应该加在`init.<your hardware>.rc`而不是直接init.rc里。下面是一个init.rc里的例子：

```
# adbd on at boot in emulator

on property:ro.kernel.qemu=1

start adbd

```
意思是如果ro.kernel.qemu=1，也就是当前是模拟器的话，则启动adb服务。

 

### 4. property权限

只有有权限的进程才能修改属性，要不随便写一个就改系统属性那当黑客也太容易了。

权限在`system/core/init/property_service.c`里定义：

```
property_perms[] = {

   { "net.rmnet0.",     AID_RADIO,   0 },

   { "net.gprs.",       AID_RADIO,   0 },

   { "net.ppp",         AID_RADIO,   0 },

   { "net.qmi",         AID_RADIO,   0 },

   { "ril.",            AID_RADIO,   0 },

   { "gsm.",            AID_RADIO,   0 },

   { "persist.radio",   AID_RADIO,   0 },

   { "net.dns",         AID_RADIO,   0 },

   { "net.",            AID_SYSTEM,  0 },

   { "dev.",            AID_SYSTEM,  0 },

   { "runtime.",        AID_SYSTEM,  0 },

   { "hw.",             AID_SYSTEM,  0 },

   { "sys.",            AID_SYSTEM,  0 },

   ...

```
其实一般应用程序都不会去修改系统属性，所以也不用太在意。


### 5. 属性实现原理

属性初始化的入口点是`property_init` ，在`system/core/init/property_service.c`中定义。它的主要工作是申请32k共享内存，其中前1k是属性区的头，后面31k可以存247个属性（受前1k头的限制）。`property_init`初始化完property以后，加载/default.prop的属性定义。

其它的系统属性（build.prop, local.prop,…）在`start_property_service`中加载。加载完属性服务创建一个socket和其他进程通信（设置或读取属性）。

Init进程poll属性的socket，等待和处理属性请求。如果有请求到来，则调用`handle_property_set_fd`来处理这个请求。在这个函数里，首先检查请求者的uid/gid看看是否有权限，如果有权限则调`property_service.c`中的`property_set`函数。

在`property_set`函数中，它先查找就没有这个属性，如果找到，更改属性。如果找不到，则添加新属性。更改时还会判断是不是“ro”属性，如果是，则不能更改。如果是persist的话还会写到`/data/property/<name>`中。

最后它会调`property_changed`，把事件挂到队列里，如果有人注册这个属性的话（比如init.rc中on property:ro.kernel.qemu=1），最终会调它的会调函数。

property名字长度限制是32字节，值的限制是92字节。不知道是google怎么想的 — 一般都是名字比值长得多！比如`[dalvik.vm.heapgrowthlimit]: [48m]`
