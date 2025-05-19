---
date: '{{ .Date }}'
draft: true
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
---

---

本文章发布在以下多个网站：
<br>
[GitHub Pages](https://keocheung.github.io/blog/posts/{{ .File.ContentBaseName }}/)
<br>
[xLog](https://keo.xlog.app/{{ .File.BaseFileName }}md)（可评论）
