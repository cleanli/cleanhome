#!/usr/bin/ruby -w
# -*- coding: UTF-8 -*-

def getCat
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

time = Time.new
 
puts "Enter prefered filename:"
myStr = String.new(gets)
myStr.chomp!
myStr.strip!
myStr.gsub!(' ', '_')
filename = myStr
if myStr.empty?
	puts "null invalid filename, quit"
else
	puts "Got filename:"
	puts myStr
	up_myStr = myStr.upcase
	myStr[0] = up_myStr[0] unless up_myStr.empty?
	filename = time.strftime("%Y-%m-%d-") + filename
	if myStr.include?'.'
		puts filename 
	else
		filename = filename + ".md"
		puts filename 
	end

	puts "Enter title:"
	myTitle = String.new(gets)
	myTitle.chomp!
	myTitle.strip!

	puts "Enter subtitle:"
	mySubtitle = String.new(gets)
	mySubtitle.chomp!
	mySubtitle.strip!
	myCate = getCat
	puts "Choose:"
	puts myCate

	puts "---"
	puts "layout: post"
	puts "title: " + '"' + myTitle + '"'
	puts "date: " + time.strftime("%Y-%m-%d %H:%M:%S %z")
	puts "subtitle: " + '"' + mySubtitle + '"' unless mySubtitle.empty?
	puts "categories: " + '"' + myCate + '"'
	puts "tags:"
	puts "---"

	aFile = File.new(filename, "a+")
	aFile.puts "---"
	aFile.puts "layout: post"
	aFile.puts "title: " + '"' + myTitle + '"'
	aFile.puts "date: " + time.strftime("%Y-%m-%d %H:%M:%S %z")
	aFile.puts "subtitle: " + '"' + mySubtitle + '"' unless mySubtitle.empty?
	aFile.puts "categories: " + '"' + myCate + '"'
	aFile.puts "tags:"
	aFile.puts "---"
	aFile.close
end

