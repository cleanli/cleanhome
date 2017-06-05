---
layout:     post
title:      "【记录】Android N build error of Java Out of Memory"
date:       2017-06-05 06:22:38 +0800
categories: 技术
tags: ["记录",Android]
---
Met error:
```
[ 33% 12328/36270] Building with Jack: out/target/common/obj/JAVA_LIBRARIES/core-oj_intermediates/dex-dir/classes.dex
FAILED: /bin/bash out/target/common/obj/JAVA_LIBRARIES/core-oj_intermediates/dex-dir/classes.dex.rsp
Out of memory error (version 1.2-rc4 'Carnac' (298900 f95d7bdecfceb327f9d201a1348397ed8a843843 by android-jack-team@google.com)).
Java heap space.
Try increasing heap size with java option '-Xmx<size>'.
Warning: This may have produced partial or corrupted output.
[ 33% 12331/36270] Building with Jack: out/target/common/obj/JAVA_LIBRARIES/libprotobuf-java-micro_intermediates/classes.jack
ninja: build stopped: subcommand failed.
build/core/ninja.mk:142: recipe for target 'ninja_wrapper' failed
make: *** [ninja_wrapper] Error 1

#### make failed to build some targets (01:04:39 (hh:mm:ss)) ####
```
Found solution here:
[Android N 遇到Try increasing heap size with java option ](http://blog.csdn.net/zxf20063033/article/details/56296403)

```console
clean@M$ export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4g"
clean@M$ ./prebuilts/sdk/tools/jack-admin kill-server
Killing background server
clean@M$ ./prebuilts/sdk/tools/jack-admin start-server
Launching Jack server java -XX:MaxJavaStackTraceDepth=-1 -Djava.io.tmpdir=/tmp -Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4g -cp /home/clean/.jack-server/launcher.jar com.android.jack.launcher.ServerLauncher
```
