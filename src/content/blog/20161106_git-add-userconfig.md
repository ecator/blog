---
title: 配置Git用户信息
description: 全面解析 Git 用户名与邮箱配置方法、三个配置层级及优先级规则、单仓库独立设置、使用 includeIf 实现优雅的多账号隔离，以及修改历史作者等常见问题排查。
pubDate: "2016-11-06"
updatedDate: "2026-10-18"
tags: ["git", "cvs"]
---

在安装完成 Git 后的第一步，通常就是配置个人的用户名称与电子邮件地址。每次 Git 提交（Commit）都会引用这些信息，并且它们会永久写入到你的每一次版本提交记录中，不可或缺。

---

## 1. 基础配置：用户名与邮箱

### 1.1 设置全局身份信息

使用 `--global` 参数配置全局默认的用户名称和邮箱：

```bash
git config --global user.name "misaka"
git config --global user.email mikoto@misaka.cool
```

> **注意**：这里的用户名和邮箱主要用于标识提交者的身份。如果你使用 GitHub、GitLab 等托管平台，建议邮箱与平台上绑定的邮箱保持一致，以便正确关联头像与贡献图表（绿格子）。

### 1.2 查看当前配置

可以通过以下命令检查当前的配置信息：

```bash
# 查看当前生效的用户名与邮箱
git config user.name
git config user.email

# 列出所有配置项
git config --list

# 查看配置项及其所在的文件路径（快速排查配置来源）
git config --list --show-origin
```

---

## 2. Git 配置的三个层级与优先级

Git 拥有三个不同作用域的配置层级，了解它们的覆盖规则可以避免许多环境冲突问题：

| 层级 | 参数选项 | 作用范围 | 配置文件存储路径 |
| :--- | :--- | :--- | :--- |
| **System（系统级）** | `--system` | 适用于操作系统中的所有用户及所有仓库 | Linux: `/etc/gitconfig`<br>Windows: `C:\Program Files\Git\etc\gitconfig` |
| **Global（全局用户级）** | `--global` | 适用于当前操作系统的当前用户下的所有仓库 | Linux/macOS: `~/.gitconfig`<br>Windows: `C:\Users\<username>\.gitconfig` |
| **Local（仓库级）** | `--local` | 仅适用于当前所在的单个 Git 仓库（缺省默认选项） | 当前仓库下的 `.git/config` |

### 优先级顺序

$$ \text{Local（仓库级）} > \text{Global（全局级）} > \text{System（系统级）} $$

每一个级别都会覆盖上一级别的同名配置。例如：如果当前仓库设置了 `local` 的 `user.name`，Git 将优先使用它，而忽略 `global` 中的配置。

---

## 3. 为单个仓库设置独立身份

如果你在公司项目或特定开源项目中需要使用不同的姓名或工作邮箱，只需进入该项目根目录，并在配置时去掉 `--global`（或显式指定 `--local`）：

```bash
cd /path/to/work-project

# 仅对当前项目生效
git config --local user.name "work-name"
git config --local user.email "work@company.com"
```

该设置会直接写入当前项目下的 `.git/config`，不会对你的其他个人项目产生任何影响。

---

## 4. 进阶：优雅的多账号管理方案（个人 / 工作隔离）

如果手头同时有**个人开源项目**和**公司内部项目**，手动在每个新仓库执行 `git config --local` 很容易疏忽遗漏，导致用个人邮箱提交了公司代码，或反之。

从 **Git 2.13** 开始，支持通过 `includeIf` 根据仓库所在的文件夹路径自动引入不同的配置文件。

### 推荐目录结构

建议按工作类型规范本地工作目录：

```text
~/development/
├── personal/        # 存放个人项目
│   ├── blog/
│   └── side-project/
└── work/            # 存放公司项目
    ├── project-a/
    └── project-b/
```

### 配置步骤

1. **主全局配置** `~/.gitconfig`（默认使用个人信息，并对工作目录进行条件引入）：

   ```ini
   [user]
       name = PersonalName
       email = personal@example.com

   # 当仓库位于 ~/development/work/ 及其子目录时，加载额外的配置
   [includeIf "gitdir:~/development/work/"]
       path = ~/.gitconfig-work
   ```

2. **工作专用配置** `~/.gitconfig-work`（仅覆盖用户信息）：

   ```ini
   [user]
       name = WorkName
       email = work@company.com
   ```

> **小贴士**：Windows 路径注意使用正斜杠 `/`，例如 `gitdir:D:/development/work/`。路径末尾的斜杠 `/` 表示包含该目录下的所有子目录。

配置完成后，只要你在 `work/` 目录下克隆或新建仓库，Git 就会自动匹配公司邮箱，无需手动切换。

---

## 5. 常见问题与排查指南

### 5.1 刚提交完才发现作者邮箱填错了，如何修正？

如果是**最近一次**提交的信息错误，且尚未推送到远程仓库，可以快速修复：

```bash
# 1. 确保先修正当前仓库的配置
git config user.name "CorrectName"
git config user.email "correct@example.com"

# 2. 重置最近一次提交的作者信息，并保留原提交说明
git commit --amend --reset-author --no-edit
```

### 5.2 GitHub / GitLab 提交没有计入个人主页（不亮绿格子）？

- 请确认本地提交使用的 `user.email` 是否已经添加到托管平台的账户邮箱列表中。
- 确认该邮箱已经在托管平台完成了邮箱验证（Verified）。

### 5.3 如何删除/重置已设置的配置？

如果想清除某一层级的特定配置，可以使用 `--unset`：

```bash
# 删除本地仓库中的配置
git config --unset --local user.name
git config --unset --local user.email

# 删除全局配置
git config --unset --global user.name
git config --unset --global user.email
```