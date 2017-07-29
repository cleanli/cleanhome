---
layout:     post
title:      "【原创】给博客增加归档功能"
date:       2017-07-10 23:15:20 +0800
categories: 技术
tags: ["原创",Jekyll,Liquid,"博客技术"]
---
周末的时候给博客增加了归档（archives）功能，把过程做一下笔记。

一开始找了现成的jekyll-archives，步骤如下：
1. 安装jekyll-archives
```
$ gem install jekyll-archives
```

2. 如下patch
```diff
diff --git a/Gemfile b/Gemfile
index 7f7a43c..f710490 100644
--- a/Gemfile
+++ b/Gemfile
@@ -1,6 +1,7 @@
 source 'https://rubygems.org'
　　 
 group :jekyll_plugins do
+  gem "jekyll-archives"
   gem "jekyll-paginate"
   gem "jekyll-feed"
   gem "jekyll"
diff --git a/_config.yml b/_config.yml
index 0c68a2b..2fd2016 100644
--- a/_config.yml
+++ b/_config.yml
@@ -23,4 +23,11 @@ categories_path: categories.html
 tags_path: tags.html
 permalink: /posts/:month-:day-:year/:title.html
　　 
-gems: [jekyll-paginate, jekyll-feed]
+jekyll-archives:
+  enabled:
+    - year
+  layout: 'year_arch'
+  permalinks:
+    year: '/archives/year/:year.html'
+
+gems: [jekyll-paginate, jekyll-feed, jekyll-archives]
diff --git a/_layouts/year_arch.html b/_layouts/year_arch.html
new file mode 100644
index 0000000..d002f40
--- /dev/null
+++ b/_layouts/year_arch.html
@@ -0,0 +1,11 @@{% raw %}
+---
+layout: page
+---
+
+<h1>{{ page.date | date: "%Y" }}</h1>
+
+<ul class="posts">
+{% for post in page.posts %}
+  <li style="line-height: 35px;"><span class="text-muted">{{ post.date | date: "%Y-%m-%d" }} </span><a href="{{ site.baseurl }}{{node.url}}">{{post.title}}</a></li>
+{% endfor %}
+</ul>{% endraw %}
```

经过测试，本地可以生成archives页面。但上传到github之后没有生成archives页面。后来了解到github好像不支持jekyll-archives。

于是决定自己试着写一个生成归档页面的Liquid代码，原理不复杂，就是统计一下不同时间内的文章数量，显示在网页上。

具体的做法是对博客的所有文章做循环，取出每一篇文章的年份，如果发现年份与上一个不同，就把新的年份记录下来，同时文章计数的数量也记录下来，就是前一个年份的文章数量。
{% raw %}
关于Liquid语法，有几点值得特别做一下笔记：
1. 通过 increment 标记（tag）创建的变量与通过 assign 或 capture 创建的变量是相互独立的。开始参考的code是使用increment做加一计数，结果无法清零，就是这个原因。后来使用plus加一就ok了。
```liquid
    {% assign precount = precount | plus: 1 %}
```
2. Liquid语句在做循环的时候，如果在网页上输出，会造成很多空白行。所以后来采用先做循环找出年份和数量，存在一个字符串里。最后再把结果输出到网页。
3. capture获取的变量都是字符串，开始是用下面这样的写法，就不行，这样得到的precount是字符串
```liquid
    {% capture precount %}{{precount | plus: 1}}{% endcapture %}
```

最后完成的代码如下：
```liquid
{% assign yearstr = "" %}
{% assign precount = 0 %}
{% assign lyear = 0 %}
{% for post in site.posts %}
  {% capture year %}{{ post.date | date: '%Y%m' }}{% endcapture %}
  {% if year != lyear %}
    {% if lyear != 0 %}
       {% capture yearstr %}{{ yearstr | append: '-' }}{% endcapture %}
       {% capture tmpstr %}{{ precount }}{% endcapture %}
       {% if precount < 10 %}
         {% capture yearstr %}{{ yearstr | append: '0' }}{% endcapture %}
       {% endif %}
       {% capture yearstr %}{{ yearstr | append: tmpstr }}{% endcapture %}
       {% capture yearstr %}{{ yearstr | append: ',' }}{% endcapture %}
    {% endif %}
    {% capture yearstr %}{{ yearstr | append: year }}{% endcapture %}
    {% assign precount = 0 %}
  {% endif %}
  {% capture lyear %}{{ post.date | date: '%Y%m' }}{% endcapture %}
  {% assign precount = precount | plus: 1 %}
{% endfor %}
{% capture yearstr %}{{ yearstr | append: '-' }}{% endcapture %}
{% capture tmpstr %}{{ precount }}{% endcapture %}
{% if precount < 10 %}
  {% capture yearstr %}{{ yearstr | append: '0' }}{% endcapture %}
{% endif %}
{% capture yearstr %}{{ yearstr | append: tmpstr }}{% endcapture %}
{% assign yearsgroup = yearstr | split: "," %}
```{% endraw %}

最后得到的yearsgroup类似为：“201703-13,201610-01”，再取出年份和数量写到网页上就可以了

另外发现在markdown文件里面，如果在列表下面引用代码的时候，如果代码里面有空行，会出现乱码，比如本文中引用patch的部分，所以在空行里面添加了中文的空格，^_^
