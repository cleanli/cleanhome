---
layout:     post
title:      "【转载】Shell脚本逐行处理文本文件"
date:       2014-10-23 00:00:00 +0800
categories: 技术
tags: ["转载",Shell]
---
经常会对文体文件进行逐行处理，在Shell里面如何获取每行数据，然后处理该行数据，最后读取下一行数据，循环处理．有多种解决方法如下：

### 1.通过read命令完成．

read命令接收标准输入，或其他文件描述符的输入，得到输入后，read命令将数据放入一个标准变量中．

利用read读取文件时，每次调用read命令都会读取文件中的"一行"文本．

当文件没有可读的行时，read命令将以非零状态退出．
```shell
cat data.dat | while read line
do
    echo "File:${line}"
done

while read line
do 
    echo "File:${line}"
done < data.dat
```

### 2.使用awk命令完成

awk是一种优良的文本处理工具，提供了极其强大的功能．

利用awk读取文件中的每行数据，并且可以对每行数据做一些处理，还可以单独处理每行数据里的每列数据．
```shell
cat data.dat | awk '{print $0}'
cat data.dat | awk 'for(i=2;i<NF;i++) {printf $i} printf "\n"}'
```
第1行代码输出data.dat里的每行数据，第2代码输出每行中从第2列之后的数据．

如果是单纯的数据或文本文件的按行读取和显示的话，使用awk命令比较方便．

### 3.使用for var in file 命令完成

`for var in file`表示变量var在file中循环取值．取值的分隔符由$IFS确定．
```shell
for line in $(cat data.dat)
do 
    echo "File:${line}"
done

for line in `cat data.dat`
do 
    echo "File:${line}"
done
```

如果输入文本每行中没有空格，则line在输入文本中按换行符分隔符循环取值．

如果输入文本中包括空格或制表符，则不是换行读取，line在输入文本中按空格分隔符或制表符或换行符特环取值．

可以通过把IFS设置为换行符来达到逐行读取的功能．

IFS的默认值为：空白(包括：空格，制表符，换行符)．

注：转载于印象笔记
