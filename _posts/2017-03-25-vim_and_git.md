---
layout: post
title: "【收藏】vim and git笔记"
date: 2017-03-25 00:00:00 +0800
categories: tech
tags: ["收藏",Vim,git]
---
# vim and git#

## 自动折行 ##
自动折行 是把长的一行用多行显示 , 不在文件里加换行符用<br> 
:set wrap 设置自动折行<br>
:set nowrap 设置不自动折行<br>

## Vim delete empty line ##
:g/^$/d

## Find previous git commit ##
git reflog

## checkout previous version file ##
git checkout 32323ade23 filename

## git remote related ##
git remote add origin git@github.com:username/xxxx.git

git push -u origin master

git remote -v

git branch --set-upstream dev origin/dev

## git log with graph##
git log --graph --pretty=oneline --abbrev-commit

git log --pretty=oneline --abbrev-commit

git config --global alias.lg "log --graph --pretty=format:'%h - %d - %s (%cr) %an' --abbrev-commit"
## git stash ##
git stash

git stash list

git stash apply

git stash drop

git stash pop

git stash list

git stash apply stash@\{0\}

## git tag ##
git tag v0.9 6224937

命令git push origin <tagname>可以推送一个本地标签；

命令git push origin --tags可以推送全部未推送过的本地标签；

命令git tag -d <tagname>可以删除一个本地标签；

命令git push origin :refs/tags/<tagname>可以删除一个远程标签。

<br>
<br>
<br>
<p>{{ page.date | date_to_string }}</p>
