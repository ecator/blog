puts "jekyll自动生成posts模板脚本 by 易小猫"
puts "输入文件名（要求英文）"
filename=gets.chomp
puts "请输入标题"
title=gets.chomp
puts "请输入作者"
author=gets.chomp
puts "输入标签（空格区分）"
tags=gets.chomp
time=Time.new
date=time.strftime("%Y-%m-%d")
head="---\nlayout: post\ntitle: #{title}\nauthor: #{author}\ntags: #{tags}\n---"
filename="#{date}-#{filename}.md"
puts "文件名：\n#{filename}"
puts "头信息：\n#{head}"
puts "是否保存文件（y/n）"
if gets.chomp=="y"
	file=File.new("./_posts/#{filename}","w")
	file.syswrite(head)
	file.close()
	puts "保存文件 ./_posts/#{filename} 成功"
else
	puts "放弃保存文件"
end