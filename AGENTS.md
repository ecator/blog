# AGENTS.md — AI 协作与开发规范

这是一个基于 **Astro 7** 构建的个人博客项目（域名：`https://blog.misaka.cool`），采用《某科学的超电磁炮》**御坂美琴（Misaka Mikoto / Railgun）**主题风格。

## 1. 核心命令与构建规则

- **包管理器**：必须统一使用 `pnpm`（严禁混用 `npm` 或 `yarn`）。
- **验证构建**：完成代码、样式或配置修改后，请始终使用 `pnpm build` 进行构建验证，确保静态页面、图片优化与类型检查全部通过。
  - `pnpm dev`：启动本地开发服务器
  - `pnpm build`：执行生产环境静态构建（输出至 `dist/`）
  - `pnpm preview`：预览构建产物
- **运行环境**：Node.js `>=22.22.0`

## 2. 目录结构与资源存放规范

```text
├── public/
│   ├── downloads/              # 供下载的静态附件（如 .zip、.pdf），通过 /downloads/xxx 引用
│   └── favicon.svg             # 呱太（Gekota）站点图标
├── src/
│   ├── assets/                 # 站点级公共图片（site-home.jpg、site-about.jpg）与本地字体
│   ├── components/             # 公共 Astro 组件（Header、Footer、RailgunWidget、BackToTop 等）
│   ├── content/
│   │   └── blog/               # 博客文章目录（.md / .mdx）
│   │       └── _assets/        # 博客文章内部引用的图片资源
│   ├── layouts/
│   │   └── BlogPost.astro      # 文章详情与关于页布局
│   ├── pages/                  # 路由页面（首页 index、博客列表 blog/index、动态路由、RSS）
│   ├── styles/
│   │   └── global.css          # 全局样式与明暗双模式 CSS 变量
│   ├── consts.ts               # 站点全局常量与御坂美琴主题配置
│   └── content.config.ts       # Content Collections 数据校验 Schema
└── astro.config.mjs            # Astro 配置文件
```

### 资源引用约定
1. **文章内图片**：统一存放在 `src/content/blog/_assets/` 下，推荐命名为 `<文章前缀>-<描述>.png`，在 Markdown 中使用相对路径 `./_assets/xxx.png` 引用，由 Astro 自动完成 WebP 压缩优化。
2. **站点级图片**：存放在 `src/assets/` 下。
3. **非图片附件**：（如 `.pdf`、`.zip` 等）存放在 `public/downloads/` 下，在 Markdown 中使用绝对路径 `/downloads/xxx` 引用。

## 3. 文章 Frontmatter 与排序规范

- **文件命名**：`src/content/blog/YYYYMMDD_slug-name.md`
- **Frontmatter Schema**（定义于 `src/content.config.ts`）：
  ```yaml
  ---
  title: "文章标题"
  description: "文章摘要描述"
  pubDate: "2026-10-17"
  updatedDate: "2026-10-17" # 可选
  tags: ["tag1", "tag2"]    # 可选
  heroImage: "./_assets/cover.jpg" # 可选
  ---
  ```
- **排序逻辑**：全站文章列表（`src/pages/index.astro`、`src/pages/blog/index.astro`、`src/pages/rss.xml.js`）统一**优先按 `updatedDate` 降序排列；若 `updatedDate` 未定义，则回退使用 `pubDate` 降序排列**（即 `b.data.updatedDate ?? b.data.pubDate`）。

## 4. 主题与技术栈注意事项

- **双模式主题（Dark / Light）**：
  - 默认使用深色模式 `data-theme="dark"`（**超电磁炮 HUD 模式**），支持切换为浅色模式 `data-theme="light"`（**常盘台日常阅读模式**），状态持久化在 `localStorage` 的 `misaka-theme` 键中。
  - 新增组件样式时请优先使用 `src/styles/global.css` 中定义的 CSS 变量（如 `var(--bg-card)`、`var(--accent)`、`var(--accent-coin)`、`var(--border-hud)`、`var(--text-primary)`），以保证明暗双模式自动适配。
- **Markdown 与 LaTeX 公式**：
  - Astro 7 默认使用 Sätteri 引擎；本项目在 `astro.config.mjs` 中显式配置了 `@astrojs/markdown-remark` 的 `unified({ remarkPlugins: [remarkMath], rehypePlugins: [rehypeKatex] })` 处理器以支持 `$...$` 与 `$$...$$` 公式构建期静态渲染。
  - 样式表 `katex/dist/katex.min.css` 已在 `src/components/BaseHead.astro` 中全局引入。