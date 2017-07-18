---
layout:     post
title:      "【原创】在Github上建立clean\_study"
date:       2017-07-18 22:34:58 +0800
categories: 技术
tags: ["原创",Android]
---
以前在学习Android的时候也写过一些测试代码，但时间一长就不知道放到哪里去了，而且不同时间做的项目不一样，平台也不一样，Android的版本也不一样。这样有些学过的东西一段时间后就忘记了。

准备基于目前在电脑上测试通过的Android N x86的code（参考<a href="{{ site.baseurl }}{% post_url 2017-06-05-Android_N_build_java_out_of_memory %}">【记录】编译测试Android nougat-x86</a>），以后测试学习尽量在这个平台上，测试code保存到github上面，所以建立了一个clean\_study项目。当然这样的code都是来自于开源code。希望能把自己学过的东西都记录下来。

下载code后随便放到一个Android native源码目录里面，就可以编译了
```
git clone https://github.com/cleanli/clean_study.git
```

- 2017-07-18：<br>
添加了在屏幕上画颜色框的测试code，来自frameworks/native/services/surfaceflinger/tests/resize/resize.cpp，增加了按键停顿和继续的功能
