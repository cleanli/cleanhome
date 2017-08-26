---
layout: post
title: "【原创】Android x86上的Camera HAL(2)"
date: 2017-08-26 11:04:02 +0800
categories: "技术"
tags: ["原创","Camera","Android"]
---
（接上篇）<a href="{{ site.baseurl }}{% post_url tech/2017-08-12-Android_x86_Camera_HAL %}">【原创】Android x86上的Camera HAL</a>

再发现x86的Camera Hal的preview线程里面自己会延时，再去取preview的frame，这个比较不多见

`hardware/libcamera/CameraHardware.cpp`
```cpp
int CameraHardware::previewThread()
{
    ALOGV("CameraHardware::previewThread: this=%p",this);

    int previewFrameRate = mParameters.getPreviewFrameRate();

    // Calculate how long to wait between frames.
    int delay = (int)(1000000 / previewFrameRate);
...

    ALOGV("previewThread OK");

    // Wait for it...
    usleep(delay);

    return NO_ERROR;
}
```

在`V4L2Camera::GrabRawFrame`中会把preview frame转成yuyv，再到`CameraHardware::previewThread`中从yuyv转成preview需要的格式。

#### 增加fake camera功能
想在这个里面增加一个fake Camera的功能，就是让没有usb camera的时候，电脑也可以打开camera。目前里面的h文件：
```shell
$ ls *.h -l
-rw-rw-r-- 1 clean clean  4278 6月   6 10:07 CameraFactory.h
-rw-rw-r-- 1 clean clean 13291 8月  26 09:54 CameraHardware.h
-rw-rw-r-- 1 clean clean 10737 6月   6 10:07 Converter.h
-rw-rw-r-- 1 clean clean  3983 6月   6 10:07 SurfaceDesc.h
-rw-rw-r-- 1 clean clean  3733 6月   6 10:07 SurfaceSize.h
-rw-rw-r-- 1 clean clean  2133 6月   6 10:07 Utils.h
-rw-rw-r-- 1 clean clean  3702 6月   6 10:07 uvc_compat.h
-rw-rw-r-- 1 clean clean  2570 8月  26 09:57 V4L2Camera.h
-rw-rw-r-- 1 clean clean  4593 6月   6 10:07 v4l2_formats.h
```

`CameraFactory`在camera module被load的时候，生成CameraHardware；而`CameraHardware`会根据video设备来生成camera，里面包含一个`V4L2Camera`对象。所以，最简单的改法应该是在V4L2Camera里面增加fake cam的功能。

先在`CameraFactory`强行增加fake cam：
```diff
diff --git a/CameraFactory.cpp b/CameraFactory.cpp
index 0e8c920..ba72d1d 100644
--- a/CameraFactory.cpp
+++ b/CameraFactory.cpp
@@ -144,6 +144,7 @@ void CameraFactory::parseConfig(const char* configFile)
             ALOGD("Found device %s", DEFAULT_DEVICE_FRONT);
             newCameraConfig(CAMERA_FACING_FRONT, DEFAULT_DEVICE_FRONT, 0);
         }
+       newCameraConfig(CAMERA_FACING_BACK, "fake", 0);
     }
 }
```

`V4L2Camera`里面增加判断是否启动fake cam的代码，并做一些初始化
```diff
diff --git a/V4L2Camera.h b/V4L2Camera.h
index 9756e9d..5786a6d 100644
--- a/V4L2Camera.h
+++ b/V4L2Camera.h
@@ -77,6 +77,7 @@ private:

     int nQueued;
     int nDequeued;
+    bool mFake;

     SortedVector<SurfaceDesc> m_AllFmts;        // Available video modes
     SurfaceDesc m_BestPreviewFmt;               // Best preview mode. maximum fps with biggest frame

diff --git a/V4L2Camera.cpp b/V4L2Camera.cpp
index 49949cf..0debcbd 100644
--- a/V4L2Camera.cpp
+++ b/V4L2Camera.cpp
@@ -40,7 +40,7 @@ extern "C" {
 namespace android {

 V4L2Camera::V4L2Camera ()
-        : fd(-1), nQueued(0), nDequeued(0)
+        : fd(-1), nQueued(0), nDequeued(0), mFake(false)
 {
     videoIn = (struct vdIn *) calloc (1, sizeof (struct vdIn));
 }
@@ -58,6 +58,15 @@ int V4L2Camera::Open (const char *device)
     /* Close the previous instance, if any */
     Close();

+    if(!strcmp(device, "fake")){
+       ALOGI("x86fakecam: use fake -");
+       mFake = true;
+       m_BestPreviewFmt = SurfaceDesc( 640, 480, 25 );
+       m_BestPictureFmt = SurfaceDesc( 640, 480, 25 );
+       m_AllFmts.add( SurfaceDesc( 640, 480, 25 ) );
+       return 0;
+    }
+
     memset(videoIn, 0, sizeof (struct vdIn));
```

其它所有操作实际video设备的代码要避开，像这样
```diff
@@ -489,6 +512,11 @@ int V4L2Camera::StartStreaming ()
     enum v4l2_buf_type type;
     int ret;

+    if(mFake){
+       ALOGI("fake %s return 0", __func__);
+       return 0;
+    }
+
     if (!videoIn->isStreaming) {
         type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
```

最后在获取帧数据的地方，改成fake的帧，这里就简单的做循环增加，这样会使图像画面出现几个色条，颜色和宽度随时间变化。以后有空再改成漂亮一点的图像。
```diff
@@ -543,6 +585,20 @@ void V4L2Camera::GrabRawFrame (void *frameBuffer, int maxSize)
     LOG_FRAME("V4L2Camera::GrabRawFrame: frameBuffer:%p, len:%d",frameBuffer,maxSize);
     int ret;

+    if(mFake){
+       static uint8_t fillbyte = 0x0;
+       static uint8_t fillper = 0;
+       memset(frameBuffer, fillbyte, maxSize);
+       memset(frameBuffer, fillbyte+0x40, maxSize*fillper/100);
+       memset(frameBuffer, fillbyte+0x80, maxSize*(fillper/2)/100);
+       memset(frameBuffer, fillbyte+0xc0, maxSize*(fillper/4)/100);
+       ALOGI("fake %s return 0", __func__);
+       fillbyte++;
+       fillper++;
+       if(fillper>100)fillper=0;
+       return;
+    }
+
```

用自己的<a href="{{ site.baseurl }}{% post_url tech/2017-06-27-GoldCam %}">GoldCam</a>测试，截屏纪念一下。这当然没有任何美感，不过可以使用了。以后不用真实的usb camera也可以打开camera做测试，所以将来可以在虚拟机里跑Android X86，可以省占用一台电脑。

![图片]({{ site.baseurl }}/images/x86camhal/x86camhal.png)<br>
