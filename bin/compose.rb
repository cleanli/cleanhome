#!/usr/bin/ruby -w
# -*- coding: UTF-8 -*-

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
	case mychs.to_i
	when 0
		$filename = "_posts/miracles/" + $filename
	when 1
		$filename = "_posts/thinking/" + $filename
	when 2
		$filename = "_posts/feeling/" + $filename
	when 3
		$filename = "_posts/life/" + $filename
	when 4
		$filename = "_posts/tech/" + $filename
	else
		$filename = "_posts/others/" + $filename
	end
	cateArray[mychs.to_i]
end

def getTag
	puts
	puts
	puts
	tagStr = String.new("转载 原创 收藏 记录")
	tagArray = tagStr.split(' ')
	@i = 0
	while @i < tagArray.size  do
		puts("#@i " + tagArray[@i] )
		@i += 1
	end
	puts "Enter tags<1>:"
	mychs = String.new(gets)
	mychs.chomp!
	mychs.strip!
	if mychs.empty?
		mychs = mychs + '1'
	end
	mytag = '["' + tagArray[mychs.to_i] + '"'

	tagStr2 = String.new("奇迹,历史,电影,濒死体验,Shell,Android,特异功能,Selinux,搞笑,Camera,Vim,Makefile,预言,Git,法律,传说,修行,轮回转世,史前文明,Jekyll,博客技术,英语,文化,进化论,信仰,Ubuntu,购物,Linux,虚拟机,Windows,JavaScript,Liquid,Grub,天文")
	tagArray2 = tagStr2.split(',')
	while true do
		puts
		puts
		@i = 0
		while @i < tagArray2.size  do
			puts("#@i " + tagArray2[@i] )
			@i += 1
		end
		puts "Enter more tags<null to quit>:"
		mychs2 = String.new(gets)
		mychs2.chomp!
		mychs2.strip!
		if mychs2.empty?
			break
		end
		mytag = mytag + ',"' + tagArray2[mychs2.to_i] + '"'
	end
	mytag = mytag + ']'
end

time = Time.new
 
$filename = ""
puts "Enter prefered filename:"
myStr = String.new(gets)
myStr.chomp!
myStr.strip!
myStr.gsub!(' ', '_')
if myStr.empty?
	puts "null invalid filename, quit"
else
	puts "Got filename:"
	puts myStr
	up_myStr = myStr.upcase
	myStr[0] = up_myStr[0] unless up_myStr.empty?
	$filename = time.strftime("%Y-%m-%d-") + myStr
	if myStr.include?'.'
		puts $filename 
	else
		$filename = $filename + ".md"
		puts $filename 
	end

	puts
	puts
	puts "Enter title:"
	myTitle = String.new(gets)
	myTitle.chomp!
	myTitle.strip!

	puts
	puts
	puts "Enter subtitle:"
	mySubtitle = String.new(gets)
	mySubtitle.chomp!
	mySubtitle.strip!
	myCate = getCat
	puts
	puts
	puts "Choose:"
	puts myCate
	myTag = getTag
	puts
	puts
	puts "Choose:"
	puts myTag

	puts "---"
	puts "layout: post"
	puts "title: " + '"' + myTitle + '"'
	puts "date: " + time.strftime("%Y-%m-%d %H:%M:%S %z")
	puts "subtitle: " + '"' + mySubtitle + '"' unless mySubtitle.empty?
	puts "categories: " + '"' + myCate + '"'
	puts "tags: " + myTag
	puts "---"

	aFile = File.new($filename, "a+")
	if aFile
		aFile.puts "---"
		aFile.puts "layout: post"
		aFile.puts "title: " + '"' + myTitle + '"'
		aFile.puts "date: " + time.strftime("%Y-%m-%d %H:%M:%S %z")
		aFile.puts "subtitle: " + '"' + mySubtitle + '"' unless mySubtitle.empty?
		aFile.puts "categories: " + '"' + myCate + '"'
		aFile.puts "tags: " + myTag
		aFile.puts "---"
		aFile.close
	else
		puts "Can't open file: " + $filename
	end
end

