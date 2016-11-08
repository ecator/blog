---
layout: post
title: YAML数据结构
tags: YAML
author: 易小猫
---
### 对象
> 键值对的集合，又称为映射（mapping）/ 哈希（hashes） / 字典（dictionary）
```
key: value
```
注意冒号后面有一个空格
> Yaml 也允许另一种写法，将所有键值对写成一个行内对象

```
hash: { name: Steve, foo: bar } 
```
### 数组
以 \- 开头的词构成一个数组

<!--description-->

```
- Cat
- Dog
- Goldfish
```
> 数据结构的子成员是一个数组，则可以在该项下面缩进一个空格

```
-
 - Cat
 - Dog
 - Goldfish
```
> 数组也可以采用行内表示法

```
{ animal: [ 'Cat', 'Dog' ] }
```


### 复合结构
对象和数组混合使用，称为复合结构

```
languages:
 - Ruby
 - Perl
 - Python 
websites:
 YAML: yaml.org 
 Ruby: ruby-lang.org 
 Python: python.org 
 Perl: use.perl.org 
```
### 纯量
#### 数字

```
number: 12.30
```
#### 布尔值

```
key1: true
key2: false
```
#### null

```
parent: ~ 
```
#### 时间
> 时间采用 ISO8601 格式

```
iso8601: 2001-12-14t21:59:43.10-05:00 
```
> 日期采用复合 iso8601 格式的年、月、日表示

```
date: 1976-07-31
```

#### 字符串
字符串默认不用引号

```
str: 这是一行字符串
```
> 如果字符串之中包含空格或特殊字符，需要放在引号之中

```
str: '内容： 字符串'
```
> 单引号和双引号都可以使用，双引号不会对特殊字符转义

```
s1: '内容\n字符串'
s2: "内容\n字符串"
```
转为 JavaScript 如下:

```
{ s1: '内容\\n字符串', s2: '内容\n字符串' }
```
==单引号之中如果还有单引号，必须连续使用两个单引号转义==

```
str: 'labor''s day' 
```
> 字符串可以写成多行，从第二行开始，必须有一个单空格缩进。换行符会被转为空格

```
str: 这是一段
  多行
  字符串
```
转为 JavaScript 如下:

```
{ str: '这是一段 多行 字符串' }
```
> 多行字符串可以使用|保留换行符，也可以使用>折叠换行

```
this: |
  Foo
  Bar
that: >
  Foo
  Bar
```
转为 JavaScript 代码如下:

```
{ this: 'Foo\nBar\n', that: 'Foo Bar\n' }
```
> +表示保留文字块末尾的换行，-表示删除字符串末尾的换行

```
s1: |
  Foo

s2: |+
  Foo


s3: |-
  Foo
```
转为 JavaScript 代码如下:

```
{ s1: 'Foo\n', s2: 'Foo\n\n\n', s3: 'Foo' }
```
> YAML 允许使用两个感叹号，强制转换数据类型

```
e: !!str 123
f: !!str true
```
### 引用
锚点&和别名\*，可以用来引用

```
efaults: &defaults
  adapter:  postgres
  host:     localhost

development:
  database: myapp_development
  <<: *defaults

test:
  database: myapp_test
  <<: *defaults
```
等同于下面的代码:

```
defaults:
  adapter:  postgres
  host:     localhost

development:
  database: myapp_development
  adapter:  postgres
  host:     localhost

test:
  database: myapp_test
  adapter:  postgres
  host:     localhost
```
&用来建立锚点（defaults），<<表示合并到当前数据，*用来引用锚点。

下面是另一个例子:
```
- &showell Steve 
- Clark 
- Brian 
- Oren 
- *showell 
```
转为 JavaScript 代码如下:
```
[ 'Steve', 'Clark', 'Brian', 'Oren', 'Steve' ]
```