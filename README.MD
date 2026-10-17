# ⚡ Misaka Blog (`blog.misaka.cool`)

基于 [Astro](https://astro.build/) 搭建的个人技术与生活博客，采用《某科学的超电磁炮》**御坂美琴（Misaka Mikoto / Level 5 Railgun）**定制主题风格。

> 「梦想、雷电与代码，欢迎来到我的秘密基地！」

---

## ✨ 站点特性

- **⚡ 双模式主题切换**：
  - **超电磁炮 HUD 模式（默认深色）**：学园都市夜幕背景、电磁网格、电光青蓝（`#00e5ff`）与游戏币暖金高光。
  - **常盘台日常模式（浅色）**：清爽柔和的高对比度日间排版，适合长文沉浸阅读。
- **🪙 趣味角色彩蛋与微交互**：
  - 右下角悬浮**常盘台游戏币**，点击可触发 3D 抛硬币动画、横贯屏幕的超电磁炮光束与随机美琴语录终端弹窗。
  - 全局点击触发「你指尖跃动的电光」电火花粒子特效。
  - 融入呱太（Gekota）徽章、Level 5 · Rank 3 能力者档案面板等细节。
- **📐 LaTeX 数学公式静态渲染**：
  - 集成 `remark-math` + `rehype-katex`，在构建期将 `$...$` 行内公式与 `$$...$$` 块级公式预编译为静态 HTML，零客户端 JS 负担。
- **🧭 阅读体验增强**：
  - 博客档案库支持按 `#tag` 标签即时筛选文章。
  - 文章阅读页配备带实时阅读进度圆环（`0% ~ 100%`）的「回到开头」悬浮组件。
  - 自动生成 `RSS` 订阅源（`/rss.xml`）与 `Sitemap` 站点地图。

---

## 📁 目录结构

```text
├── public/
│   ├── downloads/              # 静态附件（如 .zip、.pdf），通过 /downloads/xxx 访问
│   └── favicon.svg             # 呱太（Gekota）站点图标
├── src/
│   ├── assets/                 # 站点级视觉图（site-home.jpg、site-about.jpg）及字体
│   ├── components/             # 页面组件（导航栏、页脚、抛硬币组件、回到顶部组件等）
│   ├── content/
│   │   └── blog/               # 博客文章（.md / .mdx）
│   │       └── _assets/        # 文章内部引用的图片资源
│   ├── layouts/                # 文章与页面布局模板
│   ├── pages/                  # 页面路由与 RSS 生成器
│   └── styles/global.css       # 全局样式与明暗主题变量
└── astro.config.mjs            # Astro 站点与 Markdown 插件配置
```

---

## ✍️ 写作与资源规范

### 1. 新建文章
直接在 `src/content/blog/` 目录下添加 `.md` 或 `.mdx` 文件，推荐命名格式为 `YYYYMMDD_英文或拼音短横线名称.md`（例如 `20261017_hello-railgun.md`）。

文章头部 Frontmatter 模板如下：

```yaml
---
title: "文章标题"
description: "文章简短摘要"
pubDate: "2026-10-17"
updatedDate: "2026-10-17" # 可选：更新文章时填写
tags: ["astro", "linux"]  # 可选：文章分类标签
---
```

> **排序规则**：博客文章列表会优先按照 `updatedDate` 降序排列；如果未设置 `updatedDate`，则使用 `pubDate` 降序排列。

### 2. 图片与附件存放
- **文章配图**：放入 `src/content/blog/_assets/` 目录，在 Markdown 中使用相对路径引用：
  ```markdown
  ![图片说明](./_assets/示例图片.png)
  ```
- **其他附件**（如压缩包、PDF 文档等）：放入 `public/downloads/` 目录，在 Markdown 中使用绝对路径引用：
  ```markdown
  [下载附件](/downloads/example.pdf)
  ```

---

## 🚀 常用命令

项目使用 `pnpm` 进行依赖管理（需 Node.js `>=22.22.0`）：

| 命令 | 说明 |
| :--- | :--- |
| `pnpm install` | 安装项目依赖 |
| `pnpm dev` | 启动本地开发服务器（默认 `http://localhost:4321`） |
| `pnpm build` | 构建静态生产站点至 `dist/` 目录 |
| `pnpm preview` | 在本地预览构建后的生产环境站点 |
