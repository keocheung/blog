---
date: '2025-05-16T05:22:34+08:00'
draft: false
title: '博客启动'
---

最近因为一连串的各种事情，有了很多人生感悟，总算是想把博客这个事情捡起来了，争取以后多点记录，多点输出。

### 关于技术栈
文章的原始载体是Markdown文档，使用[Hugo](https://gohugo.io/)生成静态网页，托管于[GitHub Pages](https://keocheung.github.io/blog/)上，域名也不用自己的了，`github.io`就挺好的。

另外大部分的文章会在[xLog](https://keo.xlog.app/)上同步放一份，相比于GitHub Pages多了评论功能，说是基于区块链的Web3 Blog，应该能撑挺长时间的吧（）

### 关于排版
鉴于主流浏览器已经支持[CSS text-autospace](https://caniuse.com/mdn-css_properties_text-autospace)，本博客不会在西文和CJK字符之间添加空格，浏览器会自动添加中英文之间的间隔。

Google Chrome 119以上可以在[实验性功能](chrome://flags/)里打开[Experimental Web Platform features](chrome://flags/#enable-experimental-web-platform-features)，然后重启浏览器即可生效。

Safari 18.4以上已经原生支持，不需要用户手动开启功能，但需要网页开发者添加以下样式：

```css
body {
    text-autospace: normal;
}
```
详情可参考[WebKit的官方文章](https://webkit.org/blog/16574/webkit-features-in-safari-18-4/#text-auto-space)，本博客的源站已经添加上述样式。