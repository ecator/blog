---
layout: post
title: windows下nginx命令行
author: Martin
tags: nginx windows
---

将nginx安装目录加入到环境变量后把`nginx.exe`重命名为`nginx-server.exe`，最后将如下代码保存为`nginx.cmd`后复制到nginx安装目录

```
@echo off
if "%0%*"=="nginx" (
	::启动进程
	start %~dp0nginx-server.exe -p %~dp0
	exit
)
if "%*"=="-s stop" (
	::杀死所有进程
	taskkill /f /fi "imagename eq nginx*" > nul
) else (
	%~dp0nginx-server.exe -p %~dp0 %*
)
```