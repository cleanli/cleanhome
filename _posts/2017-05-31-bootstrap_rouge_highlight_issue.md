---
layout:     post
title:      "【原创】Bootstrap带行号语法高亮的问题"
date:       2017-05-31 22:46:25 +0800
author:     "Clean Li"
categories: 技术
tags: ["原创",Jeklly]
header-img: "img/post-bg-01.jpg"
---
这几天发现在Bootstrap下面使用带行号的语法高亮时，最后的结果有两点奇怪的地方，一个是最上面有一根线，另外一个就是鼠标经过时外框会反白。

最后发现，这是Bootstrap里面表格的特点造成的。在Bootstrap里面表格默认是只有横线的，而带行号的语法高亮实际上是一个一横两列的表格，那么就会在上面有一根横线。而且Bootstrap里面表格当鼠标移动经过时会反白高亮，这样就造成带行号的语法高亮也有这样的现象。

测试发现设置`border: 2px solid transparent`之后，Bootstrap的表格的横线会消失，然后把反白高亮的颜色调成和表格的背景色一样，这样上面两个问题就消失了。

在`css/syntax.css`加上下面的code可以解决这个问题。

```css
.highlight .table {
  border: 2px solid transparent;
  margin-bottom: 0px;
}
.highlight .table > tbody > tr:hover {
  background-color: #202020;/*调成表格默认背景色*/
}
```
