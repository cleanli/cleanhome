---
layout: post
title: "【原创】以太网接口电路驱动调试总结"
date: 2023-08-12 20:23:21 +0800
categories: "技术"
tags: ["原创","硬件"]
---

最近调试了一个网口驱动，总结一下知识要点。

### 一、系统组成

![pic]({{ site.baseurl }}/images/eth/eth_ISO.png)<br>
根据以上网络七层模型，网络硬件部分由最下面两层MAC（Media Access Control）和PHY组成。MAC负责硬件工作流程控制、收发缓存以及MII管理，PHY层则负责物理信号处理。它们具体组成部分如下图所示。

![pic]({{ site.baseurl }}/images/eth/eth_hw.png)<br>

上图中，MAC和PHY之间有MII和SMI两个接口。

#### MII（Media Independent Interface）
即媒体独立接口。媒体独立的意思就是说此接口与具体的物理网络传播介质媒体无关，只负责MAC和PHY之间的数据双向传输，物理传播如何实现是PHY负责的。只需更换PHY就可以在不同的物理媒介传输数据。MII接口有MII、RMII、SMII、SSMII、SSSMII、GMII、SGMII、RGMII等。RMII是简化的MII接口，GMII是千兆网口，RGMII则是简化的千兆网口。

#### SMI接口
SMI接口则是MAC控制PHY的方式，通过它可以读写PHY芯片的寄存器。SMI有两根线，MDC为时钟线，MDIO为数据线，可以通过此总线访问多个PHY（不同PHY有不同的地址）。

PHY是IEEE 802.3规定的一个标准模块，内部寄存器地址空间是5位，共32个寄存器。其中寄存器0-15是标准规定的，不同PHY芯片都一样，这16个寄存器一般足够驱动起基本的通信了，其中有媒体连接状态、协商及连接速率等配置。寄存器16-31是各厂商自行实现。

#### Transformer（隔离变压器）
Transformer使得PHY与网线没有直接的连接，起到保护作用。

#### MDI接口（Media Dependent Interface）
PHY与Transformer之间是MDI，即媒体相关接口，是与具体的物理介质相关的。

#### RJ-45
RJ-45的接头与网线连接。

### 二、驱动对网口的操作
一般分如下几步：
 - 1 为数据收发准备内存
 - 2 根据设计的参数（如通信速率等），初始化MAC寄存器PHY寄存器（通过MAC读写PHY寄存器）
 - 3 启动收发（启动DMA）

### 三、问题记录
记录一下遇到的两个问题及解决方法：
#### ping命令测试偶然OK，大部分情况fail

由于代码与实际硬件有差异，PHY地址不正确，PHY实际并未被正确初始化，默认自动配置工作于1000M速率；但MAC中设计速率为100M，所以网络不通。由于测试环境不一样，如果硬件PHY默认初始化时握手协商速率恰好为100M时，此时网络就可以Ping通OK

经过查阅硬件原理图，修改PHY为正确地址，将PHY初始化为100M速率，Ping命令可稳定OK

#### 网络初始化返回OK，但不能收发数据；而有同样驱动代码的demo程序可以正常收发数据

经过对比调试，发现将另一模块的初始化（demo中没有此模块）移除后，数据收发正常了。原因是那个模块有参数设置不正确，影响了其他模块。
