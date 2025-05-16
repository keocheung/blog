---
date: '2025-05-16T06:59:37+08:00'
draft: false
title: '在macOS上为mpv启用Fontconfig支持以解决若干字体问题'
tags:
    - font
    - video
    - macos
---

## 前言
对视频播放有所研究的朋友应该都对[mpv](https://mpv.io/)这个功能丰富，配置灵活的播放器不陌生，其中的[Conditional auto profiles](https://mpv.io/manual/master/#conditional-auto-profiles)功能甚得我心，比如说你可以通过下面的配置实现不同语言的字幕使用不同的字体：

```ini
[zh-Hans]
profile-cond=string.sub(get("current-tracks/sub/lang"), 1, 7) == "zh-Hans"
sub-font='Source Han Sans SC'

[zh-Hant]
profile-cond=string.sub(get("current-tracks/sub/lang"), 1, 7) == "zh-Hant"
sub-font='Source Han Sans HC'
```
mpv同时也是许多其他播放器的内置模块，比如[IINA](https://iina.io/)和[Jellyfin Media Player](https://github.com/jellyfin/jellyfin-media-player)，这两个播放器也支持自定义的mpv配置。

关于mpv的更多配置项，可参考[VCB-S的入门教程](https://vcb-s.com/archives/7594)。

## 问题

mpv使用[libass](https://github.com/libass/libass)渲染SRT等纯文本字体，而libass在macOS上默认使用CoreText作为font provider读取字体，这带来了一些问题。

首先是可变字体，libass只能读取到最细的样式，`--sub-bold=yes`参数也无法生效（测试了Noto Sans CJK系列和Fira Code都是如此）。

其次是字幕中的Emoji，libass无法显示，我猜是因为fallback到了一个彩色的Emoji字体，而libass只支持单色（monochrome）字体（[相关issue](https://github.com/libass/libass/issues/381)。

查阅了资料发现libass在Linux上使用的Fontconfig也是支持macOS的，而Fontconfig有着丰富的自定义配置功能。抱着死马当活马医的想法，我试了试用Fontconfig替换掉CoreText，结果确实可以解决上述两个问题。

## 实操

以下使用Homebrew安装启用Fontconfig支持的libass。

首先安装Fontconfig：

```bash
brew install fontconfig
```

Homebrew上的libass默认是不会在macOS上启用Fontconfig的，我们需要先修改编译脚本。

最新版的Homebrew默认使用API的方式获取安装脚本，而不是克隆tap仓库，这里先暂时禁用API模式。

```bash
export HOMEBREW_NO_INSTALL_FROM_API=1
brew update
```

```bash
brew edit libass
```

把formula code里fontconfig相关的Linux条件删除，再删除`--disable-fontconfig`参数，然后重新从源码安装libass：

```bash
brew reinstall --build-from-source libass
```

到这一步Homebrew安装的mpv已经可以使用`--sub-font-provider=fontconfig`参数来启用Fontconfig了。

修改`~/.config/fontconfig/fonts.conf`，将mpv中使用的字体名设置为一系列字体的别名，就可以自定义fallback顺序了：

```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "/opt/homebrew/share/xml/fontconfig/fonts.dtd">
<fontconfig>
  <include ignore_missing="yes">/opt/homebrew/etc/fonts/fonts.conf</include>

  <alias>
    <family>Source Han Sans HC</family>
    <prefer>
      <family>Noto Sans CJK HK</family>
      <family>Noto Emoji</family>
    </prefer>
  </alias>
</fontconfig>
```

这里使用的是monochrome的Emoji字体[Noto Emoji](https://fonts.google.com/noto/specimen/Noto+Emoji)

最后，IINA和Jellyfin Media Player使用的是自带的libmpv和libass，需要使用`/opt/homebrew/lib/libass.9.dylib`替换掉各自包内的`libass.9.dylib`