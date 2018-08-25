---
layout: post
title: "【记录】vcf文件明码转换"
date: 2018-08-25 11:32:33 +0800
categories: "生活"
tags: ["记录"]
---
从很多手机导出的通讯录都是vcf格式，里面的中文使用的是一种“QUOTED-PRINTABLE”的格式编码，直接用记事本打开是看不到中文明码的。在网上找到了一段Ruby的脚本代码，可以转换成中文明码：

```ruby
#!/usr/bin/env ruby -w

def main
  file=File.open(File.join("original.vcf"),"r")
  file_to=File.open(File.join("transfered.txt"),"w")
  @i = 1
  file.each {
          |line| 
          if line.index("BEGIN:VCARD") == 0 ||
                  line.index("VERSION") == 0 ||
                  line.index("N;ENCODING=QUOTED-PRINTABLE") == 0 ||
                  line.index("END:VCARD") == 0 then
                  next
          end
          print line 
          #print line.gsub(/\r\n/, "\n").unpack("M").first
          decode_str(line)
          file_to.puts(line)
          if line.index("TEL;VOICE;CELL") == 0 || line.index("TEL;CELL;PREF") then
                  file_to.puts("#@i")
                  puts ("====#@i====")
                  file_to.puts ("")
                  puts ("")
                  @i += 1
          else
          end
  }
  file.close
  file_to.close
end

def decode_str(line)
    line.chomp!
    line.gsub!(/=([\dA-F]{2})/) { $1.hex.chr }
    if line[-1] == ?=
      print line[0..-2]
    else
      print line, $/
    end
end

main
```
这是Ruby脚本，使用前先安装Ruby，官网：[Ruby程序设计语言官方网站](https://www.ruby-lang.org/zh_cn/)

使用方法为：

1 将上面的代码存为`transfer_vcf.rb`，或直接下载[transfer\_vcf.rb]({{ site.baseurl }}/downloads/vcf/transfer_vcf.rb)

2 将vcf文件另存为同目录下`original.vcf`

3 打开cmd命令窗口，进入该目录，运行命令`ruby transfer_vcf.rb`，就会看到同目录下生成了一个`transfered.txt`；或者直接在文件浏览器里双击`transfer_vcf.rb`运行即可

最后生成的文件中去掉了无用的行，只留下名字和电话信息，并加了计数。
