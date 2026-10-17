---
title: YAML 数据结构与核心语法详解
description: 深度解析 YAML 的核心设计理念、三类基础数据结构（对象、数组、纯量）、多行文本折叠与保留修饰符机制、锚点引用与合并键，以及日常配置中的易错陷阱与最佳实践。
pubDate: "2016-11-08"
updatedDate: "2026-10-17"
tags: ["YAML", "配置语言", "DevOps"]
---

YAML（发音 `/ˈjæməl/`）全称为 **YAML Ain't Markup Language**（YAML 不是标记语言，递归缩写），早期的定义则是 *Yet Another Markup Language*。它是一种专为“以数据为中心”而设计的人类可读的数据序列化标准。

相比于 XML 的冗长标签和 JSON 严格的括号引号要求，YAML 凭借简洁的缩进排版，成为了云原生（Kubernetes、Docker Compose）、CI/CD 流水线（GitHub Actions、GitLab CI）、自动化运维（Ansible）以及现代前端工程化配置的事实标准。

本文系统梳理 YAML 的语法规范、三大基础数据结构、文本处理机制及高阶复用技巧。

---

## 1. 核心语法规则与排版规范

在开始编写 YAML 之前，必须谨记以下几条基本规则：

1. **大小写敏感**：`Key` 与 `key` 会被解析为两个完全不同的标识符。
2. **使用空格缩进，严禁使用 Tab 键**：YAML 只允许使用空格缩进（建议全局统一为 **2 个空格**），使用 Tab 制表符会导致解析失败。
3. **缩进空格数不强制，但同级元素必须左对齐**：只要处于同一层级，首字符缩进空格数量就必须一致。
4. **注释使用 `#`**：仅支持单行注释，从 `#` 开始一直到行尾，建议在 `#` 之后保留一个空格。
5. **与 JSON 的关系**：YAML 1.2 标准是 **JSON 的严格超集**。这意味着任何合法的 JSON 格式文本，本质上都是合法的 YAML 格式。

---

## 2. 对象 / 映射（Mapping / Hash / Dictionary）

对象表示一组键值对（Key-Value Pair）的集合，在不同语言中也被称为映射（Mapping）、哈希（Hash）或字典（Dictionary）。

### 2.1 块级表示法（Block Style）

最基础的写法是用冒号 `:` 分隔键与值。**特别注意：冒号后面必须至少跟一个空格！**

```yaml
server:
  host: 127.0.0.1
  port: 8080
```

对应转换后的 JavaScript 对象为：

```javascript
{
  server: {
    host: "127.0.0.1",
    port: 8080
  }
}
```

### 2.2 行内流式表示法（Flow Style）

YAML 支持类 JSON 风格的行内简写，使用大括号 `{}` 包裹：

```yaml
hash: { name: Steve, role: admin, active: true }
```

### 2.3 复杂键名（问号语法）

当对象的键不是普通的简单标量，而是包含换行、复杂复合结构时，可以使用问号 `?` 显式声明键，冒号 `:` 声明对应的值：

```yaml
? - 北京
  - 上海
: - 010
  - 021
```

对应将 `['北京', '上海']` 这个数组作为键，映射到 `['010', '021']`。在实际常规配置中极少使用，但属于 YAML 的标准语法。

---

## 3. 数组 / 序列（Sequence / List / Array）

一组按次序排列的值，称为序列或数组。

### 3.1 块级表示法

以短横线 `-` 开头声明数组元素。**短横线后同样必须保留至少一个空格**：

```yaml
animals:
  - Cat
  - Dog
  - Goldfish
```

转为 JavaScript 如下：

```javascript
{ animals: ['Cat', 'Dog', 'Goldfish'] }
```

### 3.2 子成员与多维数组

如果数组的元素本身也是数组，可以通过缩进层级进行嵌套：

```yaml
matrix:
  -
    - 1
    - 2
  -
    - 3
    - 4
```

转为 JavaScript 如下：

```javascript
{ matrix: [[1, 2], [3, 4]] }
```

### 3.3 行内流式表示法

数组同样支持行内书写，使用方括号 `[]` 包裹，元素间使用逗号分隔：

```yaml
animals: [ 'Cat', 'Dog', 'Goldfish' ]
```

---

## 4. 复合结构实战

在实际项目（例如微服务架构或应用配置）中，往往是对象与数组深度嵌套的复合结构：

```yaml
service:
  name: payment-api
  replicas: 3
  languages:
    - Go
    - Python
  environments:
    - name: staging
      url: https://staging.example.com
      debug: true
    - name: production
      url: https://api.example.com
      debug: false
```

转为 JavaScript / JSON 数据模型：

```javascript
{
  service: {
    name: "payment-api",
    replicas: 3,
    languages: ["Go", "Python"],
    environments: [
      { name: "staging", url: "https://staging.example.com", debug: true },
      { name: "production", url: "https://api.example.com", debug: false }
    ]
  }
}
```

---

## 5. 纯量（Scalar / 基本数据类型）

纯量是最基本且不可再分割的数据值，主要包括：数字、布尔值、空值、日期时间与字符串。

### 5.1 数值（Numbers）

YAML 支持整数、浮点数以及科学计数法，还原生支持多种进制表示：

```yaml
integer: 42
float: 12.30
scientific: 1.23e+05
hexadecimal: 0x1A      # 转换为十进制为 26
octal: 0o77            # 转换为十进制为 63
binary: 0b1010         # 转换为十进制为 10
infinity: .inf         # 正无穷大（也有 -.inf）
not_a_number: .nan     # 非数字 (NaN)
```

### 5.2 布尔值（Booleans）与著名的“挪威问题”

基础布尔值使用 `true` 与 `false`：

```yaml
is_active: true
debug_mode: false
```

> **踩坑预警：挪威问题（The Norway Problem）**  
> 在老旧的 **YAML 1.1 规范** 中，以下词汇都会被隐式转换为布尔值：  
> - `true` / `false`  
> - `yes` / `no`  
> - `y` / `n`  
> - `on` / `off`  
>
> 这导致当用户配置国家二字代码挪威 `country: NO` 时，很多基于 YAML 1.1 的解析器会把 `NO` 误解析成布尔值 `false`！类似地，`version: 3.10` 很容易被当成浮点数 `3.1`。  
> **最佳实践**：凡是国家简写、开关枚举、版本号（如 `"3.10"`）或者可能存在歧义的文本，一律**显式加上双引号**包裹。

### 5.3 空值（Null）

YAML 可以使用 `~`、`null` 或直接留空表示空值：

```yaml
parent: ~
spouse: null
children: 
```

转为 JavaScript 如下：

```javascript
{ parent: null, spouse: null, children: null }
```

### 5.4 时间与日期（Timestamp）

YAML 原生支持符合 **ISO 8601** 规范的日期与时间：

```yaml
# 纯日期（YYYY-MM-DD）
date: 2026-10-17

# 完整时间戳（带时区）
iso8601: 2026-10-17T17:30:00+08:00
timestamp: 2026-10-17 09:30:00.10 -5
```

### 5.5 字符串（Strings）

字符串是 YAML 中最灵活的数据类型：

#### 5.5.1 免引号规则
常规字符串默认无需使用任何引号：

```yaml
str: 这是一行普通字符串
```

若字符串中含有冒号加空格（`: `）、井号（`#`）、前置短横线或特殊字符，则必须使用引号包裹：

```yaml
title: "Notice: Please read #1 guide"
```

#### 5.5.2 单引号 vs 双引号
- **单引号 (`'`)**：所见即所得，内部转义字符不会生效。如果单引号内部需要表示单引号本身，必须使用**两个连续的单引号** `''` 转义。
- **双引号 (`"`)**：**会处理特殊字符转义**（如 `\n`、`\t`、Unicode 字符等）。

```yaml
s1: 'Line1\nLine2'
s2: "Line1\nLine2"
quote: 'Labor''s Day'
```

转为 JavaScript 如下：

```javascript
{
  s1: "Line1\\nLine2",      // 反斜杠被保留，未换行
  s2: "Line1\nLine2",        // 正常输出换行符
  quote: "Labor's Day"
}
```

#### 5.5.3 强制类型转换（Type Casting）

YAML 允许使用双感叹号 `!!` 显式强制转换数据类型：

```yaml
forced_string: !!str 12345
forced_bool: !!bool "true"
forced_int: !!int "456"
```

---

## 6. 多行字符串处理机制（Block Scalars）

在撰写多行 Shell 脚本、证书公钥、配置模板时，多行字符串的处理是 YAML 最强悍也最容易混淆的功能。

YAML 提供了两种**块样式**与三种**裁剪修饰符**，共计 $2 \times 3 = 6$ 种组合。

### 6.1 块折叠与保留符号

| 符号 | 样式名称 | 核心行为 | 适用场景 |
| :--- | :--- | :--- | :--- |
| `\|` | **保留换行（Literal）** | 忠实保留块内的换行符与原始文本结构 | 证书文件、脚本代码块、ASCII 艺术字 |
| `>` | **折叠换行（Folded）** | 将块内的多行文本折叠替换为空格，仅在空行时保留换行 | 较长的自然段落、日志描述说明 |

示例演示：

```yaml
literal_block: |
  Line A
  Line B

folded_block: >
  Long long paragraph
  continued on next line
```

对应转换结果：

```javascript
{
  literal_block: "Line A\nLine B\n",
  folded_block: "Long long paragraph continued on next line\n"
}
```

### 6.2 换行裁剪修饰符（Chomping Indicators）

在 `|` 或 `>` 后面追加修饰符，可以精确控制**文本块末尾**的换行符行为：

1. **剪裁（Clip，默认无符号）**：保留末尾的单个换行符，丢弃后续的多余空行。
2. **保持（Keep，追加 `+`）**：完整保留末尾输入的所有换行符与空白行。
3. **剔除（Strip，追加 `-`）**：彻底删除文本末尾的所有换行符。

```yaml
clip_default: |
  Hello
  World

keep_plus: |+
  Hello
  World


strip_minus: |-
  Hello
  World
```

对应 JavaScript 输出对比：

```javascript
{
  clip_default: "Hello\nWorld\n",        // 仅保留一个末尾换行
  keep_plus:    "Hello\nWorld\n\n\n",    // 保留全部末尾换行
  strip_minus:  "Hello\nWorld"           // 末尾无任何换行
}
```

---

## 7. 锚点（Anchor）、别名（Alias）与合并键（Merge Key）

在复杂的配置文件中，大量重复的配置不仅不易维护，还容易引发疏漏。YAML 原生支持通过“锚点”与“别名”实现代码复用（DRY 原则）。

### 7.1 锚点与别名基础

- `&`：定义锚点（定义复用模板）。
- `*`：引用别名（调用已定义的锚点）。

```yaml
team:
  - &leader "Steve Jobs"
  - "Steve Wozniak"
  - *leader
```

转为 JavaScript 数组：

```javascript
{ team: ["Steve Jobs", "Steve Wozniak", "Steve Jobs"] }
```

### 7.2 合并键 `<<` 实现配置继承

使用 `<<` 符号可以将一个对象的键值对批量合并到当前对象中，并且当前对象自定义的键可以**覆盖**继承来的默认值：

```yaml
# 1. 基础公共配置（锚点命名为 common_config）
default_db: &default_db
  adapter: postgres
  host: 127.0.0.1
  port: 5432
  pool_size: 10

# 2. 开发环境：继承并扩展额外配置
development:
  <<: *default_db
  database: myapp_dev

# 3. 生产环境：继承并覆写特定参数
production:
  <<: *default_db
  host: db.prod.internal
  pool_size: 50
  database: myapp_prod
```

等同于以下完全展开的配置：

```yaml
development:
  adapter: postgres
  host: 127.0.0.1
  port: 5432
  pool_size: 10
  database: myapp_dev

production:
  adapter: postgres
  host: db.prod.internal   # 被自定义配置覆盖
  port: 5432
  pool_size: 50            # 被自定义配置覆盖
  database: myapp_prod
```

> **提示**：合并键 `<<` 是 YAML 1.1 中的扩展规范，在 Docker Compose、Kubernetes Helm Chart 以及 CI/CD 模板（如 `.gitlab-ci.yml` 的 `.job_template`）中被广泛应用。

---

## 8. 日常编写最佳实践与排错清单

| 常见问题 | 产生原因与现象 | 正确做法 |
| :--- | :--- | :--- |
| **Tab 缩进报错** | 编辑器混入了制表符，解析器抛出 `found character '\t' that cannot start any token` | 在编辑器中开启 `Insert Spaces`，统一设置为 2 个空格 |
| **冒号无空格** | 写成 `key:value` 会被当成一整段普通字符串，而非键值对 | 冒号后永远跟随至少一个空格：`key: value` |
| **布尔/版本号失真** | `version: 3.10` 被转成数字 `3.1`；`country: NO` 被转为 `false` | 特殊字符串、版本号一律显式包裹引号：`version: "3.10"` |
| **多行脚本格式错乱** | Shell 脚本中的 `\n` 或末尾回车丢失，导致执行脚本语法错误 | 脚本代码段优先使用 `run: \|` 或 `run: \|-` 进行保护 |
| **锚点跨文档失效** | 在多文档 YAML（以 `---` 分隔）中跨文档引用锚点 | 锚点作用域仅限于单个 YAML 文档内，不可跨文档引用 |

### 推荐工具链
- **VS Code 扩展**：安装 Red Hat 提供的 **YAML** 扩展（支持 JSON Schema 自动补全、格式化与语法验证）。
- **命令行 Linter**：在 CI 流水线中集成 `yamllint`，在提交前拦截缩进、重复键及空白字符等低级错误。