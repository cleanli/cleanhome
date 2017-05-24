---
layout:     post
title:      "【原创】Github建博客"
subtitle:   "记录及总结，备忘"
date:       2017-05-21 10:38:45 +0800
author:     "Clean Li"
categories: tech
tags: [Git,Github,Jeklly]
header-img: "img/post-bg-01.jpg"
---
Github使用jeklly生成博客，主要步骤是先找一个博客模版，然后把自己的文章添加到`_post`目录，再提交到Github上去，就完成了。

但在这之前，需要建立一个jeklly的本地系统，因为需要先在本地观察网页效果。下面这篇文章介绍了如何在windows下安装jeklly：<br>
[Run Jekyll on Windows](http://jekyll-windows.juthilo.com/)

这个是一个Windows下的Portable Jekyll，没有试过，先收藏在这里。<br>
[Portable Jekyll](https://github.com/madhur/PortableJekyll)

Jekyll可以将纯文本转化为静态网站和博客，不需要数据库，而且可以免费部署在Github上。这是他的中文文档：<br>
[Jekyll中文](http://jekyll.com.cn/)

Jekyll安装好后，用git把博客模版代码拉到本地，可以直接测试默认效果：
```console
$ git clone https://github.com/BlackrockDigital/startbootstrap-clean-blog-jekyll.git
Cloning into 'startbootstrap-clean-blog-jekyll'...
remote: Counting objects: 512, done.
remote: Total 512 (delta 0), reused 0 (delta 0), pack-reused 512
Receiving objects: 100% (512/512), 1.99 MiB | 562.00 KiB/s, done.
Resolving deltas: 100% (283/283), done.
Checking connectivity... done.

$ ls
startbootstrap-clean-blog-jekyll/

$ cd startbootstrap-clean-blog-jekyll/

$ ls
_config.yml  _site/        fonts/        img/        LICENSE
_includes/   about.html    Gemfile       index.html  mail/
_layouts/    contact.html  Gemfile.lock  js/         package.json
_posts/      css/          Gruntfile.js  less/       README.md


$ jekyll serve
Configuration file: C:/t/n2/startbootstrap-clean-blog-jekyll/_config.yml
Configuration file: C:/t/n2/startbootstrap-clean-blog-jekyll/_config.yml
            Source: C:/t/n2/startbootstrap-clean-blog-jekyll
       Destination: C:/t/n2/startbootstrap-clean-blog-jekyll/_site
 Incremental build: disabled. Enable with --incremental
      Generating...
                    done in 0.813 seconds.
  Please add the following to your Gemfile to avoid polling for changes:
    gem 'wdm', '>= 0.1.0' if Gem.win_platform?
 Auto-regeneration: enabled for 'C:/t/n2/startbootstrap-clean-blog-jekyll'
Configuration file: C:/t/n2/startbootstrap-clean-blog-jekyll/_config.yml
    Server address: http://127.0.0.1:4000/startbootstrap-clean-blog-jekyll/
  Server running... press ctrl-c to stop.
```

目录下各主要部分的作用：<br>
- \_config.yml
这个文件是为了保存配置的。所谓的配置，其实可以用在命令行里面。放在这个文件里面主要是比较方便。下面这个要配成与github的repository名字一样：
```yaml
baseurl: /cleanhome
```
- \_includes
这里面的就是可以重复利用的文件。这个文件可以被其他的文件包含，重复利用。下面就是引用file.ext的格式。
```liquid
{ % include file.ext % }
```
- \_layouts
这里存放的是不同类型的网页模板文件。
- \_posts
这里的文件就实际的文章内容了。文件名必须使用YEAR-MONTH-DATE-title.MARKUP的格式。如果使用textile的话，扩展名就是textile。对于目录下的每个文件，使用YAML Front Matter之后，都会被转格式，然后生成最终文件。
- \_site
这个文件夹存放的是最终生成的文件。

测试发现修改语法高亮的配色可以修改css/syntax.css文件
{% highlight css %}
/*
 * GitHub style for Pygments syntax highlighter, for use with Jekyll
 * Courtesy of GitHub.com
 */

.highlight pre, pre, .highlight .hll
 {
  color: #ffffff;
  background-color: #000000;
  border: 1px solid #ccc;
  padding: 6px 10px;
  border-radius: 3px;
 }
.highlight .c { color: #75715e } /* Comment */
.highlight .err { color: #960050; background-color: #1e0010 } /* Error */
.highlight .k { color: #66d9ef } /* Keyword */
.highlight .l { color: #ae81ff } /* Literal */
.highlight .n { color: #f8f8f2 } /* Name */
.highlight .o { color: #f92672 } /* Operator */
.highlight .p { color: #f8f8f2 } /* Punctuation */
.highlight .cm { color: #75715e } /* Comment.Multiline */
.highlight .cp { color: #75715e } /* Comment.Preproc */
.highlight .c1 { color: #75715e } /* Comment.Single */
.highlight .cs { color: #75715e } /* Comment.Special */
.highlight .ge { font-style: italic } /* Generic.Emph */
.highlight .gs { font-weight: bold } /* Generic.Strong */
{% endhighlight %}

这个网页可以查支持的语法及其short name：<br>
[Available lexers](http://pygments.org/docs/lexers/#lexers-for-css-and-related-stylesheet-formats)

做相关配置及调整之后，依然可以运行这个命令本地观察一下效果：
```shell
$ jekyll serve
...
    Server address: http://127.0.0.1:4000/cleanhome/
      Server running... press ctrl-c to stop.

```

觉得可以之后，就可以上传到github。先在github建立一个新repository（比如“blogtest"），把它拉到本地，再把刚才修改的所有文件放到这里，本地git commit，再git push上传。命令如下：
```console
$ cd ..

$ mkdir new

$ cd new

$ git clone https://github.com/xxxx/blogtest.git

$ cd blogtest

$ cp ../startbootstrap-clean-blog-jekyll/* -rf .

$ vi .gitignore
```

在`.gitignore`里面加上下面内容：
```
_site
node_modules
Gemfile.lock
```

继续
```console
$ git add .

$ git commit -m "init blog"

$ git push
```

到github的reopsitory的setting下面，到Github Page项，在Source下面选择branch，点Save就可以看到网页开始工作了。下面是本博客的Github Page：
![Github Page]({{ site.baseurl }}/img/github_jeklly/githubpage.png)<br>
