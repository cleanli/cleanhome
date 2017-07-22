---
layout:     post
title:      "【收藏】Selinux笔记"
date:       2015-11-04 00:00:00 +0800
categories: 技术
tags: ["收藏",Selinux]
---
#### 查看SELinux状态

1、/usr/sbin/sestatus -v      ##如果SELinux status参数为enabled即为开启状态

SELinux status:                 enabled

2、getenforce                 ##也可以用这个命令检查

#### 关闭SELinux：

1、临时关闭（不用重启机器）：

setenforce 0  设置SELinux 成为permissive模式

setenforce 1  设置SELinux 成为enforcing模式

2、修改配置文件需要重启机器：

修改/etc/selinux/config 文件

将SELINUX=enforcing改为SELINUX=disabled

重启机器即可

#### SELINUX模式
SELINUX有「disabled」「permissive」，「enforcing」3种选择。

Disabled就不用说了，permissive就是Selinux有效，但是即使你违反了策略的话它让你继续操作，但是把你的违反的内容记录下来。在我们开发策略的时候非常的有用。相当于Debug模式。

Enforcing就是你违反了策略，你就无法继续操作下去。

#### SELINUXTYPE
SELINUXTYPE呢，现在主要有2大类，一类就是红帽子开发的targeted，它只是对于，主要的网络服务进行保护，比如 apache,sendmail,bind,postgresql等，不属于那些domain的就都让他们在`unconfined_t`里，可导入性高，可用性好但是不能对整体进行保护。

另一类是Strict，是NAS开发的，能对整个系统进行保护，但是设定复杂，我认为虽然它复杂，但是一些基本的会了，还是可以玩得动的。

我们除了在/etc/sysconfig/selinux设它有效无效外，在启动的时候，也可以通过传递参数selinux给内核来控制它。（Fedora 5默认是有效）
```
kernel /boot/vmlinuz-2.6.15-1.2054_FC5 ro root=LABEL=/ rhgb quiet selinux=0
```
上面的变更可以让它无效。

（注：原收藏于为知笔记）
