---
layout:     post
title:      "【原创】Android x86上的Camera HAL"
date:       2017-08-12 10:58:48 +0800
categories: 技术
tags: ["原创",Android,Camera]
---
在Android x86的源码里面，Camera HAL的目录在`hardware/libcamera`。Camera Module定义在`hardware/libcamera/CameraHal.cpp`
```cpp
camera_module_t HAL_MODULE_INFO_SYM = {
    common: {
         tag:           HARDWARE_MODULE_TAG,
         version_major: 1,
         version_minor: 0,
         id:            CAMERA_HARDWARE_MODULE_ID,
         name:          "Camera Module",
         author:        "The Android Open Source Project",
         methods:       &android::CameraFactory::mCameraModuleMethods,
         dso:           NULL,
         reserved:      {0},
    },
    get_number_of_cameras:  android::CameraFactory::get_number_of_cameras,
    get_camera_info:        android::CameraFactory::get_camera_info,
};
```

`camera_module_t`定义在`hardware/libhardware/include/hardware/camera_common.h`
```cpp
typedef struct camera_module {
    hw_module_t common;
    int (*get_number_of_cameras)(void);
    int (*get_camera_info)(int camera_id, struct camera_info *info);
    int (*set_callbacks)(const camera_module_callbacks_t *callbacks);
    void (*get_vendor_tag_ops)(vendor_tag_ops_t* ops);
    int (*open_legacy)(const struct hw_module_t* module, const char* id,
            uint32_t halVersion, struct hw_device_t** device);
    int (*set_torch_mode)(const char* camera_id, bool enabled);
    int (*init)();
    void* reserved[5];
} camera_module_t;
```

`hw_module_t`定义在`hardware/libhardware/include/hardware/hardware.h`
```cpp
/**
 * Every hardware module must have a data structure named HAL_MODULE_INFO_SYM
 * and the fields of this data structure must begin with hw_module_t
 * followed by module specific information.
 */
typedef struct hw_module_t {
    /** tag must be initialized to HARDWARE_MODULE_TAG */
    uint32_t tag;

    /**
     * The API version of the implemented module. The module owner is
     * responsible for updating the version when a module interface has
     * changed.
     *
     * The derived modules such as gralloc and audio own and manage this field.
     * The module user must interpret the version field to decide whether or
     * not to inter-operate with the supplied module implementation.
     * For example, SurfaceFlinger is responsible for making sure that
     * it knows how to manage different versions of the gralloc-module API,
     * and AudioFlinger must know how to do the same for audio-module API.
     *
     * The module API version should include a major and a minor component.
     * For example, version 1.0 could be represented as 0x0100. This format
     * implies that versions 0x0100-0x01ff are all API-compatible.
     *
     * In the future, libhardware will expose a hw_get_module_version()
     * (or equivalent) function that will take minimum/maximum supported
     * versions as arguments and would be able to reject modules with
     * versions outside of the supplied range.
     */
    uint16_t module_api_version;
#define version_major module_api_version
    /**
     * version_major/version_minor defines are supplied here for temporary
     * source code compatibility. They will be removed in the next version.
     * ALL clients must convert to the new version format.
     */

    /**
     * The API version of the HAL module interface. This is meant to
     * version the hw_module_t, hw_module_methods_t, and hw_device_t
     * structures and definitions.
     *
     * The HAL interface owns this field. Module users/implementations
     * must NOT rely on this value for version information.
     *
     * Presently, 0 is the only valid value.
     */
    uint16_t hal_api_version;
#define version_minor hal_api_version

    /** Identifier of module */
    const char *id;

    /** Name of this module */
    const char *name;

    /** Author/owner/implementor of the module */
    const char *author;

    /** Modules methods */
    struct hw_module_methods_t* methods;

    /** module's dso */
    void* dso;

#ifdef __LP64__
    uint64_t reserved[32-7];
#else
    /** padding to 128 bytes, reserved for future use */
    uint32_t reserved[32-7];
#endif

} hw_module_t;

typedef struct hw_module_methods_t {
    /** Open a specific device */
    int (*open)(const struct hw_module_t* module, const char* id,
            struct hw_device_t** device);

} hw_module_methods_t;
```

在CameraService里面获取HAL版本的function
`frameworks/av/services/camera/libcameraservice/CameraService.cpp`
{% highlight c++ linenos %}
int CameraService::getDeviceVersion(int cameraId, int* facing) {
    ATRACE_CALL();
    struct camera_info info;
    if (mModule->getCameraInfo(cameraId, &info) != OK) {
        return -1;
    }

    int deviceVersion;
    if (mModule->getModuleApiVersion() >= CAMERA_MODULE_API_VERSION_2_0) {
        deviceVersion = info.device_version;
    } else {
        deviceVersion = CAMERA_DEVICE_API_VERSION_1_0;
    }

    if (facing) {
        *facing = info.facing;
    }

    return deviceVersion;
}
{% endhighlight %}

`frameworks/av/services/camera/libcameraservice/common/CameraModule.cpp`
```cpp
uint16_t CameraModule::getModuleApiVersion() {
    return mModule->common.module_api_version;
}
```

所以，在getDeviceVersion中第9行`mModule->getModuleApiVersion()`得到的是前面定义的`version_major: 1`，而`CAMERA_MODULE_API_VERSION_2_0`是0x200，所以走到第12行，最后返回`CAMERA_DEVICE_API_VERSION_1_0`。

在preview的时候，预览帧从`hardware/libcamera/CameraHardware.cpp`的`int CameraHardware::previewThread()`送出
```cpp
int CameraHardware::previewThread()
{

...

        // Grab a frame in the raw format YUYV
        camera.GrabRawFrame(rawBase, mRawPreviewFrameSize);

...

        if (mMsgEnabled & CAMERA_MSG_PREVIEW_FRAME) {
            //ALOGD("CameraHardware::previewThread: posting preview frame...");
...
        }

        // Display the preview image
        fillPreviewWindow(rawBase, mRawPreviewWidth, mRawPreviewHeight);
...

}
```

`fillPreviewWindow`就是送去显示了，竟然是cpu做格式转换并复制到显示的内存里面，怪不得这么卡
```cpp
void CameraHardware::fillPreviewWindow(uint8_t* yuyv, int srcWidth, int srcHeight)
{
    // Preview to a preview window...
    if (mWin == 0) {
        ALOGE("%s: No preview window",__FUNCTION__);
        return;
    }

    // Get a videobuffer
    buffer_handle_t* buf = NULL;
    int stride = 0;
    status_t res = mWin->dequeue_buffer(mWin, &buf, &stride);
    if (res != NO_ERROR || buf == NULL) {
        ALOGE("%s: Unable to dequeue preview window buffer: %d -> %s",
            __FUNCTION__, -res, strerror(-res));
        return;
    }

    /* Let the preview window to lock the buffer. */
    res = mWin->lock_buffer(mWin, buf);
    if (res != NO_ERROR) {
        ALOGE("%s: Unable to lock preview window buffer: %d -> %s",
             __FUNCTION__, -res, strerror(-res));
        mWin->cancel_buffer(mWin, buf);
        return;
    }

    /* Now let the graphics framework to lock the buffer, and provide
     * us with the framebuffer data address. */
    void* vaddr = NULL;

    const Rect bounds(srcWidth, srcHeight);
    GraphicBufferMapper& grbuffer_mapper(GraphicBufferMapper::get());
    res = grbuffer_mapper.lock(*buf, GRALLOC_USAGE_SW_WRITE_OFTEN, bounds, &vaddr);
    if (res != NO_ERROR || vaddr == NULL) {
        ALOGE("%s: grbuffer_mapper.lock failure: %d -> %s",
             __FUNCTION__, res, strerror(res));
        mWin->cancel_buffer(mWin, buf);
        return;
    }

    // Calculate the source stride...
    int srcStride = srcWidth<<1;
    uint8_t* src  = (uint8_t*)yuyv;

    // Center into the preview surface if needed
    int xStart = (mPreviewWinWidth   - srcWidth ) >> 1;
    int yStart = (mPreviewWinHeight  - srcHeight) >> 1;

    // Make sure not to overflow the preview surface
    if (xStart < 0 || yStart < 0) {
        ALOGE("Preview window is smaller than video preview size - Cropping image.");

        if (xStart < 0) {
            srcWidth += xStart;
            src += ((-xStart) >> 1) << 1;       // Center the crop rectangle
            xStart = 0;
        }

        if (yStart < 0) {
            srcHeight += yStart;
            src += ((-yStart) >> 1) * srcStride; // Center the crop rectangle
            yStart = 0;
        }
    }

    // Calculate the bytes per pixel
    int bytesPerPixel = 2;
    if (mPreviewWinFmt == PIXEL_FORMAT_YCbCr_422_SP ||
        mPreviewWinFmt == PIXEL_FORMAT_YCbCr_420_SP ||
        mPreviewWinFmt == PIXEL_FORMAT_YV12 ||
        mPreviewWinFmt == PIXEL_FORMAT_YV16 ) {
        bytesPerPixel = 1; // Planar Y
    } else if (mPreviewWinFmt == PIXEL_FORMAT_RGB_888) {
        bytesPerPixel = 3;
    } else if (mPreviewWinFmt == PIXEL_FORMAT_RGBA_8888 ||
        mPreviewWinFmt == PIXEL_FORMAT_RGBX_8888 ||
        mPreviewWinFmt == PIXEL_FORMAT_BGRA_8888) {
        bytesPerPixel = 4;
    } else if (mPreviewWinFmt == PIXEL_FORMAT_YCrCb_422_I) {
        bytesPerPixel = 2;
    }

    ALOGV("ANativeWindow: bits:%p, stride in pixels:%d, w:%d, h: %d, format: %d",vaddr,stride,mPreviewWinWidth,mPreviewWinHeight,mPreviewWinFmt);

    // Based on the destination pixel type, we must convert from YUYV to it
    int dstStride = bytesPerPixel * stride;
    uint8_t* dst  = ((uint8_t*)vaddr) + (xStart * bytesPerPixel) + (dstStride * yStart);

    switch (mPreviewWinFmt) {
    case PIXEL_FORMAT_YCbCr_422_SP: // This is misused by android...
        yuyv_to_yvu420sp( dst, dstStride, mPreviewWinHeight, src, srcStride, srcWidth, srcHeight);
        break;

    case PIXEL_FORMAT_YCbCr_420_SP:
        yuyv_to_yvu420sp( dst, dstStride, mPreviewWinHeight,src, srcStride, srcWidth, srcHeight);
        break;

    case PIXEL_FORMAT_YV12:
        yuyv_to_yvu420p( dst, dstStride, mPreviewWinHeight, src, srcStride, srcWidth, srcHeight);
        break;

    case PIXEL_FORMAT_YV16:
        yuyv_to_yvu422p( dst, dstStride, mPreviewWinHeight, src, srcStride, srcWidth, srcHeight);
        break;

    case PIXEL_FORMAT_YCrCb_422_I:
    {
        // We need to copy ... do it
        uint8_t* pdst = dst;
        uint8_t* psrc = src;
        int h;
        for (h = 0; h < srcHeight; h++) {
            memcpy(pdst,psrc,srcWidth<<1);
            pdst += dstStride;
            psrc += srcStride;
        }
        break;
    }

    case PIXEL_FORMAT_RGB_888:
        yuyv_to_rgb24(src, srcStride, dst, dstStride, srcWidth, srcHeight);
        break;

    case PIXEL_FORMAT_RGBA_8888:
        yuyv_to_rgb32(src, srcStride, dst, dstStride, srcWidth, srcHeight);
        break;

    case PIXEL_FORMAT_RGBX_8888:
        yuyv_to_rgb32(src, srcStride, dst, dstStride, srcWidth, srcHeight);
        break;

    case PIXEL_FORMAT_BGRA_8888:
        yuyv_to_bgr32(src, srcStride, dst, dstStride, srcWidth, srcHeight);
        break;

    case PIXEL_FORMAT_RGB_565:
        yuyv_to_rgb565(src, srcStride, dst, dstStride, srcWidth, srcHeight);
        break;

    default:
        ALOGE("Unhandled pixel format");
    }
    /* Show it. */
    mWin->enqueue_buffer(mWin, buf);

    // Post the filled buffer!
    grbuffer_mapper.unlock(*buf);
}
```
从log看到是走`case PIXEL_FORMAT_RGBA_8888`

先到这里，下次有空再继续
