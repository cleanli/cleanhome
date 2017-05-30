---
layout:     post
title:      "【收藏】如何语法高亮Liquid代码"
date:       2017-05-31 00:26:43 +0800
author:     "Clean Li"
categories: 技术
tags: ["收藏",Jeklly]
header-img: "img/post-bg-01.jpg"
---
Jeklly使用Liquid语言，所以如果想在Jeklly的网页中展示Liquid代码，会被解释成Liquid代码，并不会显示在网页上。在网上找了一下，要想把Liquid代码显示出来，Liquid提供了一个特殊的命令：

`{% raw %}{% raw %}{% endraw %}`

所以如果要显示下面的代码：

```yaml
{% raw %}title:{{ site.title }}
githubname:{{ site.githubname }}{% endraw %}
```

实际要这样写：
<img src="{{ site.baseurl }}/img/liquid_hl/liquid_raw.png" alt="Code of Liquid Highlight">
