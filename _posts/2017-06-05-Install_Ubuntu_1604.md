---
layout:     post
title:      "【记录】Ubuntu 16.04 Config and Installing"
date:       2017-06-05 06:37:55 +0800
categories: 技术
tags: ["记录",Ubuntu]
---
Recorded my private settings and softwares often used in Ubuntu.

#### 1 add following to `.bashrc`
```bash
alias gd='git diff'
export PATH=/home/clean/bin:/home/clean/bin/repo:$PATH

up () 
{ 
	LIMIT=$1;
	if [ -z "$LIMIT" ]; then
		LIMIT=1;
	fi;
	P=$PWD;
	for ((i=1; i <= LIMIT; i++))
	do
		P=$P/..;
	done;
	cd $P;
	export MPWD=$P
}

c  ()
{
mkdir -p $HOME/.dhs
recpwd
cd $1
recpwd
sort $HOME/.dhs/dhsty -o $HOME/.dhs/dhsty
}

cg ()
{
	choosehisdir
	str=`cat $HOME/.dhs/wantedpath`
	rm $HOME/.dhs/wantedpath
	cd $str
}

bap ()
{
	adb remount
	sorthiscmd
	push
	cat $HOME/.dhs/wantedcmd
	str=`cat $HOME/.dhs/wantedcmd`
	g=${str#*/system/}
	f=${g%/system/*}
	h="adb pull /system/$f && $str"
	echo
	echo $h
	eval $h
	rm $HOME/.dhs/wantedcmd
	mr
	echo "mediaserver restarted!"
}

ap ()
{
	adb remount
	sorthiscmd
	push
	cat $HOME/.dhs/wantedcmd
	str=`cat $HOME/.dhs/wantedcmd`
	eval $str
	rm $HOME/.dhs/wantedcmd
	mr
	echo "mediaserver restarted!"
}

st ()
{
        echo
        if [ -z "$ORIG" ]; then
                ORIG=$PS1
        fi
        TITLE="\[\e]2;$*\a\]"
        PS1=${ORIG}${TITLE}
}

al ()
{
adb logcat -v threadtime | tee l
}

fap ()
{
echo $1
f=$1
g=${f#*/system/}
h="adb pull /system/$g"
echo $h
#eval $h
j="adb push $OUT/system/$g /system/$g"
echo $j
#eval $h
echo "$h && $j"
eval "$h && $j"
echo $j >> $HOME/.dhs/cmdhist
mr
echo "mediaserver restarted"
}

mr ()
{
adb shell stop media
adb shell start media
adb shell stop cameraserver
adb shell start cameraserver
}

savecmd ()
{
cp $HOME/.dhs/cmdhist $HOME/.dhs/tmp
if [ -z "$1" ]; then
history | grep "adb push\|grep" | cut -c 8- > $HOME/.dhs/tmp2
sort $HOME/.dhs/tmp2 | uniq
cat $HOME/.dhs/tmp2 >> $HOME/.dhs/tmp
rm $HOME/.dhs/tmp2
else
echo $1
echo $1 >> $HOME/.dhs/tmp
fi
sort $HOME/.dhs/tmp | uniq > $HOME/.dhs/cmdhist
rm $HOME/.dhs/tmp
}

sorthiscmd ()
{
cp $HOME/.dhs/cmdhist $HOME/.dhs/tmp
sort $HOME/.dhs/tmp | uniq > $HOME/.dhs/cmdhist
rm $HOME/.dhs/tmp
}
```

#### 2 Extract the bin.tar.gz in home directory: [bin.tar.gz]({{ site.baseurl }}/downloads/ubuntu_install/bin.tar.gz)
```
$ cd ~
$ tar xzvf bin.tar.gz
```
Main command inside is: adb, fastboot, repo

And the commands defined by myself:
- setupcs: to prepare code analysis in Ubuntu
- choosehisdir, hiscmd, recpwd: records of command, directory

#### 3 Installing Java and other needed components for Android source building
```console
$ sudo apt-get update
$ sudo apt-get install openjdk-8-jdk
$ sudo update-alternatives --config java
$ sudo update-alternatives --config javac
$ sudo apt-get install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip
```

#### 4 Installing Vim
```console
$ sudo apt-get vim
```
Then extract the vim.tar.gz in home directory: [vim.tar.gz]({{ site.baseurl }}/downloads/ubuntu_install/vim.tar.gz)
```
$ cd ~
$ tar xzvf vim.tar.gz
```

#### 5 Installing and initilizing others
```console
$ sudo apt-get install cscope
$ sudo apt-get install ctags
$ sudo apt-get install meld
$ sudo apt-get install tree
$ git config --global user.email "clean_li@yahoo.com"
$ git config --global user.name "clean_li"
$ git config --global core.editor vim
```

#### 6 Installing Jekyll
```console
$ sudo apt-get install ruby
$ sudo apt-get install ruby-dev
$ ruby -v
ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]
$ gem -v
2.5.1
$ sudo gem install jekyll
$ sudo gem install bundler
$ sudo gem install jekyll-paginate
$ sudo gem install addressable -v 2.5.0
$ sudo gem install sass -v 3.4.23
$ sudo gem install jekyll-feed
$ sudo gem uninstall addressable -v 2.5.1
$ sudo gem uninstall sass -v 3.4.24
$ git clone https://github.com/cleanli/cleanhome.git
$ cd cleanhome/
$ jekyll serve
```
