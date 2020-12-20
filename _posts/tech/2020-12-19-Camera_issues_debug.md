---
layout: post
title: "【原创】Camera一些问题记录"
date: 2020-12-19 15:06:59 +0800
categories: "技术"
tags: ["原创","Camera","Android"]
---
最近有一些变动，不知道将来是否还会做camera开发。在这里记录一些camera问题。

#### 前置camera打不开
高通770平台。log中发现有i2c error。经过调整i2c clock，以及进行retry都无法解决。于是写测试脚本进行专门前置camera开关测试，却发现无法复现。推测可能与使用camera操作的顺序有关，这可能是由于操作之间没有同步造成的。查看`cam_cci_core.c`文件，`cam_cci_core_cfg`这个函数会进行i2c操作的判断，在此函数进出加上log，发现出问题前两个camera的`MSM_CCI_INIT`操作和`MSM_CCI_I2C_WRITE`有重叠的情况，于是在`cam_cci_core_cfg`进出时加锁，问题解决。

---
#### 双camera切换到另一camera，拍照无法闪光
高通770平台。在code中查找闪光灯的控制相关的代码，在`camx/src/swl/sensor/camxsensormode.cpp`，发现此camera没有做flash的init。最后发现根本原因是dts文件没有设置正确，两个camera使用相同的flash，所以应该设成一样的flash。

---
#### 双camera切换时，会发生卡顿
高通770平台。更新vendor的camera sensor setting后解决

---
#### 双camera做zoom时，会出现preview画面跳两次
高通770平台。在引入camera sensor的LPM（Low Power Mode）之后出现的，原因是当app发zoom下来需要切换到处于LPM的camera时，只能先在正在使用的camera上先做zoom，同时唤起另一camera，等另一个camera起来之后，再切到这个camera的zoom，这样就跳两次。解决办法时与app配合，让驱动先唤起LPM的camera，然后再下zoom参数。

---
#### 退出Camera时卡住，无法再打开camera
高通845平台。发现卡在kernel部分的`cam_flash_core.c`的`cam_flash_shutdown`函数，其中code在某个条件下会试图获取一个mutex锁，而在call这个函数的`cam_flash_subdev_close`中，已经持有这把锁，因此发生了死锁。

解决办法是在`cam_flash_shutdown`中去掉多余的锁。这个问题在后续的qcom代码升级中有fix。

---
#### CTS testFlashTurnOff fail
高通630升级Q。默认当AE=ON时，此时自动曝光逻辑控制flash，不接受framework的参数。CTS测试时会同时发AE=OFF和flash参数，所以这时flash参数就无效。需要增加一套逻辑来判断是否需要接受flash参数。

---
#### CTS testAntibandingMode fail
高通630升级Q。当framework设置Antibanding为Auto时，查询状态，HAL会反馈真实的Antibanding参数，比如“50Hz”。修改返回“Auto”就好。

---
#### 录像拍照出现绿色照片
高通8998。做workaround，检测是否绿色yuv图像（全零），如果是，则从preview channel（size和video一样）copy一帧图像覆盖绿色图像。

---
#### 录像中某一帧出现花屏
高通8998。看现象很象是yuvimage的wxh不匹配。因为录像有做防抖功能，将原来大size的图像切割边缘变小size。于是取出问题帧，用工具设置成大size（出来的录像文件是小size），显示正常。确认是size不正确后，查看代码，发现做防抖处理的部分有判断条件调用qcom的`getOldestFrameNumber`，这个函数逻辑有问题，修复后解决。

---
#### camera预览画面卡住
高通630升级P。在`mm-camera-interface`里面打开Qbuf、DQbuf的log，发现问题出现时，除了一个buffer，其他buffer都从kernel上来了。在QCamera3Channel.cpp中，回调函数streamCbRoutine为了保证出来的frames按顺序输出，会对frame number判断，如果有以前的frame没有上来，会缓存当前帧，等以前的frame来了之后，再一起返回framework层。但如果出现有一个frame卡在kernel不能回来到HAL，那其他的帧就会被缓存在HAL的streamCbRoutine函数，没有frame送回framework，framework就不会再发request下来，所以preview就卡住了。一个解决办法是在kernel把卡住的frame送回HAL，另外就是在HAL释放缓存的frame。
