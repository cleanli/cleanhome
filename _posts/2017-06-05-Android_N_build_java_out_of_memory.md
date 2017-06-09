---
layout:     post
title:      "【记录】编译测试Android nougat-x86"
date:       2017-06-09 23:17:14 +0800
categories: 技术
tags: ["记录",Android]
---
## 一、获取源码
因为国内无法访问Google官网，在这个地方可以下载Android源码：[清华大学开源软件镜像站AOSP](https://mirrors.tuna.tsinghua.edu.cn/help/AOSP/)

按其提示的方法，为避免直接repo sync太慢，先直接下载[aosp-latest.tar](https://mirrors.tuna.tsinghua.edu.cn/aosp-monthly/aosp-latest.tar)，解压得到`.repo`目录，然后再运行：
```console
$ repo init -u http://scm.osdn.net/gitroot/android-x86/manifest -b
```
此时不能`repo sync`，因为无法从google直接下载code，打开`.repo/manifest.xml`，作如下改动：
```
 <manifest>
 
   <remote  name="aosp"
-           fetch="https://android.googlesource.com/" />
+           fetch="https://aosp.tuna.tsinghua.edu.cn/" />
   <remote  name="x86"
            fetch="." />
   <default revision="refs/tags/android-7.1.2_r11"
```
再sync就可以了
```
$ repo sync --no-tags --no-clone-bundle -j4
```

## 二、编译
### Build command
```console
$ . build/envsetup.sh 
including device/generic/x86_64/vendorsetup.sh
including device/generic/x86/vendorsetup.sh
including sdk/bash_completion/adb.bash

$ lunch

You're building on Linux

Lunch menu... pick a combo:
     1. aosp_arm-eng
     2. aosp_arm64-eng
     3. aosp_mips-eng
     4. aosp_mips64-eng
     5. aosp_x86-eng
     6. aosp_x86_64-eng
     7. android_x86_64-eng
     8. android_x86_64-userdebug
     9. android_x86_64-user
     10. android_x86-eng
     11. android_x86-userdebug
     12. android_x86-user

Which would you like? [aosp_arm-eng] 10

============================================
PLATFORM_VERSION_CODENAME=REL
PLATFORM_VERSION=7.1.2
TARGET_PRODUCT=android_x86
TARGET_BUILD_VARIANT=eng
TARGET_BUILD_TYPE=release
TARGET_BUILD_APPS=
TARGET_ARCH=x86
TARGET_ARCH_VARIANT=x86
TARGET_CPU_VARIANT=
TARGET_2ND_ARCH=
TARGET_2ND_ARCH_VARIANT=
TARGET_2ND_CPU_VARIANT=
HOST_ARCH=x86_64
HOST_2ND_ARCH=x86
HOST_OS=linux
HOST_OS_EXTRA=Linux-4.4.0-31-generic-x86_64-with-Ubuntu-16.04-xenial
HOST_CROSS_OS=windows
HOST_CROSS_ARCH=x86
HOST_CROSS_2ND_ARCH=x86_64
HOST_BUILD_TYPE=release
BUILD_ID=NHG47L
OUT_DIR=out
============================================

$ make iso_img -j4

```

### Build Error and Solution
#### ---- Met error: Out of memory error
```
[ 33% 12328/36270] Building with Jack: out/target/common/obj/JAVA_LIBRARIES/core-oj_intermediates/dex-dir/classes.dex
FAILED: /bin/bash out/target/common/obj/JAVA_LIBRARIES/core-oj_intermediates/dex-dir/classes.dex.rsp
Out of memory error (version 1.2-rc4 'Carnac' (298900 f95d7bdecfceb327f9d201a1348397ed8a843843 by android-jack-team@google.com)).
Java heap space.
Try increasing heap size with java option '-Xmx<size>'.
Warning: This may have produced partial or corrupted output.
[ 33% 12331/36270] Building with Jack: out/target/common/obj/JAVA_LIBRARIES/libprotobuf-java-micro_intermediates/classes.jack
ninja: build stopped: subcommand failed.
build/core/ninja.mk:142: recipe for target 'ninja_wrapper' failed
make: *** [ninja_wrapper] Error 1

#### make failed to build some targets (01:04:39 (hh:mm:ss)) ####
```

__Solution:__
Found solution here:
[Android N 遇到Try increasing heap size with java option ](http://blog.csdn.net/zxf20063033/article/details/56296403)

```console
clean@M$ export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4g"
clean@M$ ./prebuilts/sdk/tools/jack-admin kill-server
Killing background server
clean@M$ ./prebuilts/sdk/tools/jack-admin start-server
Launching Jack server java -XX:MaxJavaStackTraceDepth=-1 -Djava.io.tmpdir=/tmp -Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4g -cp /home/clean/.jack-server/launcher.jar com.android.jack.launcher.ServerLauncher
```
<br>
#### ---- Met error: No module named mako.template
```
FAILED: /bin/bash -c "python external/mesa/src/compiler/glsl/ir_expression_operation.py strings > out/target/product/x86/gen/STATIC_LIBRARIES/libmesa_glsl_intermediates/glsl/ir_expression_operation_strings.h"
Traceback (most recent call last):
  File "external/mesa/src/compiler/glsl/ir_expression_operation.py", line 23, in <module>
    import mako.template
ImportError: No module named mako.template
ninja: build stopped: subcommand failed.
build/core/ninja.mk:148: recipe for target 'ninja_wrapper' failed
make: *** [ninja_wrapper] Error 1
```

__Solution:__
```
$ sudo apt-get install python-mako
```

<br>
#### ---- Met Message: no isohybird
```
/bin/bash: isohybrid: command not found
isohybrid not found.
Install syslinux 4.0 or higher if you want to build a usb bootable iso.


out/target/product/x86/android_x86.iso is built successfully.
```

__Solution:__
```
$ sudo apt-get install syslinux-utils
```

<br>
#### ---- Met Error: isolinux.bin missing or corrupt
Get this error message when test the boot image with USB stick.

__Solution:__
You may need to use the following command
```
sudo dd if=linux.iso of=/dev/sdb
```
instead of
```
sudo dd if=linux.iso of=/dev/sdb1
```

## 三、测试
使用Virtual Box虚拟机测试，可以启动。

使用U盘作启动盘，也可以成功启动。在真实电脑上还可以插入USB摄像头，可以使用camera应用。
