---
layout: post
title: 基于Automator的mpv启动器
author: 易小猫
tags: mac
---

mpv是一个全平台的视频播放器，我的主力电脑是mac，在知道mpv之前一直用迅雷的一款叫Xplayer的播放器，但是功能有限，连最基本快进都没有。在一个偶然的机会遇到了mpv，mpv功能很强大，几乎支持所有格式，但是是一款命令行的播放器，所以每次要播放视频的时候都需要在终端里面敲`mpv 视频1 视频2 ....`这样的命令，看着非常极客，但是实际上非常麻烦，远没有直接鼠标点两下直接播放来得快，所以也是为了方便自己，基于mac的Automator制作了一个mpv的启动器。
<!--description-->

# 安装
## mpv本体

既然是本次的主角是mpv启动器，所以使用之前还得安装mpv的本体，大家可以去官网[mpv.io](https://mpv.io/)或者安装了[homebrew](https://brew.sh/)的话直接在命令行敲`brew install mpv`。安装成功后大家可以在命令行中敲`mpv 视频路径`来试试是否能播放。

> mac命令行打开方式：`command + space`输入`ter`关键词出来的第一个就是。

## mpv启动器

[下载mpv.app.zip]({{ '/assets/mpv.app.zip' | prepend: site.baseurl }})后把解压后的**mpv.app**移动到访达中的**应用程序**目录，这样你就能在启动台中看到mpv了。


![移动到应用程序目录]({{ '/assets/img/mpv-launcher-for-mac-install-0.png' | prepend: site.baseurl }})

# 使用

不出意外安装成功后右击视频文件在打开选项中就会出现mpv了:smile:
> 而且相应文件的图标也变了有木有 :wink:

![打开方式中出现mpv]({{ '/assets/img/mpv-launcher-for-mac-usage-0.png' | prepend: site.baseurl }})

当然你也可以直接双击文件打开（前提是要设置一下默认打开方式：右键-显示简介-打开方式选择mpv-全部更改）或者在启动台中点击mpv后会直接弹出文件选择对话框。另外也可以一次性选择多个文件打开，mpv会按照文件的顺序依次播放。

最后再说几个我自己常用的mpv的快捷键：
- `left` `right`：回退或者快进5秒
- `9` `0`：音量减小或者增大
- `[` `]`：慢速或者快速播放
- `<` `>`: 播放前一个视频或者后一个，前提是一次性打开了多个文件，而且输入法必须在英文状态
- `f`：全屏切换
- `space`：暂停
- `q`：退出
- `Q`：保存进度退出，下次再打开这个文件的时候从退出的地方开始播放
- `s`：截图

说到底这其实就是一个mpv的启动器，真正强大的还是mpv本身，关于mpv的更多使用方法请参考官网。