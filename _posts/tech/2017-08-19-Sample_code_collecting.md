---
layout: post
title: "【收藏】代码片段收集（持续更新）"
date: 2017-08-19 18:44:03 +0800
categories: "技术"
tags: ["收藏"]
---
看到有一个网站分享代码片段，想起自己以前就曾经有过这样的收集代码片段的设想，到用的时候随时复制粘贴^_^。就在这里收集吧

---

#### C++文件操作
```cpp
#include <stdio.h>
#include <error.h>
#include <errno.h>
#include <string.h>
#include <fcntl.h>
#include <stdint.h>

int main()
{
    const char *filename = "test/testfile";
    FILE *fp = fopen(filename, "wb");
    if (!fp){
	    printf("Open file %s fail, error code %d, error message: %s\n",
			    filename, errno, strerror(errno));
	    return -1;
    }

    fwrite("hello world", 10, 1, fp);
    fclose(fp);
    return 0;
}
```

---

#### Android property
```cpp
#include <cutils/log.h>
#include <cutils/properties.h>

    char path[PROPERTY_VALUE_MAX];
    property_get("test.cam.device", path, "/data/test");

    char value[PROPERTY_VALUE_MAX];
    property_get("xxxx.media.camera", value, "0");
    if (atoi(value)) {
        ALOGD("The value is %d", value);
    }

    if (property_get_bool("debug.test.cam", 0))
        ALOGE("Is true");

    ALOGI("cdb: %d %s %s", __LINE__, __func__, __FILE__);
    ALOGE("cdb: %d %s %s", __LINE__, __func__, __FILE__);
    ALOGW("cdb: %d %s %s", __LINE__, __func__, __FILE__);
```

---

#### Android.mk
```make
include $(call all-subdir-makefiles)

######

LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)
LOCAL_SRC_FILES:= cameratest.cpp
LOCAL_SHARED_LIBRARIES := \
	libcutils \
	libutils \
	libbinder \
	libui \
	libcamera_client \
	libcamera_metadata \
	libgui

LOCAL_C_INCLUDES += \
    $(TOP)/system/media/camera/include \
    
LOCAL_MODULE:= cameratest
include $(BUILD_EXECUTABLE)

######

include $(BUILD_SHARED_LIBRARY)
```
