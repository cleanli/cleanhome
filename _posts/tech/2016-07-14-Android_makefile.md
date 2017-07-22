---
layout:     post
title:      "【收藏】Android Makefile"
date:       2016-07-14 00:00:00 +0800
categories: 技术
tags: ["收藏",Android,Makefile]
header-img: "img/post-bg-01.jpg"
---
#### 两个变量区别
`LOCAL_EXPORT_C_INCLUDE_DIRS` 和 `LOCAL_EXPORT_C_INCLUDES` 有啥區別
```
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_EXPORT_C_INCLUDES)
```


#### 模块编译版本
LOCAL_MODULE_TAGS :=user eng tests optional

user: 指该模块只在user版本下才编译

eng: 指该模块只在eng版本下才编译

tests: 指该模块只在tests版本下才编译

optional:指该模块在所有版本下都编译



#### 编译Android 
在Android源码根目录下，执行以下三步即可编译android:
1.  build/envsetup.sh #这个脚本用来设置android的编译环境;
2.  lunch  #选择编译目标
3. make   #编译android整个系统

android平台提供了三个命令用于编译，这3个命令分别为：
1. make: 不带任何参数则是编译整个系统；<br>
  make MediaProvider： 单个模块编译，会把该模块及其依赖的其他模块一起编译(会搜索整个源代码来定位MediaProvider模块所使用的Android.mk文件，还要判断该模块依赖的其他模块是否有修改)；
2. mmm packages/providers/MediaProvider: 编译指定目录下的模块，但不编译它所依赖的其它模块；
3. mm: 编译当前目录下的模块，它和mmm一样，不编译依赖模块;
4. mma: 编译当前目录下的模块及其依赖项
  以上三个命令都可以用-B选项来重新编译所有目标文件。


#### put the file to the final system.img
1 `PRODUCT_COPY_FILES`

第一种情况，可以修改device.mk中的`PRODUCT_COPY_FILES`，这里用android4.0中自带的device/ti/panda来修改。

在device/ti/panda增加已经自己的文件夹，并且把需要打包的文件，拷贝到文件夹下：

```
    root@xxx:/mnt/ics-android/ics-src/device/ti/panda# ls my/*  
    my/app:  
    my.apk  
      
    my/bin:  
    my.sh  
      
    my/fonts:  
      
    my/lib:  
    libmy.so  
```

这里在device/ti/panda下增加了一个文件夹my，并且在my下面增加了app、bin、fonts、lib，对应out/target/product/panda/system下面的目录，在device.mk的最后增加：

```
    PRODUCT_COPY_FILES += \  
        device/ti/panda/my/app/my.apk:system/app/my.apk \  
        device/ti/panda/my/bin/my.sh:system/bin/my.sh \  
        device/ti/panda/my/lib/libmy.so:system/lib/libmy.so  
```

2 `PRODUCT_PACKAGES`

第二种情况，同样需要修改device.mk，把需要打包的文件添加到变量`PRODUCT_PACKAGES`中：

```
    PRODUCT_PACKAGES += \  
        libmy \  
        my  
```

注意这里的名字要求和模块的Android.mk中，指定生成的文件名称相同，例如
```
LOCAL_MODULE:= libmy
```
或者
```
LOCAL_PACKAGE_NAME := my
```

同时，还要求模块的Android.mk中变量`LOCAL_MODULE_TAGS值`为optional
```
LOCAL_MODULE_TAGS := optional
```

#### Makefile中指示符“include”、“-include”和“sinclude”的区别

指示符“include”、“-include”和“sinclude”

如果指示符“include”指定的文件不是以斜线开始（绝对路径，如/usr/src/Makefile...），而且当前目录下也不存在此文件；make将根据文件名试图在以下几个目录下查找：首先，查找使用命令行选项“-I”或者“--include-dir”指定的目录，如果找到指定的文件，则使用这个文件；否则继续依此搜索以下几个目录（如果其存在）：“/usr/gnu/include”、“/usr/local/include”和“/usr/include”。

当在这些目录下都没有找到“include”指定的文件时，make将会提示一个包含文件未找到的告警提示，但是不会立刻退出。而是继续处理Makefile的后续内容。当完成读取整个Makefile后，make将试图使用规则来创建通过指示符“include”指定的但未找到的文件，当不能创建它时（没有创建这个文件的规则），make将提示致命错误并退出。会输出类似如下错误提示：
```
Makefile:错误的行数：未找到文件名：提示信息（No such file or directory）
Make： *** No rule to make target ‘’. Stop
```
通常我们在Makefile中可使用“-include”来代替“include”，来忽略由于包含文件不存在或者无法创建时的错误提示（“-”的意思是告诉make，忽略此操作的错误。make继续执行）。像下边那样：
```
-include FILENAMES...
```
使用这种方式时，当所要包含的文件不存在时不会有错误提示、make也不会退出；除此之外，和第一种方式效果相同。以下是这两种方式的比较：

使用“include FILENAMES...”，make程序处理时，如果“FILENAMES”列表中的任何一个文件不能正常读取而且不存在一个创建此文件的规则时make程序将会提示错误并退出。

使用“-include FILENAMES...”的情况是，当所包含的文件不存在或者不存在一个规则去创建它，make程序会继续执行，只有真正由于不能正确完成终极目标的重建时（某些必需的目标无法在当前已读取的makefile文件内容中找到正确的重建规则），才会提示致命错误并退出。

为了和其它的make程序进行兼容。也可以使用“sinclude”来代替“-include”（GNU所支持的方式）。

#### Makefile输出打印信息
1、输出打印信息的方法是：$(warning xxxxx)，$(error xxxxx)

2、输出打印变量值的方法是：$(warning  $(XXX))

这个和$(wildcard）一样的。

注：原转载于为知笔记
