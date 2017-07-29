---
layout: post
title: 【转载】Windows上安装Jekyll
categories: 技术
tags: ["转载",Jekyll,"博客技术"]
---
 Jekyll是一个静态网站生成工具。它允许用户使用HTML、Markdown或Textile来建立静态页面，然后通过模板引擎Liquid（Liquid Templating Engine）来运行.

 原文链接： http://blog.csdn.net/kong5090041/article/details/38408211

 目前，网上有许多Jekyll的安装方法，大都相似，为了方便更多准备学习Jekyll的人，特翻译如下：


 共分为以下几个重要步骤

 - 安装 Ruby
 - 安装 DevKit
 - 安装 Jekyll
 - 安装 Pygments<br>
 1 安装 Python  
 2 安装 ‘Easy Install’  
 3 安装 Pygments
 - 启动 Jekyll
 - 故障诊断

>引用部分是我自己的安装记录以便对照，我的环境是win8 64bit，先安装git 64bit，然后使用git bash为终端

## 安装 Ruby

 前往 http://rubyinstaller.org/downloads/

 在 “RubyInstallers” 部分，选择某个版本点击下载。

 例如， Ruby 2.0.0-p451 (x64) 是适于64位 Windows 机器上的 Ruby 2.0.0 x64 安装包。

 通过安装包安装

 最好保持默认的路径 C:\Ruby200-x64， 因为安装包明确提出 “请不要使用带有空格的文件夹 (如： Program Files)”。

 勾选 “Add Ruby executables to your PATH”，这样执行程序会被自动添加至 PATH 而避免不必要的头疼。

 Windows Ruby 安装包

 打开一个命令提示行并输入以下命令来检测 Ruby 是否成功安装。

 ruby -v

 输出示例：

 ruby 2.0.0p451 (2014-02-24) [x64-mingw32]

>使用的版本为rubyinstaller-2.3.3-x64，勾选 “Add Ruby executables to your PATH”，安装正常

## 安装 DevKit

 DevKit 是一个在 Windows 上帮助简化安装及使用 Ruby C/C++ 扩展如 RDiscount 和 RedCloth 的工具箱。 详细的安装指南可以在程序的wiki 页面 阅读。

 再次前往 http://rubyinstaller.org/downloads/

 下载同系统及 Ruby 版本相对应的 DevKit 安装包。 例如，DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe 适用于64位 Windows 系统上的 Ruby 2.0.0 x64。

 下面列出了如何选择正确的 DevKit 版本：

 Ruby 1.8.6 to 1.9.3: DevKit tdm-32-4.5.2

 Ruby 2.0.0: DevKit mingw64-32-4.7.2

 Ruby 2.0.0 x64: DevKit mingw64-64-4.7.2

 运行安装包并解压缩至某文件夹，如 C:\DevKit

 通过初始化来创建 config.yml 文件。在命令行窗口内，输入下列命令：

 cd “C:\DevKit”

 ruby dk.rb init

 notepad config.yml

 在打开的记事本窗口中，于末尾添加新的一行 - C:\Ruby200-x64，保存文件并退出。

 回到命令行窗口内，审查（非必须）并安装。

 ruby dk.rb review

 ruby dk.rb install

>版本为DevKit-mingw64-64-4.7.2-20130224-1432-sfx，解压到C:\DevKit。
>notepad config.yml，这一步不用加那一行，一切正常

## 安装 Jekyll

 确保 gem 已经正确安装

 gem -v

 输出示例：

 2.0.14

 安装 Jekyll gem

 gem install jekyll

>按以上步骤安装正常

## 安装 Pygments

 Jekyll 里默认的语法高亮插件是 Pygments。 它需要安装 Python 并在网站的配置文件\_config.yml 里将 highlighter 的值设置为pygments。

 不久之前，Jekyll 还添加另一个高亮引擎名为 Rouge， 尽管暂时不如 Pygments 支持那么多的语言，但它是原生 Ruby 程序，而不需要使用 Python。 更多信息请点此关注。

### 安装 Python

 前往 http://www.python.org/download/

 下载合适的 Python windows 安装包，如 Python 2.7.6 Windows Installer。 请注意，Python 2 可能会更合适，因为暂时 Python 3 可能不会正常工作。

 安装

 添加安装路径 (如： C:\Python27) 至 PATH。(如何操作? 请参见 故障诊断 #1)

 检验 Python 安装是否成功

 python –V

 输出示例：

 Python 2.7.6

>版本为python-2.7.13.msi，安装路径为C:\Python27，添加到PATH，开新的终端窗口，测试安装成功

### 安装 ‘Easy Install’

 浏览 https://pypi.python.org/pypi/setuptools#installation-instructions 来查看详细的安装指南。

 对于 Windows 7 的机器，下载 ez\_setup.py 并保存，例如，至C:\。 然后从命令行使用 Python 运行此文件：

 python “C:\ez\_setup.py”

 添加 ‘Python Scripts’ 路径 (如： C:\Python27\Scripts) 至 PATH

>这一步不用，因为Pygments已经自带了

### 安装 Pygments

 确保 easy\_install 已经正确安装

 easy\_install --version

 输出示例：

 setuptools 3.1

 使用 “easy\_install” 来安装 Pygments

 easy\_install Pygments

>这一步不用，因为Pygments已经自带了

## 启动 Jekyll

 按照官方的 Jekyll 快速开始手册 的步骤， 一个新的 Jekyll 博客可以被建立并在localhost:4000浏览。

 jekyll new myblog

 cd myblog

 jekyll serve

>这一步遇到错误  
>`The full error message from Ruby is: 'cannot load such file -- bundler'`  
>运行这个命令解决  
>`gem install bundler`  
>还有一个error   
>`Could not find addressable-2.5.0 in any of the sources (Bundler::GemNotFound)`   
>run this command:  
>`bundle install`

## 故障诊断

 - 错误信息：

 “python” is not recognized as an internal or external command, operable program or batch file.

 其他情况： 这里的 “python” 也可能是 “ruby”， “gem” 或是 “easy\_install” 等。

 可能原因： 该程序可能未被正确地安装或未在 PATH 里设置成功。

 尝试解法： 确保程序已被正确安装。然后手动将其添加至 PATH，请参考如下步骤[1]。

 按住 Win 键再按下 Pause

 点击 Advanced System Settings

 点击 Environment Variables

 将 ;C:\python27 添加至 Path 变量的末尾

 重启命令行

 - 错误信息：

 ERROR:  Error installing jekyll:

 ERROR: Failed to build gem native extension.

 "C:/Program Files/Ruby/Ruby200-x64/bin/ruby.exe" extconf.rb

 creating Makefile

 make generating stemmer-x64-mingw32.def

 compiling porter.c

 ...

 make install

 /usr/bin/install -c -m 0755 stemmer.so C:/Program Files/Ruby/Ruby200-x64/lib/ruby/gems/2.0.0/gems/fast-stemmer-1.0.2/li

 /usr/bin/install: target `Files/Ruby/Ruby200-x64/lib/ruby/gems/2.0.0/gems/fast-stemmer-1.0.2/lib' is not a directory

 make: *** [install-so] Error 1

 可能原因： Ruby 被安装在含有空格的路径里。

 尝试解法： 重新安装 Ruby，这次请不要使用带有空格的路径，或者请直接选择使用默认路径。

 - 错误信息：

 Generating... Liquid Exception: No such file or directory - python c:/Ruby200-x64/lib/ruby/gems/2.0.0/gems/pygments.rb-0.4.2/lib/pygments/mentos.py in 2013-04-22-yizeng-hello-world.md

 可能原因： Pygments 未能被正确安装或是 PATH 设置尚未生效。

 尝试解法： 首先请确保 Pygments 已成功安装且 Python 的 PATH 设置正确未包含空格和最后多余的斜杠。 然后重启命令行。如果依旧失败，请尝试注销并重新登录 Windows。 甚至使用终极解法，重启电脑。

 - 错误信息：

 Generating... Liquid Exception: No such file or directory - /bin/sh in \_posts/2013-04-22-yizeng-hello-world.md

 可能原因： 与 pygments.rb 0.5.1/0.5.2 版本的兼容性问题。

 尝试解法： 将 pygments.rb gem 的版本从 0.5.1/0.5.2 降至 0.5.0。

 gem uninstall pygments.rb –version ‘=0.5.2’

 gem install pygments.rb –version 0.5.0

 - 错误信息：

 c:/Ruby200-x64/lib/ruby/2.0.0/rubygems/dependency.rb:296:in `to\_specs': Could not find 'pygments.rb' (~> 0.4.2) - did find: [pygments.rb-0.5.0] (Gem::LoadError)

 from c:/Ruby200-x64/lib/ruby/2.0.0/rubygems/specification.rb:1196:in `block in activate\_dependencies'

 from c:/Ruby200-x64/lib/ruby/2.0.0/rubygems/specification.rb:1185:in `each'

 from c:/Ruby200-x64/lib/ruby/2.0.0/rubygems/specification.rb:1185:in `activate\_dependencies'

 from c:/Ruby200-x64/lib/ruby/2.0.0/rubygems/specification.rb:1167:in `activate'

 from c:/Ruby200-x64/lib/ruby/2.0.0/rubygems/core\_ext/kernel\_gem.rb:48:in`gem'

 from c:/Ruby200-x64/bin/jekyll:22:in '<main>'

 可能原因：如错误信息所述，找不到 pygments.rb 0.4.2，仅找到 pygments.rb 0.5.0。 （此问题出现于此文初稿时的 Jekyll 版本，现版本应已修复）


 尝试解法： 将 pygments.rb gem 的版本降级至 0.4.2

 gem uninstall pygments.rb –version “=0.5.0”

 gem install pygments.rb –version “=0.4.2”

 - 错误信息：

 Generating... You are missing a library required for Markdown. Please run:

 $ [sudo] gem install rdiscount

 Conversion error: There was an error converting '\_posts/2013-04-22-yizeng-hello-world.md/#excerpt'.

 ERROR: YOUR SITE COULD NOT BE BUILT:


 Missing dependency: rdiscount

 可能原因： 依赖包 rdiscount 未找到。 此问题最有可能的原因是，网站使用的是 rdiscount 作为 Markdown 引擎，而不是 Jekyll 默认的引擎，故需要手动自行安装。

 尝试解法：

 gem install rdiscount

 - 错误信息：

 c:/Ruby200-x64/lib/ruby/site\_ruby/2.0.0/rubygems/core\_ext/kernel\_require.rb:55:in `require': cannot load such file -- wdm (LoadError)

 from c:/Ruby200-x64/lib/ruby/site\_ruby/2.0.0/rubygems/core\_ext/kernel\_require.rb:55:in `require'

 from c:/Ruby200-x64/lib/ruby/gems/2.0.0/gems/listen-1.3.1/lib/listen/adapter.rb:207:in `load\_dependent\_adapter'

 from c:/Ruby200-x64/lib/ruby/gems/2.0.0/gems/listen-1.3.1/lib/listen/adapters/windows.rb:33:in `load\_dependent\_a dapter'

 ...

 可能原因： wdm gem 未被安装。因为 Jekyll 只官方地支持 *nix 系统，所以 Windows Directory Monitor 并没有作为依赖包而被自动安装。

 尝试解法：

 gem install wdm

 - 注意

 为了能够让这里网站正常运行，这里需要删除\_post文件夹里的文件（应该有一个xxxx-xx-xx-welcome-to- jekyll.markdown字样的文件），因为这个文件内部使用了语法高亮插件（另外不删，则可以修改配置文件禁用该语法高亮插件，即修改根目录下 \_config.yml中的pygments: true为false便可。），这个需要另外安装，不再本文范围内，不删会导致生成的静态页面有问题，因时间有限本文暂不提此问题。

 - Update 20170603

 安装了Jekyll之后，还要安装下列：
```
gem install bundler
gem install jekyll-paginate
gem install addressable -v 2.5.0
gem install sass -v 3.4.23
gem install jekyll-feed -v 0.9.2
gem uninstall sass -v 3.4.24
jekyll serve
```
