---
layout:     post
title:      "【转载】如何启用Ubuntu的休眠模式"
date:       2017-06-10 21:18:45 +0800
categories: 技术
tags: ["转载",Ubuntu]
---
大家都知道 Windows 有休眠模式，其实 Ubuntu 也有。休眠模式简单来说，就是可以在用户暂时离开时将内存中的所有内容都写入到硬盘当中，当用户下次开机时，就可以直接启动到上次保存的时间状态。

打个比方，你正用 LibreOffice 在处理一个文档，同时打开了很多参考网页和其它文件，下班时间到了，你怕第二天回来再去找那些参考网页和文件等会影响你的写作思路，现在就可以在离开时将 Ubuntu 进行休眠。Ubuntu 休眠后会将所有的未完成的处理任务都写入到硬盘再关机，下次再开机时会自动从硬盘去调用上次的状态。
检查Ubuntu休眠模式是否正常

现在我们要检查一下当前的 Ubuntu 是否允许进行休眠模式，要允许休眠我们最好为当前系统分配了一个与内存同样大小的 SWAP 分区（大多用户在系统安装时都会进行分配）。使用 “Ctrl + Alt + T” 快捷键打开一个终端，执行如下命令：
```
$ sudo pm-hibernate 
```
命令执行后，Ubuntu 将会自动关机并断电。再次开机后，如果一切正常的话我们将可以直接恢复到上次关机时的状态，这表明当前 Ubuntu 系统的休眠模式工作正常。

注意：如果关机前的状态和会话没被恢复或遇到其它错误的话，可能是由多种原因造成的，在下一步操作之前需要先进行排错。

### 重新启用休眠

如果通过上述步骤已经确认 Ubuntu 休眠模式在你的系统上可以正常工作，我们便可以将“休眠”按钮添加回我们的菜单当中。

执行如下命令在`/etc/polkit-1/localauthority/50-local.d/`目录中创建一个`com.ubuntu.enable-hibernate.pkla`文件：
```
$ sudo vi /etc/polkit-1/localauthority/50-local.d/com.ubuntu.enable-hibernate.pkla
```
在上述文件中写入如下内容：
```
[Enable Hibernate in logind]
Identity=unix-user:*
Action=org.freedesktop.login1.hibernate
ResultActive=yes
```
Ubuntu 从 14.04 开始全面支持低功耗模式，通过以上配置文件的写法应该就可以调用完成了。但如果你使用的是早期版本 Ubuntu 可以试试如下写法：
```
[Enable hibernate in upower]
Identity=unix-user:*
Action=org.freedesktop.upower.hibernate
ResultActive=yes
```
注意：以上写法不适用于 Ubuntu 13.10

如果你不能完全确定或为了保险起见，也可以同时把两种写法都写进`com.ubuntu.enable-hibernate.pkla`配置文件。
```
[Enable Hibernate in upower]
Identity=unix-user:*
Action=org.freedesktop.upower.hibernate
ResultActive=yes
 
[Enable Hibernate in logind]
Identity=unix-user:*
Action=org.freedesktop.login1.hibernate
ResultActive=yes
```
配置文件修改好后我们需要重启系统或重启 indicator 会话：
```
$ killall indicator-session-service
```
重启好之后“休眠”选项就会出现了。

休眠是一个非常实用的功能，可惜的是默认被 Ubuntu 给移除了，但我们通过本文所介绍的方法可以很容易地启用 Ubuntu 的休眠模式，有兴趣的朋友赶快试试吧！

原文链接：[如何启用Ubuntu的休眠模式](http://os.51cto.com/art/201508/487660.htm)
