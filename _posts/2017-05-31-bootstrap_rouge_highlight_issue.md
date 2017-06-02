---
layout:     post
title:      "【原创】Bootstrap带行号语法高亮的问题"
date:       2017-05-31 22:46:25 +0800
author:     "Clean Li"
categories: 技术
tags: ["原创",Jeklly]
---
这几天发现在Bootstrap下面使用带行号的语法高亮时，最后的结果有两点奇怪的地方，一个是最上面有一根线，另外一个就是鼠标经过时外框会反白。

最后发现，这是Bootstrap里面表格的特点造成的。在Bootstrap里面表格默认是只有横线的，而带行号的语法高亮实际上是一个一横两列的表格，那么就会在上面有一根横线。而且Bootstrap里面表格当鼠标移动经过时会反白高亮，这样就造成带行号的语法高亮也有这样的现象。如下面这个表格：

<pre>
<table class="table">
  <caption>BootStrap里加上"pre"标签的表格</caption>
  <thead>
    <tr>
      <th>名称</th>
      <th>城市</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Tanmay</td>
      <td>Bangalore</td>
    </tr>
    <tr>
      <td>Sachin</td>
      <td>Mumbai</td>
    </tr>
  </tbody>
</table>
</pre>

测试发现设置`border: 2px solid transparent`之后，Bootstrap的表格的横线会消失，然后把反白高亮的颜色调成和表格的背景色一样，这样上面两个问题就消失了。

还有一个宽度的问题，Bootstrap的表格宽度默认设为100%，在语法高亮时会导致行号宽度过大，需要把宽度设回自动。

在`css/syntax.css`加上下面的code可以解决上面说的问题。

```css
.highlight .table {
  width: auto;
  border: 2px solid transparent;
  margin-bottom: 0px;
}
.highlight .table > tbody > tr:hover {
  background-color: #202020;/*调成表格默认背景色*/
}
```
下面这个是修改之前的语法高亮：

<figure><pre><code class="language-c--" data-lang="c++"><table style="border-spacing: 0"><tbody class="highlight"><tr><td class="gutter gl" style="text-align: right"><pre class="lineno">1
2
3
4
5
6
7</pre></td><td class="code"><pre><span class="kt">void</span> <span class="nf">main</span><span class="p">()</span>
<span class="p">{</span>
    <span class="kt">int</span> <span class="n">i</span> <span class="o">=</span> <span class="mi">0</span><span class="p">;</span>
    <span class="k">for</span><span class="p">(</span><span class="n">i</span> <span class="o">=</span> <span class="mi">0</span><span class="p">;</span> <span class="n">i</span> <span class="o">&lt;</span> <span class="mi">9</span><span class="p">;</span> <span class="n">i</span><span class="o">++</span><span class="p">){</span>
        <span class="n">print</span><span class="p">(</span><span class="s">"i = %d</span><span class="se">\n</span><span class="s">"</span><span class="p">,</span> <span class="n">i</span><span class="p">);</span>
    <span class="p">}</span>
<span class="p">}</span><span class="w">
</span></pre></td></tr></tbody></table></code></pre></figure>

对比修改之后：

{% highlight c++ linenos %}
void main()
{
    int i = 0;
    for(i = 0; i < 9; i++){
        print("i = %d\n", i);
    }
}
{% endhighlight %}
