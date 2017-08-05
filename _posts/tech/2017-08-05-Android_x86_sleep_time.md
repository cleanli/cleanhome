---
layout:     post
title:      "【转载】Android x86睡眠触发时间修改"
date:       2017-08-05 11:02:51 +0800
categories: 技术
tags: ["转载",Android]
---
自己编译的Android x86安装在电脑上，但是睡眠触发时间最长只有30分钟，一会儿就要去按power键，非常不方便。在网上找到这个patch，把30分钟改成200小时，应该够用了，记录在这里吧。

在`packages/apps/Settings`这个目录：
```diff
diff --git a/res/values-zh-rCN/arrays.xml b/res/values-zh-rCN/arrays.xml
index bcc93d6..38d14ed 100644
--- a/res/values-zh-rCN/arrays.xml
+++ b/res/values-zh-rCN/arrays.xml
@@ -36,7 +36,7 @@
     <item msgid="7001195990902244174">"2分钟"</item>
     <item msgid="7489864775127957179">"5分钟"</item>
     <item msgid="2314124409517439288">"10分钟"</item>
-    <item msgid="6864027152847611413">"30分钟"</item>
+    <item msgid="6864027152847611413">"200小时"</item>
   </string-array>
   <string-array name="dream_timeout_entries">
     <item msgid="3149294732238283185">"永不"</item>
diff --git a/res/values/arrays.xml b/res/values/arrays.xml
index 6827e5b..ba3676c 100644
--- a/res/values/arrays.xml
+++ b/res/values/arrays.xml
@@ -47,7 +47,7 @@
         <item>2 minutes</item>
         <item>5 minutes</item>
         <item>10 minutes</item>
-        <item>30 minutes</item>
+        <item>200 hours</item>
     </string-array>
 
     <!-- Do not translate. -->
@@ -65,7 +65,7 @@
         <!-- Do not translate. -->
         <item>600000</item>
         <!-- Do not translate. -->
-        <item>1800000</item>
+        <item>720000000</item>
     </string-array>
 
     <!-- Display settings.  The delay in inactivity before the dream is shown. These are shown in a list dialog. -->

```
然后，`mm`编译，push到电脑上替换原来的，重启电脑就起作用了。

```
adb connect 192.168.58.60
adb push $OUT/system/priv-app/Settings/Settings.apk /system/priv-app/Settings
adb reboot
```
