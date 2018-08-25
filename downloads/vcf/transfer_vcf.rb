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
