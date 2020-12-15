---
layout: post
title: "【收藏】代码片段收集（持续更新）"
date: 2017-08-19 18:44:03 +0800
categories: "技术"
tags: ["收藏"]
settop: true
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

#### 常用code
```cpp
#include <stdio.h>
perror("message");
fflush(stdout);
printf("%ld\n", ftell(fp));
fseek(fp, 2, SEEK_SET);

#include <unstd.h>
int main(int argc, char *argv[])
{
    int ch;
    while((ch = getopt(argc,argv,"s:pj:"))!= -1)
    {
        //putchar(ch);
        //printf("\n");
        //fflush(stdout);
        switch(ch)
        {
            case 's':
                printf("option s:'%s'\n",optarg);
                /*handle code*/
                break;
            case 'p':
                /*handle code*/
                break;
            case 'j':
                printf("option s:'%s'\n",optarg);
                /*handle code*/
                break;
            default:
                printf("other option: %c\n", ch);
        }
    }
}

String8 tpath;
tpath = tpath.format("/data/");
```

---

#### camera memory monitor
```sh
#!/system/bin/sh

i=0
times=150
echo "camera memory usage" >/tmp/tmp.txt
while [ $i -le $times ]
do
echo "#"$i
adb shell cat /proc/meminfo |grep -w "MemFree\|Cached\|IonInUse" |tee -a /tmp/tmp.txt
adb shell dumpsys meminfo com.android.camera2 |grep -w "Pss\|TOTAL\|MEMINFO\|Applications" |tee -a /tmp/tmp.txt
adb shell dumpsys meminfo cameraserver |grep -w "Pss\|TOTAL\|MEMINFO\|Applications" |tee -a /tmp/tmp.txt
sleep 10s
let "i++"
done

```
---

#### capture script
```sh
#!/system/bin/sh

filename=`date +%Y%m%d-%H%M%S`
filename=capture_${filename}
date>/data/${filename}
i=0
while true
do
    i=$((i+1))
    input keyevent 27
    echo "capture $i" >> /data/${filename}
    sleep 6
done
```
---
#### Android Mutex

```cpp
#include <utils/Mutex.h>

Mutex mTest;

void func()
{
    Mutex::Autolock l(mTest);
}

void another_func()
{
    status_t ret = mTest.tryLock();
    if(ret != OK){//func is still running
        ret = mTest.timedLock(2000000000/*2s*/);
    }//wait for 2s
    ...
    if(ret == OK){
        mTest.unlock()
    }
    ...
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

$(warning Message_to_show $(YY))

######

include $(BUILD_SHARED_LIBRARY)
```
