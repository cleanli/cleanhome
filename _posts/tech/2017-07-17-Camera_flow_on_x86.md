---
layout:     post
title:      "【原创】Android x86上Camera流程"
date:       2017-07-17 22:35:15 +0800
categories: 技术
tags: ["原创",Android,Camera]
---
在<a href="{% post_url tech/2017-06-05-Android_N_build_java_out_of_memory %}">【记录】编译测试Android nougat-x86</a>这里编译了Android nougat-x86之后，安装在电脑上，可以正常启动，而且插上usb camera之后还可以打开相机。于是想验证一下Camera的流程。

这里使用的Camera app是自己写的GoldCam<br>
<a href="{% post_url tech/2017-06-27-GoldCam %}">【原创】写了一个Camera App：GoldCam</a><br>
安装在电脑的Android上，可以打开usb的camera。

先观察`Camera.open(cameraId)`这个动作，这里使用的是`Camera API 1`，所以framework这边会走<br>
`core/java/android/hardware/Camera.java`<br>
这边，通过JNI走到<br>
`core/jni/android_hardware_Camera.cpp`<br>

在刚刚这两个文件里加了下面的log：
```diff
diff --git a/core/java/android/hardware/Camera.java b/core/java/android/hardware/Camera.java
index 218cc37..d869fee 100644
--- a/core/java/android/hardware/Camera.java
+++ b/core/java/android/hardware/Camera.java
@@ -342,6 +342,7 @@ public class Camera {
      * @see android.app.admin.DevicePolicyManager#getCameraDisabled(android.content.ComponentName)
      */
     public static Camera open(int cameraId) {
+       Log.e(TAG, "cam_track_fwth Camera open(int cameraId) " + cameraId);
         return new Camera(cameraId);
     }
 
@@ -462,11 +463,13 @@ public class Camera {
             mEventHandler = null;
         }
 
+       Log.e(TAG, "cam_track_fwth cameraInitVersion(int cameraId, int halVersion) " + cameraId + " " + halVersion);
         return native_setup(new WeakReference<Camera>(this), cameraId, halVersion,
                 ActivityThread.currentOpPackageName());
     }
 
     private int cameraInitNormal(int cameraId) {
+       Log.e(TAG, "cam_track_fwth cameraInitNormal(int cameraId) " + cameraId);
         return cameraInitVersion(cameraId, CAMERA_HAL_API_VERSION_NORMAL_CONNECT);
     }
 
@@ -490,6 +493,7 @@ public class Camera {
 
     /** used by Camera#open, Camera#open(int) */
     Camera(int cameraId) {
+       Log.e(TAG, "cam_track_fwth Camera(int cameraId) " + cameraId);
         int err = cameraInitNormal(cameraId);
         if (checkInitErrors(err)) {
             if (err == -EACCES) {
diff --git a/core/jni/android_hardware_Camera.cpp b/core/jni/android_hardware_Camera.cpp
index b926270..0868253 100644
--- a/core/jni/android_hardware_Camera.cpp
+++ b/core/jni/android_hardware_Camera.cpp
@@ -543,6 +543,7 @@ static jint android_hardware_Camera_native_setup(JNIEnv *env, jobject thiz,
     env->ReleaseStringChars(clientPackageName,
                             reinterpret_cast<const jchar*>(rawClientName));
 
+    ALOGE("%s: camera ID %d halVersion %d", __FUNCTION__, cameraId, halVersion);
     sp<Camera> camera;
     if (halVersion == CAMERA_HAL_API_VERSION_NORMAL_CONNECT) {
         // Default path: hal version is don't care, do normal camera connect.
```

编译的话JNI要到`frameworks/base/core/jni`下面mm，生成`libandroid_runtime.so`
```
adb push ~/Projects/aosp/out/target/product/x86/system/lib/libandroid_runtime.so /system/lib
```

Camera.java的改动，需要到`frameworks/base`下面mm，然后编译的log只提示生成了boot.art
```
Running kati to generate build-android_x86-mmm-frameworks_base_Android.mk.ninja...
No need to regenerate ninja file
Starting build with ninja
ninja: Entering directory `.'
[  2% 1/34] Ensure Jack server is installed and started
Jack server already installed in "/home/clean/.jack-server"
Server is already running
[100% 34/34] Install: out/target/product/x86/system/framework/x86/boot.art
make: Leaving directory '/home/clean/Projects/aosp'
```
但只把这个放到电脑里面发现不行，于是把`boot-framework.art`和`boot-framework.oat`一起更新
```
clean@cl:/tmp/test$ adb push ~/Projects/aosp/out/target/product/x86/system/framework/x86/boot.art /system/framework/x86
3547 KB/s (2125824 bytes in 0.585s)
clean@cl:/tmp/test$ adb push ~/Projects/aosp/out/target/product/x86/system/framework/x86/boot-framework.art /system/framework/x86
2933 KB/s (6049792 bytes in 2.013s)
clean@cl:/tmp/test$ adb push ~/Projects/aosp/out/target/product/x86/system/framework/x86/boot-framework.oat /system/framework/x86
3464 KB/s (39312492 bytes in 11.080s)
clean@cl:/tmp/test$ adb reboot
```
打开GoldCam，刚才加的log都有了，证明其在framework的流程正是如前面分析。
```
clean@cl:/tmp/test$ grep -Irn "native_setup\|cam_track_fwth" l
5650:07-17 14:23:46.143  3707  3707 E Camera  : cam_track_fwth Camera open(int cameraId) 0
5651:07-17 14:23:46.143  3707  3707 E Camera  : cam_track_fwth Camera(int cameraId) 0
5652:07-17 14:23:46.143  3707  3707 E Camera  : cam_track_fwth cameraInitNormal(int cameraId) 0
5653:07-17 14:23:46.143  3707  3707 E Camera  : cam_track_fwth cameraInitVersion(int cameraId, int halVersion) 0 -2
5654:07-17 14:23:46.143  3707  3707 E Camera-JNI: android_hardware_Camera_native_setup: camera ID 0 halVersion -2
6237:07-17 14:23:48.018  3707  3707 E Camera  : cam_track_fwth Camera open(int cameraId) 0
6238:07-17 14:23:48.018  3707  3707 E Camera  : cam_track_fwth Camera(int cameraId) 0
6239:07-17 14:23:48.018  3707  3707 E Camera  : cam_track_fwth cameraInitNormal(int cameraId) 0
6240:07-17 14:23:48.018  3707  3707 E Camera  : cam_track_fwth cameraInitVersion(int cameraId, int halVersion) 0 -2
6241:07-17 14:23:48.018  3707  3707 E Camera-JNI: android_hardware_Camera_native_setup: camera ID 0 halVersion -2
```
`halVersion = -2`，这个就是这个定义
```
private static final int CAMERA_HAL_API_VERSION_NORMAL_CONNECT = -2;
```
这个表示走正常的connect，区别于指定hal版本的connectLegacy。
