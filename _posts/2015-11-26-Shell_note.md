---
layout:     post
title:      "【收藏】Shell笔记"
date:       2015-11-26 00:00:00 +0800
author:     "Clean Li"
categories: 技术
tags: ["收藏",Shell]
header-img: "img/post-bg-01.jpg"
---
```shell
#!/system/bin/sh

#just a sample

i=0

while true
do
#input keyevent 27
i=$((i+1))
echo "$i"
echo "$i" > /data/counts
sleep 8
done
```

判断字符串为空的方法有三种：
```shell
if [ "$str" =  "" ]
if [ x"$str" = x ]
if [ -z "$str" ] （-n 为非空）
```
注意：都要代双引号，否则有些命令会报错
