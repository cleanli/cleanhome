---
layout:     post
title:      "【记录】解决火狐不支持网址中文传参数"
date:       2017-06-04 11:02:59 +0800
categories: 技术
tags: ["记录",Jekyll,JavaScript,"博客技术"]
---
发现用火狐浏览器时，从本博客首页的tags链接点击进入tags页面时，如果tag是中文，就不能自动展开那个tag的文章列表。在js中加上alert，把获取的id显示出来，原来中文的id会转换成`%E8%AE%B0`之类的编码。

从网上查到可以使用`decodeURI(url)`还原中文，如果要把中文这样编码可以使用`encodeURI("中文")`。

从alert可以看到转换前后的id
```js
    alert(ih + " -> " + decodeURI(ih));
```
如果使用火狐，就会发现有如下转换，而Chrome则没有这个问题。
```
%E8%AE%B0%E5%BD%95-id -> 记录-id
```

如下code可以fix这个问题
```js
function getid()
{
    var ih;
    ih=location.href.split("#")[1];
    $('#'+decodeURI(ih)).tab("show");
}
```
