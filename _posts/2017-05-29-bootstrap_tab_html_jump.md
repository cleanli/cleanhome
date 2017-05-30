---
layout:     post
title:      "【原创】Bootstrap Tab网页的跳转定位"
date:       2017-05-29 09:31:36 +0800
author:     "Clean Li"
categories: 技术
tags: ["原创",JavaScript,Jeklly]
header-img: "img/post-bg-01.jpg"
---
#### 背景
端午节假期，正好有时间来完善一下自己的博客。我的博客使用的是Bootstrap的Clean Blog模版，正好和我的英文名一样。

这几天的目标是让自己的博客有按类别和标签链接文章的功能，于是从其他人的博客源码中复制了categories.html和tags.html文件，放在jeklly源码的根目录，Categories和Tags菜单就出现在博客首页的右上角。点击他们就可以进入具体的页面，里面会根据类别和标签自动列出相关文章列表。让我比较开心的是里面并不会马上列出所有文章，以Tags页面为例，刚进去页面的时候里面只有标签列表。点击其中某个标签，这个标签的所有文章才会在下面显示出来。这个比我原来想象的要更好，因为如果文章多了的时候，如果按标签把所有文章都列出来，因为用标签来分类许多文章会有重复的，所以文章总数会更多。这样只根据需要显示某一标签的文章，就显得非常需要了，所以觉得很满意。

然后觉得需要在首页的文章列表中每个文章加上相关的类别和标签，这个也容易实现，从categories.html复制显示类别和标签的代码，放到首页显示每篇文章的代码旁边，小小的修改一下，每篇文章旁边就出现了相关的类别和标签。

#### 问题出现
一切都很顺利，于是想要给文章旁边的类别和标签加上链接，通过点击就可以进入类别和标签网页。这时问题出现了，比如在文章旁边点击了某个具体的标签，跳转到标签页面，但标签页面并不是一下列出所有标签的文章。实际上开始进入标签页面的时候，不会显示任何文章列表，需要再点击具体的标签，那个标签的文章列表才会出现。这样就显得很不完美了。如何才能实现从首页文章旁边的标签点击后进入标签页面，自动展开那个标签的文章列表呢？

#### 连连遇挫
在标签页面，每个标签的链接都是页面内部的链接形式，就像这样：
```html
https://cleanli.github.io/cleanhome/tags#Git-ref
```
于是很自然想把首页的标签链接后面加上`#Git-ref`，结果发现，页面跳过去之后并没有出现预想中的自动展开那个标签的文章列表。于是具体看了标签页面的html源码，发现每个标签的链接多了一个`data-toggle`属性：
```html
{% raw %}<a href="#{{ tag[0] }}-ref" data-toggle="tab">{% endraw %}
```
好，那就也在tags页面链接后面加上`data-toggle="tab"`，结果网页不跳转。没有办法，只好使出绝招：“网络搜索”。但百度上搜来搜去也就一篇文章提到这个，还没有给出解决方案。

[bootstrap框架中data-toggle="tab"属性会取消a标签默认行为](http://www.cnblogs.com/wdlhao/p/4504685.html)

没有办法了，因为对网页相关的东西一窍不通，看来只能放弃这个功能了，进去再点击一下标签。要不就让标签网页一下全部显示所有标签的文章列表，放弃文章开头觉得很满意的这个功能。想来想去，还是觉得再研究一下。

#### 再次迷途
于是继续，先解决网页不跳转的问题。经过网上搜索，修改各`.js`、`.css`、`.html`文件测试，最后发现两个地方的code有意限制这个网页跳转的行为。一个是在`js/clean-blog.js`里面（下面第2行）：

{% highlight js linenos %}
    $("a[data-toggle=\"tab\"]").click(function(e) {
        e.preventDefault();
        $(this).tab("show");
    });
{% endhighlight %}

另一个是在文件`js/bootstrap.js`（下面第5行）
{% highlight js linenos %}
  // TAB DATA-API
  // ============

  var clickHandler = function (e) {
    e.preventDefault()
    Plugin.call($(this), 'show')
  }

  $(document)
    .on('click.bs.tab.data-api', '[data-toggle="tab"]', clickHandler)
    .on('click.bs.tab.data-api', '[data-toggle="pill"]', clickHandler)
{% endhighlight %}

将`clean-blog.js`和`bootstrap.js`的`e.preventDefault();`注释掉之后，网页可以跳转了，但结果就和不加`data-toggle="tab"`的效果是一样的，进入标签页面后不会自动展开指定的标签。

反思一下，觉得`data-toggle="tab"`这个属性与Tab的具体实现有关，而这个功能可能就是限定在同一个页面的，所以限定网页跳转是合理的。现在要实现从另外一个网页跳转过来，应该与这个属性无关。

#### 补充知识
实在没有办法了，只好老老实实学习一下网页相关的知识吧。鉴于刚才都是改`.js`文件，所以应该与JavaScript有关，于是找到这个网站看了一下：

[W3school](http://www.w3school.com.cn/index.html)

一下明白了好些网页编程JS相关知识，还有JQuery，现在的网络技术学习查找资料就是方便，这里感谢一下那个网站无私奉献的人们~

#### 希望曙光
根据刚学到的知识，标签网页里面点击某个标签就显示其文章列表的行为，应该也是通过JS改变某些元素的是否可见实现的，于是尝试在标签网页加载的时候，通过id找到那个标签的tab，强制使它显示出来，果然可以实现进入网页就可以自动显示那个标签了。希望的曙光啊哈哈~代码如下：

```html
<script>
function mymessage()
{
  document.getElementById("tech-ref").style.display="block";
}
</script>
<body onload="mymessage()">
</body>

```

#### 标志性突破
但是，这样做了之后，点击其他的标签的时候，这个标签不会隐藏了。这说明这样的改动是“粗暴”的行为，是从最底层直接干涉上层功能的实现，这是文明社会不提倡的。肯定有某些特定的接口可以调用来做这件事情。于是又找到一个网站学习了一下

[Togglable tabs](http://getbootstrap.com/javascript/#tabs)

>## Usage ##
>Enable tabbable tabs via JavaScript (each tab needs to be activated individually):
```js
$('#myTabs a').click(function (e) {
  e.preventDefault()
  $(this).tab('show')
})
```
>You can activate individual tabs in several ways:
>```js
$('#myTabs a[href="#profile"]').tab('show') // Select tab by name
$('#myTabs a:first').tab('show') // Select first tab
$('#myTabs a:last').tab('show') // Select last tab
$('#myTabs li:eq(2) a').tab('show') // Select third tab (0-indexed)
```

回想刚才修改网页跳转的功能的时候，也看到类似的代码，于是通过反复测试，把下面代码替换刚才强制改显示标签的代码：
```js
$("a[href='#life-ref']").tab("show");
```
发现可以实现进入网页就展开某个标签了，而且也不影响后续的操作，这是标志性的突破啊。接下来就是要在加载网页的时候要知道展开哪个标签，因为我们从首页跳转过来的时候链接的url最后有`#XX-id`，所以从这个可以取到要展开的标签。从网上搜索到这样可以提取：
```js
location.href.split("#")[1];
```

#### 完美结局
最后遇到的一个问题是，jQuery选择器选择某个元素的时候，都是直接使用具体的参数，比如`$("#intro")`就是取id=“intro” 的元素。我们要根据传进来的网址后面的id，所以jQuery要能根据变量来选择元素，这个通过网上搜索解决了，要通过“+”来实现，比如要取id为变量ih的元素，可以这样`$('#'+ih)`

总结一下，最后的解决办法是：
1. 首页上的标签链接最后加上‘#’和标签的id，通过这种形式传入tags网页
2. tags网页加载的时候，通过一段js代码，取出需要马上展开的标签id
3. 调用bootstrap提供的tab的API，展开那个标签

最后的代码如下，总共才10行，加在tags和categories的md文件最后就可以：
```html
<script>
function getid()
{
    var ih;
    ih=location.href.split("#")[1];
    $('#'+ih).tab("show");
}
</script>
<body onload="getid()">
</body>
```
最后的效果自己很满意。这个问题整整花了一天时间，整个过程很曲折，但最后峰回路转，还是很开心，也熟悉了一下网页编程的相关知识，对于一个比较多和驱动代码打交道的人，也是觉得挺有意思的。
