---
title:  配置Git用户信息
description: 配置Git用户信息
pubDate: "2016-11-06"
updatedDate: "2026-10-18"
tags: ["git", "cvs"]
---

配置个人的用户名称和电子邮件地址：

```sh
git config --global user.name "misaka"
git config --global user.email mikoto@misaka.cool
```

> 如果用了 --global 选项，那么更改的配置文件就是位于你用户主目录下的那个，以后你所有的项目都会默认使用这里配置的用户信息。
如果要在某个特定的项目中使用其他名字或者电邮，只要去掉 --global 选项重新配置即可，新的设定保存在当前项目的 .git/config 文件里。