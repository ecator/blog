#!/bin/bash
echo jekyll文章自动生成脚本 by Ecat
echo 请输入文件名（要求英文）:
read filename
echo 请输入文章标题:
read title
out=`date +%Y-%m-%d`
if test -d _posts
then
out="./_posts/${out}-${filename}.md"
else
out="./${out}-${filename}.md"
fi
echo -e "---\nlayout: post\ntitle: ${title}\n---" > ${out}
echo "创建 ${out} 完毕"