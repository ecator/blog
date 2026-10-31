---
title: 文件夹添加[Open with Antigravity IDE]右键菜单
description: 文件夹添加[Open with Antigravity IDE]右键菜单。
pubDate: "2026-10-31"
updatedDate: "2026-10-31"
tags: ["Antigravity IDE"]
---

安装Antigravity IDE后就算选了在文件夹添加右键菜单也没有用，可以尝试用管理员运行下面的cmd命令添加注册表：

```bat
:: For background of folders
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\Antigravity IDE" /ve /t REG_SZ /d "Open with Antigravity IDE" /f

:: Icon
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\Antigravity IDE" /v "Icon" /t REG_SZ /d "%LOCALAPPDATA%\Programs\Antigravity IDE\Antigravity IDE.exe" /f

:: Command
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\Antigravity IDE\command" /ve /t REG_SZ /d "\"%LOCALAPPDATA%\Programs\Antigravity IDE\Antigravity IDE.exe\" \"%V\"" /f
```