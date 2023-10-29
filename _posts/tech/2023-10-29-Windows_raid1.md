---
layout: post
title: "【记录】Windows下试用raid1"
date: 2023-10-29 21:16:52 +0800
categories: "技术"
tags: ["记录","Windows","虚拟机"]
---
一直听说磁盘阵列，可以保护硬盘数据，今天试用了一下windows的镜像卷功能，其实就是raid1，感觉不复杂。

RAID，全名Redundant Array of Independent Disks，即独立磁盘冗余阵列，简称为「磁盘阵列」，就是用多个独立的磁盘组成一个大的磁盘系统。根据不同组合方式就可以实现保护数据（数据冗余）或提高性能（多块硬盘同时读写），常用有raid0，raid1，raid5。

raid0是同时使用N块硬盘，比如存文件是把文件分成N份分别存在N块硬盘，所以性能提高N倍，但没有数据保护，一块硬盘坏了数据就没了。

raid1是使用两块硬盘，写入相同数据，所以可以容忍一块硬盘坏而数据依然存在。

raid5介于上述两种之间，需要三块硬盘，数据分散存储于各硬盘，同时还有校验码信息，可以保证一块硬盘坏依然可以找回数据。

windows10下面有磁盘镜像卷功能，其实就是raid1，在虚拟机里演示一下，使用方法如下：

- 准备两个硬盘空白分区，其中一个上面右键后选择菜单“新建镜像卷”，出现向导对话框，下一步

![pic]({{ site.baseurl }}/images/win_raid1/win_raid1_1.png)<br>
![pic]({{ site.baseurl }}/images/win_raid1/win_raid1_2.png)<br>
- 从左边选择配合的磁盘，点击“添加”到右边

![pic]({{ site.baseurl }}/images/win_raid1/win_raid1_3.png)<br>
![pic]({{ site.baseurl }}/images/win_raid1/win_raid1_4.png)<br>
- 一直选择“下一步”

![pic]({{ site.baseurl }}/images/win_raid1/win_raid1_5.png)<br>
![pic]({{ site.baseurl }}/images/win_raid1/win_raid1_6.png)<br>
![pic]({{ site.baseurl }}/images/win_raid1/win_raid1_7.png)<br>
- 提示转换成动态磁盘，选择是

![pic]({{ site.baseurl }}/images/win_raid1/win_raid1_8.png)<br>
- 完成后出现E盘，存在里面的东西实际是分两份分别存在刚刚组成镜像卷的两个盘中

![pic]({{ site.baseurl }}/images/win_raid1/win_raid1_9.png)<br>
以后任何一个盘损坏，另一个盘的数据还存在，并且连到另一个电脑上也可以识别，只是会出现一个“外部”磁盘的提示，按提示导入就可以出现盘符进行访问了。
