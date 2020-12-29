---
layout: post
title: "【原创】Camera驱动开发工作总结"
date: 2020-12-27 16:32:08 +0800
categories: "技术"
tags: ["原创","Android","Camera"]
---

Camera驱动部分的工作需要与camera硬件和光学部门的同事紧密配合。

---
### 1 设计阶段
依据手机spec定义的camera部分的feature，参与确定camera sensor数量、规格
#### 1.1 系统版本
Android/kernel版本号
 
#### 1.2 Camera主要feature
HDR/Bokeh/SAT/DIS/SlowMotion

#### 1.3 Camera memory估算
frame buffer size：wxhx1.5xN<br>
拍照：preview buffer + snapshot buffer + jpeg buffer<br>
录像：preview buffer + video buffer + encoder buffer<br>

#### 1.4 mipi传输估算
Camera 有效像素 * ADC色彩深度 * 帧率 * (1+20%) < lane数 * mipi速率<br>
比如，有效像素为2592 * 1944，30fps帧率，10位ADC色彩深度<br>
2592 * 1944 * 10 * 30 * (1+20%) = 1.8Gbps

---
### 2 Camera Bring up
有如下几个步骤，许多信息需要camera硬件及光学部门的支持。
#### 2.1 准备工作
##### 2.1.1 camera sensor信息
- Sensor type: Bayer/YUV
- Data interface: MIPI/Parallel
- Control interface: I2C/SPI

##### 2.1.2 camera子模块信息
- Actuator: 对焦马达芯片的型号，i2c地址
- EEPRom: 芯片型号，i2c地址
- Flash LED: 闪光灯控制方式，i2c/PMIC
- 其他子模块，如OIS，PDAF（Type1，Type2，Type3，Type2PD，shield pixel/2x1 PD/dual PD）相关信息

##### 2.1.3 硬件信号连接图
- i2c连接在主控芯片的哪个i2c口
- camera sensor时钟MCLK
- MIPI口连接
- 电源连线：数字电源DVDD，模拟电源AVDD（感光部分及ADC）/AGND，数字部分输出电源DOVDD/DGND，对焦马达电源AF_VDD/AF_GND
- 其他控制信号，如RST，STANDBY（低功耗状态），gpio Table
- 其他子模块硬件相关信息

##### 2.1.4 sensor vendor信息
- sensor datasheet
- sensor setting，包括init/preview/snapshot/raw snapshot/video mode这些模式的settings
- exposure计算
- power up/down sequence
- vendor contact，以便将来可能需要的support

##### 2.1.5 主控芯片camera sensor驱动相关资料
- 主控芯片camera bring up guide
- 主控芯片codebase，先行study camera部分各code关系，在需要的部分加上log方便后续调试
- 主控芯片vendor contact，一般会以提case的形式寻求support

#### 2.2 具体Bring up过程
##### 2.2.1 驱动及相关文件编写
这一步在有系统的codebase之后，在第一步准备工作完成之后就可以开始，依据camera bring up guide，把第一步收集的各项信息转化或填入相关驱动文件。硬件连接信息填入kernel的dts文件，sensor及子模块对应编写相关的驱动文件。

##### 2.2.2 编译通过
文件编写完毕后，尝试编译，fix BB，直到编译可以PASS，生成最终那些需要的文件

##### 2.2.3 手机上camera调试
此前最好联系HW工程师准备好camera部分电路板上的测试点，比如i2c信号、RESET、各power、MIPI信号、MCLK等等，以备后面需要测量信号。<br>
这一步必须在手机系统可以启动进入HOME界面之后。把2.2.2步的文件push到手机里面，然后观察camera系统初始化情况，是否可以detect到camera sensor。如果不能，观察log，有需要的话利用示波器检测camera sensor各信号是否按预期工作，按bring up guide排除问题，直到成功打开camera出现预览画面、可以拍照。

#### 2.3 相关tool
在bring up起来之后，可以完成相关tool以support其他部门工作，比如calibration tool（包括lens shading，AWB）、focus test tool，或一些硬件测试或工厂需要的tool。<br>
比如AWB calibration，就是需要计算在某一光源下纯白色的raw图像的R/G、B/G，并存储在ROM中。在打开camera时由driver取出以此校正AWB，从而使颜色正常，消除单个sensor差异。

---
### 3 Camera各feature实现
- HDR：光线对比比较大的环境下拍照
- Bokeh：背景虚化，一般需要两颗sensor
- RTB：Realtime Bokeh，实时背景虚化
- SAT：光学平滑变焦，一般需要两颗焦距不同的sensor
- DIS：Digital Image Stablization，视频防抖
- SlowMotion：让sensor以高速帧率输出（比如120fps），而以30fps进行视频编码
- Third Part Algrithm Porting
- 其他：比如Touch AEC/AF，AEC/AF Lock，Live snapshot（录像中拍照），Panorama（移动相机拼接拍照，一般在APP实现），场景选择，前camera镜像，Zoom，Face Detection

---
### 4 Camera相关测试issue fix
- Google CTS
- Camera功能测试
- Camera Performance，比如camera打开/拍照时间，对焦时间
- 一些基本的稳定测试，比如camera open/close，snapshot/video重复测试
- Camera power/电流测试

---
### 附1：Camera相关调试经验
- 注意检查camera相关线程优先级（Thread Priority Verification），`renice -g [pid/tid]`，某些重要thread如果优先级低，可能会造成问题
- 如果出现某些issue时，怀疑硬件信号有问题，可以在出现issue时，拉起某个测试gpio，这样使用示波器监控这个gpio，就可以抓到出问题时的信号进行检查
- 如果camera出现等待某个锁，而卡死导致camera不能使用，可以尝试给锁加超时限制。
- 如果camera无法恢复，可以尝试self-kill camera service，让camera系统重启（当然这是最后的办法）

---
### 附2：Camera相关名词
- VCM：voice coil motor，音圈马达，对焦驱动元件
- Anti-Banding：消除在交流电光源下图像出现的波纹
- 3A：AE/AF/AWB，自动曝光/自动对焦/自动白平衡
- FPS：帧率，每秒帧数
- ISO：感光度，ISO越高，噪点越多
- Metering mode：测光模式，有平均测光/中央测光/点测光
- Thumnail：jpeg图片里面的缩略图
- EXIF：jpeg图片里面的信息，Exchangeable image file format，记录数码照片的属性信息和拍摄数据
- Geotag：照片exif里面的地理信息
- IFE：Image Front End，图像处理前端，连接sensor，可以处理bayer数据，输出preview/video的YUV
- BPS：Bayer Processing Segment，处理Bayer数据的部件，处理snapshot的bayer，输出YUV
- IPE：Image Processing Engine，图像处理引擎，处理YUV数据
- STATS：图像统计数据，提供给3A算法
- SOF：Start of frame
- RDI：Raw Dump Interface，原始数据转储接口
- CRM：Camera Request Manager
- FOV：Field of View，视场角
- MFNR：多帧降噪，Multi-Frames Noise Remove
- LTM：局部色调映射
- ANR：先进降噪功能
- PDAF：相位检测自动对焦
- LSC：Lens Shading Calibration，镜头阴影校正
- CPP：Camera Post Processing，相机后处理
- CHI: CamX Hardware Interface
- chi-cdk：CHI Camera Development Kit
