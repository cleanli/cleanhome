---
layout: post
title: "【原创】高通Camera的CHI的一些理解"
date: 2020-12-20 11:45:02 +0800
categories: "技术"
tags: ["原创","Android","Camera"]
---
CHI（CamX Hardware Interface），高通提供的新的camera HAL架构中的camera硬件接口，源码位于`vendor/qcom/proprietary`的`camx`和`chi-cdk`。CHI定义于chi-cdk/cdk/chi/chi.h中。

在这个架构中，camera sensor的setting不是以header文件的形式，而是以xml的文件形式在chi-cdk/vendor/.../SENSOR_NAME_sensor.xml中。

一些概念：<br>
`request`：camera请求<br>
`sub-request`：经拆分后的直接发送给CHI的request<br>
`stream`：连续的同一size的frame的buffer流<br>
`per-session setting`：session setting<br>
`per-request setting`：request对应的setting<br>
`Topology`：一个pipeline对应的各node连接的图<br>
`Engine`：数据处理的单元，比如IFE<br>
`Node`：组成pipeline的单位<br>
`pipeline`：由一组Node组成的处理数据流的流水线<br>
`session`：多个有关联的pipeline对应一个session<br>
`use case`：某一使用场景，比如某一preview size、某一拍照size的camera应用<br>
`statistics`：图像统计数据<br>
`Live stream`：连续的stream，一般与sensor相连<br>
`Offline stream`：非Live stream<br>

pipeline在xml文件中定义：vendor/qcom/proprietary/chi-cdk/vendor/topology/default/titan17x_usecases.xml，编译时会根据此xml的配置生成对应vendor\qcom\proprietary\chi-cdk\vendor\chioverride\default\g_pipelines.h，

`/vendor/qcom/proprietary/camx/src/core/camxsettings.xml`可以设置log打印级别，如：
```
overrideLogLevels=0x1F
logInfoMask=0xff80
logVerboseMask=0x40000
```
