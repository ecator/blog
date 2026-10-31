---
title: 为 Windows 文件夹与文件添加「Open with Antigravity IDE」右键菜单
description: 解决 Windows 安装 Antigravity IDE 后右键菜单未生效的问题。提供免管理员权限的批处理脚本与注册表配置，同时支持文件、文件夹及空白处快速打开项目。
pubDate: "2026-10-31"
updatedDate: "2026-10-31"
tags: ["Antigravity IDE", "Windows", "注册表", "效率技巧"]
heroImage: "./_assets/20261031_antigravity-menu-command-hero.jpg"
---

在 Windows 上安装 **Antigravity IDE** 时，即使在安装向导中勾选了「添加到右键上下文菜单」，有时也可能因系统权限、策略拦截或安装器未成功写入导致右键菜单缺失。

因为 Antigravity IDE 默认采用当前用户安装（位于 `%LOCALAPPDATA%`），我们直接写入当前用户的注册表分支（`HKCU\Software\Classes`）即可生效，**完全不需要管理员权限**，既安全又不会污染系统全局。

---

## 1. 默认安装路径确认

Antigravity IDE 默认的可执行程序路径为：

```text
%LOCALAPPDATA%\Programs\Antigravity IDE\Antigravity IDE.exe
```

> **提示**：若你的 IDE 安装在自定义路径（如 `D:\Tools\Antigravity IDE\Antigravity IDE.exe`），只需将后文脚本中的路径相应替换即可。

---

## 2. 方案一：CMD 命令行快速执行（免管理员权限）

按 <kbd>Win</kbd> + <kbd>R</kbd> 输入 `cmd` 打开普通的命令提示符（**无需以管理员身份运行**），直接粘贴并执行以下命令：

```bat
:: 1. 选中文件夹右键
reg add "HKCU\Software\Classes\Directory\shell\Antigravity IDE" /ve /t REG_SZ /d "Open with Antigravity IDE" /f
reg add "HKCU\Software\Classes\Directory\shell\Antigravity IDE" /v "Icon" /t REG_SZ /d "%LOCALAPPDATA%\Programs\Antigravity IDE\Antigravity IDE.exe" /f
reg add "HKCU\Software\Classes\Directory\shell\Antigravity IDE\command" /ve /t REG_SZ /d "\"%LOCALAPPDATA%\Programs\Antigravity IDE\Antigravity IDE.exe\" \"%1\"" /f

:: 2. 文件夹内部空白处右键
reg add "HKCU\Software\Classes\Directory\Background\shell\Antigravity IDE" /ve /t REG_SZ /d "Open with Antigravity IDE" /f
reg add "HKCU\Software\Classes\Directory\Background\shell\Antigravity IDE" /v "Icon" /t REG_SZ /d "%LOCALAPPDATA%\Programs\Antigravity IDE\Antigravity IDE.exe" /f
reg add "HKCU\Software\Classes\Directory\Background\shell\Antigravity IDE\command" /ve /t REG_SZ /d "\"%LOCALAPPDATA%\Programs\Antigravity IDE\Antigravity IDE.exe\" \"%V\"" /f

:: 3. 任意文件右键（可选：支持在代码文件或文本文件上直接打开）
reg add "HKCU\Software\Classes\*\shell\Antigravity IDE" /ve /t REG_SZ /d "Open with Antigravity IDE" /f
reg add "HKCU\Software\Classes\*\shell\Antigravity IDE" /v "Icon" /t REG_SZ /d "%LOCALAPPDATA%\Programs\Antigravity IDE\Antigravity IDE.exe" /f
reg add "HKCU\Software\Classes\*\shell\Antigravity IDE\command" /ve /t REG_SZ /d "\"%LOCALAPPDATA%\Programs\Antigravity IDE\Antigravity IDE.exe\" \"%1\"" /f
```

---

## 3. 方案二：一键批处理脚本（.bat）

如果你希望保存为脚本随时在新机器上一键运行，新建文本文件并保存为 `add_antigravity_menu.bat`：

```bat
@echo off
chcp 65001 >nul
echo 正在为当前用户注入 Antigravity IDE 右键菜单...

set "IDE_EXE=%LOCALAPPDATA%\Programs\Antigravity IDE\Antigravity IDE.exe"

:: 1. 选中文件夹右键
reg add "HKCU\Software\Classes\Directory\shell\Antigravity IDE" /ve /t REG_SZ /d "Open with Antigravity IDE" /f
reg add "HKCU\Software\Classes\Directory\shell\Antigravity IDE" /v "Icon" /t REG_SZ /d "%IDE_EXE%" /f
reg add "HKCU\Software\Classes\Directory\shell\Antigravity IDE\command" /ve /t REG_SZ /d "\"%IDE_EXE%\" \"%%1\"" /f

:: 2. 文件夹空白处右键
reg add "HKCU\Software\Classes\Directory\Background\shell\Antigravity IDE" /ve /t REG_SZ /d "Open with Antigravity IDE" /f
reg add "HKCU\Software\Classes\Directory\Background\shell\Antigravity IDE" /v "Icon" /t REG_SZ /d "%IDE_EXE%" /f
reg add "HKCU\Software\Classes\Directory\Background\shell\Antigravity IDE\command" /ve /t REG_SZ /d "\"%IDE_EXE%\" \"%%V\"" /f

:: 3. 单个文件右键
reg add "HKCU\Software\Classes\*\shell\Antigravity IDE" /ve /t REG_SZ /d "Open with Antigravity IDE" /f
reg add "HKCU\Software\Classes\*\shell\Antigravity IDE" /v "Icon" /t REG_SZ /d "%IDE_EXE%" /f
reg add "HKCU\Software\Classes\*\shell\Antigravity IDE\command" /ve /t REG_SZ /d "\"%IDE_EXE%\" \"%%1\"" /f

echo.
echo ==============================================
echo  添加完成！无需重启即可在资源管理器中体验。
echo ==============================================
pause
```

> **注意**：在 `.bat` 批处理文件中，`%1` 与 `%V` 需要转义为 `%%1` 与 `%%V`，否则会被批处理解释器提前置空。

---

## 4. 卸载与清理

若日后更换了安装路径或需要完全移除该右键菜单，运行以下清理命令即可：

```bat
reg delete "HKCU\Software\Classes\Directory\shell\Antigravity IDE" /f
reg delete "HKCU\Software\Classes\Directory\Background\shell\Antigravity IDE" /f
reg delete "HKCU\Software\Classes\*\shell\Antigravity IDE" /f
```

---

## 5. 常见问题与小贴士

1. **Windows 11 新版右键菜单折叠**：
   - Windows 11 默认会将传统的右键菜单项收纳在 **「显示更多选项」** 内；
   - 可以在右键时按住 <kbd>Shift</kbd> 键，或者直接按下快捷键 <kbd>Shift</kbd> + <kbd>F10</kbd> 呼出经典右键菜单。
2. **全局所有用户（HKCR）适用场景**：
   - 如果你的 Antigravity IDE 安装在全局目录（如 `C:\Program Files`）并希望让多用户均可使用，可将 `HKCU\Software\Classes` 替换为 `HKEY_CLASSES_ROOT`，此时需要以管理员身份运行 CMD 执行。
