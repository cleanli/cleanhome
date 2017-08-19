---
layout: post
title: "【原创】博客文章生成脚本"
date: 2017-08-19 13:47:38 +0800
categories: "技术"
tags: ["原创","博客技术"]
---
Jekyll博客文章有一个header，每次增加新文章写这个header，里面要定义layout，title，时间，类别和标签。一直想写个脚本来自动完成这件事。因为希望能同时在Ubuntu和Windows下运行，所以不能用linux的shell。想到Jekyll就是用Ruby开发的，Ruby在Ubuntu和Windows下都有开发环境，所以尝试用Ruby写写看。

网上找到一个Ruby的教学网站，[Ruby教程](http://www.runoob.com/ruby/ruby-tutorial.html)，准备把教程里的示例代码抄过来。因为这个任务就是自动生成一个文件，所以重点抄字符串、文件操作的代码，比较幸运，抄来的脚本可以按设计正常工作，基本流程如下：
- 1 先输入新文件名
- 2 输入标题，副标题
- 3 自动获取时间
- 4 选择类别，根据类别选择新文件所在目录名
- 5 选择标签
- 6 根据上面信息，最后生成文件

这里摘录选择类别的代码，先列出所有类别，然后输入序号，返回序号对应的类别字符串。
```rb
def getCat
	puts
	puts
	puts
	cateStr = String.new("探索 思考 感悟 生活 技术 其它")
	cateArray = cateStr.split(' ')
	@i = 0
	while @i < cateArray.size  do
		puts("#@i " + cateArray[@i] )
		@i += 1
	end
	puts "Enter cates<5>:"
	mychs = String.new(gets)
	mychs.chomp!
	mychs.strip!
	if mychs.empty?
		mychs = mychs + '5'
	end
	cateArray[mychs.to_i]
end
```
与C比较，Ruby的特点：
- 变量无需声明
- 全局变量与局部变量加前缀严格区分
- 函数的最后一行就是返回值
- 运行不需编译

这个基本上就是按C编程的思路抄成Ruby的code。不过Ruby是面向对象的，看教程里的内容，感觉功能还是很强大，这里用到的仅仅是一点皮毛。感觉Ruby的最大的好处是方便，因为不需要编译，直接在ruby后面接要运行的文件名就可以了，至少我现在是这样运行的。在多文件的情况下怎么运行暂时就不知道了。
