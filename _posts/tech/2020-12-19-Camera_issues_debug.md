---
layout: post
title: "【原创】Camera总结之一：问题记录"
date: 2020-12-19 15:06:59 +0800
categories: "技术"
tags: ["原创","Camera","Android"]
---
最近有一些变动，不知道将来是否还会做camera开发，所以打算做一些camera的总结文章，以便将来需要的时候再学习。在这里先记录总结一些camera问题。

#### 前置camera打不开
高通CHI架构。log中发现有i2c error。经过调整i2c clock，以及进行retry都无法解决。于是写测试脚本进行专门前置camera开关测试，却发现无法复现。推测可能与使用camera操作的顺序有关，这可能是由于操作之间没有同步造成的。查看kernel部分i2c驱动`cam_cci_core.c`文件，`cam_cci_core_cfg`这个函数会进行i2c操作的判断，在此函数进出加上log，发现出问题前两个camera的`MSM_CCI_INIT`操作和`MSM_CCI_I2C_WRITE`有重叠的情况，于是在`cam_cci_core_cfg`进出时加锁，问题解决。

---
#### 双camera切换到另一camera，拍照无法闪光
高通CHI架构。在code中查找闪光灯的控制相关的代码，在`camx/src/swl/sensor/camxsensormode.cpp`，发现此camera没有做flash的init。最后发现根本原因是dts文件没有设置正确，两个camera使用相同的flash，所以应该设成一样的flash。

---
#### 双camera作SAT切换时，会发生卡顿
高通CHI架构。更新vendor的camera sensor setting后解决

---
#### 双camera做zoom时，会出现preview画面跳两次
高通CHI架构。在引入camera sensor的LPM（Low Power Mode）之后出现的，原因是当app发zoom下来需要切换到处于LPM的camera时，只能先在正在使用的camera上先做zoom，同时唤起另一camera，等另一个camera起来之后，再切到这个camera的zoom，这样就跳两次。解决办法时与app配合，让驱动先唤起LPM的camera，然后再下zoom参数。

---
#### 退出Camera时卡住，无法再打开camera
高通CHI架构。发现卡在kernel部分的`cam_flash_core.c`的`cam_flash_shutdown`函数，其中code在某个条件下会试图获取一个mutex锁，而在call这个函数的`cam_flash_subdev_close`中，已经持有这把锁，因此发生了死锁。

解决办法是在`cam_flash_shutdown`中去掉多余的锁。这个问题在后续的qcom代码升级中有fix。

---
#### CTS testFlashTurnOff fail
高通mm-camera架构升级Q。默认当AE=ON时，此时自动曝光逻辑控制flash，不接受framework的参数。CTS测试时会同时发AE=OFF和flash参数，所以这时flash参数就无效。需要增加一套逻辑来判断是否需要接受flash参数。

---
#### CTS testAntibandingMode fail
高通mm-camera架构升级Q。当framework设置Antibanding为Auto时，查询状态，HAL会反馈真实的Antibanding参数，比如“50Hz”。修改返回“Auto”就好。

---
#### 录像拍照出现绿色照片
高通mm-camera架构。做workaround，检测是否绿色yuv图像（全零），如果是，则从preview channel（size和video一样）copy一帧图像覆盖绿色图像。

---
#### 录像中某一帧出现花屏
高通mm-camera架构。看现象很象是yuvimage的wxh不匹配。因为录像有做防抖功能，将原来大size的图像切割边缘变小size。于是取出问题帧，用工具设置成大size（出来的录像文件是小size），显示正常。确认是size不正确后，查看代码，发现做防抖处理的部分有判断条件调用qcom的`getOldestFrameNumber`获取最早的frameNumber与当前的来的帧号比较，如果一致才做切割。而这个函数逻辑在某些情况下会错误的返回oldest为-1导致不做crop，这一帧就出现问题。修复后解决。

下面code来自[androidos.net.cn:QCamera3Mem.cpp](https://www.androidos.net.cn/android/9.0.0_r8/xref/device/google/marlin/camera/QCamera2/HAL3/QCamera3Mem.cpp)

```cpp
int32_t QCamera3HeapMemory::getOldestFrameNumber(uint32_t &bufIndex)
{
    Mutex::Autolock lock(mLock);

    int32_t oldest = INT_MAX;
    bool empty = true;

    for (uint32_t index = 0;
            index < mBufferCount; index++) {
        if (mMemInfo[index].handle) {
-            if ((empty) || (!empty && oldest > mCurrentFrameNumbers[index]
-                && mCurrentFrameNumbers[index] != -1)) {
+            if ((empty || (!empty && oldest > mCurrentFrameNumbers[index])) //Modification, when mCurrentFrameNumbers[0] == -1
+                && (mCurrentFrameNumbers[index] != -1)) {
                oldest = mCurrentFrameNumbers[index];
                bufIndex = index;
            }
            empty = false;
        }
    }
+   //Modification, keep same behavior when all mCurrentFrameNumbers[i] == -1
+   if(INT_MAX == oldest){
+       oldest = -1;
+   }
+   //Modification
    if (empty)
        return -1;
    else
        return oldest;
}
```

---
#### camera预览画面卡住
高通mm-camera架构升级P。在`mm-camera-interface`里面打开Qbuf、DQbuf的log，发现问题出现时，除了一个buffer，其他buffer都从kernel上来了。在QCamera3Channel.cpp中，回调函数streamCbRoutine为了保证出来的frames按顺序输出，会对frame number判断，如果有以前的frame没有上来，会缓存当前帧，等以前的frame来了之后，再一起返回framework层。但如果出现有一个frame卡在kernel不能回来到HAL，那其他的帧就会被缓存在HAL的streamCbRoutine函数，没有frame送回framework，framework就不会再发request下来，所以preview就卡住了。一个解决办法是在kernel把卡住的frame送回HAL，另外就是在HAL释放缓存的frame。
