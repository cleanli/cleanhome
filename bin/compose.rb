#!/usr/bin/ruby -w
# -*- coding: UTF-8 -*-

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

	puts "---"
	puts "layout: post"
	puts "title: TBD"
	puts "date: " + time.strftime("%Y-%m-%d %H:%M:%S %z")
	puts "subtitle:"
	puts "categories:"
	puts "tags:"
	puts "---"

	aFile = File.new(filename, "a+")
	aFile.puts "---"
	aFile.puts "layout: post"
	aFile.puts "title: TBD"
	aFile.puts "date: " + time.strftime("%Y-%m-%d %H:%M:%S %z")
	aFile.puts "subtitle:"
	aFile.puts "categories:"
	aFile.puts "tags:"
	aFile.puts "---"
	aFile.close
end
