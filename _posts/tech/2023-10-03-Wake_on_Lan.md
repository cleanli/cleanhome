---
layout: post
title: "【记录】电脑网卡唤醒开机"
date: 2023-10-03 20:22:35 +0800
categories: "技术"
tags: ["记录","硬件"]
---

测试了一下电脑网卡开机，测试电脑主板Asus H81，操作系统win8。

步骤如下：

### 一、在BIOS里面设置网卡唤醒功能打开

这个不同主板有不一样的设置，这里的主板设置如下

![pic]({{ site.baseurl }}/images/wol/wol_bios.jpg)<br>
### 二、在Windows下网卡高级属性中设置网卡唤醒功能打开

打开设备管理器，在网卡设备上右键，选择‘属性’

![pic]({{ site.baseurl }}/images/wol/wol_netcard.png)<br>
在网卡属性的‘高级’设置里面，把‘关机 网卡唤醒’和‘魔术封包唤醒’两项设置为‘启用’

![pic]({{ site.baseurl }}/images/wol/wol.png)<br>
### 三、在Windows下网卡电源管理属性中设置网卡唤醒功能打开

接上一步继续操作，在网卡属性的‘电源管理’设置里面，把下面两项选中

![pic]({{ site.baseurl }}/images/wol/wol2.png)<br>
### 四、网卡唤醒开机测试

以上设置好后，先使用`ipconfig /all`命令查看网卡mac地址（物理地址）

![pic]({{ site.baseurl }}/images/wol/check_mac.png)<br>
然后，在另一台电脑上运行'WakeMeOnLan'软件，点击扫描按钮，会出现局域网内的电脑列表。对比mac地址，找到要网卡唤醒开机测试的电脑。然后把测试电脑关机。在刚才那个软件里右键单击，选择唤醒，这时测试机就会开机了。

WakeMeOnLan软件下载：[wakemeonlan-x64.zip]({{ site.baseurl }}/downloads/wol/wakemeonlan-x64.zip)

![pic]({{ site.baseurl }}/images/wol/wol_wake.png)<br>

以上测试在win10下没有成功，网卡属性里找不到唤醒相关选项。
