---
layout:     post
title:      "【转载】如何减小VirtualBox虚拟硬盘文件的大小"
date:       2017-05-22 21:59:10 +0800
categories: tech
header-img: "img/post-bg-02.jpg"
---

摘要: 虚拟机使用久了就会发现虚拟硬盘越来越大，但是进入虚拟机里的系统用命令看了下，实际占用的空间远没有虚拟硬盘大小那么大，这个让人很不爽，而且在分享虚拟机镜像的时候也很不方便。VirtualBox似乎没有提供图形界面的方式可以让我们来压缩虚拟硬盘大小，但是可以通过命令行来实现。经过实际测试，我的一个30多G的虚拟硬盘可以压缩到13G大小，可见效果还是非常显著的，这个可以压缩的空间取决于你虚拟机内真实的空间占用大小。

VirtualBox同时支持自己的虚拟硬盘格式VDI和Vmware的VMDK格式，两种格式的压缩略有不同。

# 1 碎片整理
第一步要做的是碎片整理，打开虚拟机，执行下面的命令：

Linux系统：
```console
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY
```
Windows系统需要下载[Sysinternals Suite](http://technet.microsoft.com/en-us/sysinternals/bb842062.aspx)并执行：
```shell
sdelete –z
```
# 2 压缩磁盘
关闭虚拟机，现在可以开始压缩虚拟硬盘了

如果你的虚拟硬盘是VirtualBox自己的VDI格式，找到你的虚拟硬盘文件，执行命令：
```console
VBoxManage modifyhd mydisk.vdi --compact
```
如果你的虚拟硬盘是Vmware的VMDK格式，那就要麻烦点，因为VirtualBox不支持直接压缩VMDK格式，但是可以变通下：先转换成VDI并压缩，再转回VMDK。执行命令：
```console
VBoxManage clonehd "source.vmdk" "cloned.vdi" --format vdi
VBoxManage modifyhd cloned.vdi --compact
VBoxManage clonehd "cloned.vdi" "compressed.vmdk" --format vmdk
```
事实上，执行命令的过程中可以发现：在从VMDK转换到VDI的过程中似乎已经做了压缩，文件大小已经减少了很多，第二条命令反而没见到文件大小有什么变化，所以这里第二条命令应该可以省略了。

VMDK 的压缩，也可以使用 vmware-vdiskmanager，只需要一条命令（参考）：
```console
vmware-vdiskmanager -k disk.vmdk
```

源文档 <https://my.oschina.net/tsl0922/blog/188276>
