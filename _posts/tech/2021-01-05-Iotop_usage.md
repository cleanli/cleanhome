---
layout: post
title: "【转载】使用iotop监控磁盘I/O"
date: 2021-01-05 11:22:13 +0800
categories: "技术"
tags: ["转载","Ubuntu","Linux"]
---
注：转载并翻译自linuxhint.com:[Monitor Disk I/O with iotop in Linux](https://linuxhint.com/monitor_disk_io_iotop_linux/)，略有改动。

---
<p>在Linux服务器上，您有许多正在运行的进程，并且每个进程都在执行某些I/O操作。因此，这些进程都会占用磁盘带宽。</p>
<p>我们可以使用htop命令查看Linux服务器所有正在运行的进程的列表。但是，如果我们要监视每个进程消耗多少磁盘带宽怎么办？好吧，我们可以使用iotop。</p>
<p>iotop和htop一样，是Linux上的交互式I/O监视工具。使用iotop，您可以轻松地监视Linux上处理的每个运行的磁盘读写带宽使用情况。</p>
<p>在本文中，我将向您展示如何在流行的Linux发行版上安装iotop，以及如何使用iotop监视每个运行进程的磁盘读写带宽使用情况。我将使用Ubuntu 18.04 LTS进行演示，但是相同的命令在任何现代Linux发行版中均应适用。因此，让我们开始吧。</p>
<h3>在Ubuntu中安装iotop:</h3>
<p>iotop在Ubuntu的官方软件包存储库中可用。因此，您可以使用APT软件包管理器轻松下载iotop。</p>
<p>首先，使用以下命令更新APT软件包存储库缓存：</p>
```bash
$ sudo apt update
```
<p>现在，使用下面的命令安装iotop：</p>
```bash
$ sudo apt install iotop
```
<p>iotop应该已经被安装好了。</p>
<p>现在，使用这个命令试试iotop是否安装好了</p>
```bash
$ iotop --version
```
<h3>在CentOS 7上安装iotop:</h3>
<p>iotop在CentOS 7的官方软件包存储库中可用。您可以使用YUM软件包管理器轻松地安装它，如下所示：</p>
```bash
$ sudo yum install iotop
```
<h3>iotop的基本用法:</h3>
<p>要使用iotop监视每个正在运行的进程的磁盘使用情况，请按以下方式运行iotop：</p>
```bash
$ sudo iotop
```
<p>如您所见，iotop交互式窗口已打开。在这里，您可以查看哪个进程正在使用该磁盘。</p>
![iotopusage]({{ site.baseurl }}/images/iotop_usage/iotop_window.png)<br>
<p>在上图左上方，显示了磁盘的总读取速度/带宽。同样，在右上角显示总磁盘写入速度/带宽。</p>
![iotopusage]({{ site.baseurl }}/images/iotop_usage/iotop_columns.png)<br>
<p>如您所见，iotop显示以下内容的列：</p>
<ul>
<li>Thread ID/线程ID (<strong>TID</strong>).</li>
<li>I/O Priority class/level (<strong>PRIO</strong>).</li>
<li>the thread with TID/线程用户名 (<strong>USER</strong>).</li>
<li>the disk read per second/每秒磁盘读取 (<strong>DISK READ</strong>).</li>
<li>the disk write per second/每秒磁盘写入 (<strong>DISK WRITE</strong>).</li>
<li>the percentage of time the thread spent while swapping in/交换线程时花费的时间百分比 (<strong>SWAPIN</strong>).</li>
<li>the percentage of time the thread spent waiting on I/O/线程等待I/O花费的时间百分比 (<strong>IO&gt;</strong>).</li>
<li>the command the thread is running/线程命令行 (<strong>COMMAND</strong>).</li>
</ul>
<p>在大多数情况下，线程ID（TID）等效于进程ID（PID）。</p>
<h3>显示仅执行I / O操作的进程:</h3>
<p>默认情况下，iotop会显示所有正在运行的进程，无论它们是否正在执行I / O操作。所以，这个清单很长。很难找到我们需要的流程并进行监控。</p>

幸运的是，iotop允许您仅显示正在执行I / O操作的进程。为此，可以使用iotop的`-o`或`–only`选项。

<p>要仅显示执行I / O操作的进程，请按以下方式运行iotop：</p>
```bash
$ sudo iotop -o
```
<p>或</p>
```bash
$ sudo iotop --only
```
<p>如您所见，拥有线程号1345和1957的进程现在正在执行I / O操作。</p>
![iotopusage]({{ site.baseurl }}/images/iotop_usage/iotop_only_option.png)<br>
<p>这是本文中用来模拟I / O操作的命令。</p>
```bash
$ dd if=/dev/urandom of=iotest.img bs=1M count=1000
```
`注意`：如果尚未使用`-o`或`–only`选项启动iotop，则仍可以通过按键盘上的`o`键切换到此模式。您可以使用`o`键在iotop的这两种模式之间切换。

<h3>显示每个进程的总I / O使用量:</h3>
iotop还使您可以监视iotop启动后每个进程总共完成了多少次磁盘读取和磁盘写入。为此，您必须使用`-a`或`–accumulated`选项。您也可以将它与`-o`或`–only`选项一起使用。

<p>例如，</p>
```bash
$ sudo iotop -ao
```
<p>如您所见，显示了每个进程的磁盘读取和磁盘写入总量。</p>
![iotopusage]({{ site.baseurl }}/images/iotop_usage/iotop_ao_option.png)<br>
<h3>显示进程号而不是线程号:</h3>
如前所述，线程ID（TID）通常与进程ID（PID）相同。您可以将它们互换使用。但是，如果您真的想确保使用正确的进程ID（PID），则iotop具有`-P`或`–processes`选项，可用于将默认TID列更改为PID列。

<p>要显示PID列而不是TID列，请按以下方式运行iotop：</p>
```bash
$ sudo iotop -P
```
<p>或</p>
```bash
$ sudo iotop --processes
```
<p>如您所见，TID列被PID列替换。</p>
<h4>过滤iotop进程:</h4>
<p>您可以基于进程ID（PID），线程ID（TID）和进程所有者（USER）筛选iotop进程。</p>
<p>例如，如果只想监视进程2024和2035的磁盘I / O，则可以按以下方式运行iotop：</p>
```bash
$ sudo iotop -P -p2024 -p 2035
```
<p>如您所见，只有2024和2035的进程被显示。</p>
![iotopusage]({{ site.baseurl }}/images/iotop_usage/iotop_PID_filter.png)<br>
<p>然后我们说想监视以shovon用户身份运行的进程的磁盘I / O，为此，请按以下方式运行iotop：</p>
```bash
$ sudo iotop -P -u shovon
```
<p>如您所见，仅显示以用户shovon运行的进程。</p>
![iotopusage]({{ site.baseurl }}/images/iotop_usage/iotop_user_filter.png)<br>
<p>如果要一次监视多个用户，也可以执行此操作。</p>
<p>例如，要监视用户shovon和lily正在运行的所有进程的磁盘I / O，请按以下方式运行iotop：</p>
```bash
$ sudo iotop -P -u shovon -u lily
```
<p>所以，这基本上就是您使用iotop来监视Linux中的磁盘I / O的方式。 感谢您阅读本文。</p>
