---
layout:     post
title:      "【原创】Camera不同版本API与HAL流程"
date:       2017-07-27 08:29:40 +0800
categories: 技术
settop: true
tags: ["原创",Android,Camera]
---
**注**：以下code基于Android nougat-x86 (Android 7.0 release) (Nougat)，最后同步时间2017-06-06。获取code方法参考：<a href="{{ site.baseurl }}{% post_url tech/2017-06-05-Android_N_build_java_out_of_memory %}">【记录】编译测试Android nougat-x86</a>

总结了一下Camera App的API 1和API 2与HAL 1和HAL 3互相匹配的camera运行流程：

![图片]({{ site.baseurl }}/images/camera_flow/android_N_camera.png)<br>

<table class="table">
  <caption>Android Camera API 1/2 & HAL 1/3 Flow</caption>
  <thead>
    <tr>
      <th>HAL & API</th>
      <th>API 1</th>
      <th>API 2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>HAL 1</td>
      <td>1>2>3>4>5>6</td>
      <td>9>13>1>2>3>4>5>6</td>
    </tr>
    <tr>
      <td>HAL 3</td>
      <td>1>2>3>7>8>11>12</td>
      <td>9>10>11>12</td>
    </tr>
  </tbody>
</table>

#### 一、API 1 + HAL 1
这就是以前旧版本Android Camera，在图上路径是：

1 -> 2 -> 3 -> 4 -> 5 -> 6

#### 二、API 1 + HAL 3
如果是API 1的camera app，但手机上camera驱动是HAL 3，在图上路径是：

1 -> 2 -> 3 -> 7 -> 8 -> 11 -> 12

其中，在CameraServer里面判断选择4和7的code在

`frameworks/av/services/camera/libcameraservice/CameraService.cpp`

`CameraService::makeClient`函数中：
```cpp
        // Default path: HAL version is unspecified by caller, create CameraClient
        // based on device version reported by the HAL.
        switch(deviceVersion) {
          case CAMERA_DEVICE_API_VERSION_1_0:
            if (effectiveApiLevel == API_1) {  // Camera1 API route
                sp<ICameraClient> tmp = static_cast<ICameraClient*>(cameraCb.get());
                *client = new CameraClient(cameraService, tmp, packageName, cameraId, facing,
                        clientPid, clientUid, getpid(), legacyMode);
            } else { // Camera2 API route
                ALOGW("Camera using old HAL version: %d", deviceVersion);
                return STATUS_ERROR_FMT(ERROR_DEPRECATED_HAL,
                        "Camera device \"%d\" HAL version %d does not support camera2 API",
                        cameraId, deviceVersion);
            }
            break;
          case CAMERA_DEVICE_API_VERSION_3_0:
          case CAMERA_DEVICE_API_VERSION_3_1:
          case CAMERA_DEVICE_API_VERSION_3_2:
          case CAMERA_DEVICE_API_VERSION_3_3:
          case CAMERA_DEVICE_API_VERSION_3_4:
            if (effectiveApiLevel == API_1) { // Camera1 API route
                sp<ICameraClient> tmp = static_cast<ICameraClient*>(cameraCb.get());
                *client = new Camera2Client(cameraService, tmp, packageName, cameraId, facing,
                        clientPid, clientUid, servicePid, legacyMode);
            } else { // Camera2 API route
                sp<hardware::camera2::ICameraDeviceCallbacks> tmp =
                        static_cast<hardware::camera2::ICameraDeviceCallbacks*>(cameraCb.get());
                *client = new CameraDeviceClient(cameraService, tmp, packageName, cameraId,
                        facing, clientPid, clientUid, servicePid);
            }
            break;
          default:
            // Should not be reachable
            ALOGE("Unknown camera device HAL version: %d", deviceVersion);
            return STATUS_ERROR_FMT(ERROR_INVALID_OPERATION,
                    "Camera device \"%d\" has unknown HAL version %d",
                    cameraId, deviceVersion);
        }

```

#### 三、API 2 + HAL 1
如果camera app采用新的API 2，但手机上的camera驱动还是旧的HAL 1，API 2会通过`CameraDeviceUserShim`走API 1调用HAL 1，路径为：

9 -> 13 -> 1 -> 2 -> 3 -> 4 -> 5 -> 6

选择走13和10的判断是在CameraManager.java里面的`private CameraDevice openCameraDeviceUserAsync`函数里进行的，code如下：

`frameworks/base/core/java/android/hardware/camera2/CameraManager.java`

```cpp
                if (supportsCamera2ApiLocked(cameraId)) {
                    // Use cameraservice's cameradeviceclient implementation for HAL3.2+ devices
                    ICameraService cameraService = CameraManagerGlobal.get().getCameraService();
                    if (cameraService == null) {
                        throw new ServiceSpecificException(
                            ICameraService.ERROR_DISCONNECTED,
                            "Camera service is currently unavailable");
                    }
                    cameraUser = cameraService.connectDevice(callbacks, id,
                            mContext.getOpPackageName(), uid);
                } else {
                    // Use legacy camera implementation for HAL1 devices
                    Log.i(TAG, "Using legacy camera HAL.");
                    cameraUser = CameraDeviceUserShim.connectBinderShim(callbacks, id);
                }
```

#### 四、API 2 + HAL 3
最后一种是app和HAL都采用新的API 2和HAL 3，这样的流程最简单，从java直接连接CameraServer，路径为：

9 -> 10 -> 11 -> 12

