#!/bin/bash

# 快速更新脚本 - 用于日常维护个人主页
# Quick Update Script for Personal Academic Homepage

echo "🚀 个人学术主页快速更新工具"
echo "================================"

# 检查是否在正确的目录
if [ ! -f "_config.yml" ]; then
    echo "❌ 错误: 请在网站根目录下运行此脚本"
    exit 1
fi

echo "📝 请选择要更新的内容："
echo "1) 添加新闻动态"
echo "2) 添加新出版物"
echo "3) 更新个人信息"
echo "4) 检查同步状态"
echo "5) 本地预览网站"
echo "6) 提交并发布更改"
echo "0) 退出"

read -p "请输入选择 (0-6): " choice

case $choice in
    1)
        echo "📰 添加新闻动态"
        echo "请手动编辑 _pages/about.md 文件的 News 部分"
        echo "格式: - **[YYYY.MM]** 🎉 你的新闻内容"
        code _pages/about.md 2>/dev/null || nano _pages/about.md
        ;;
    2)
        echo "📚 添加新出版物"
        echo "请选择添加方式："
        echo "1) 直接在主页添加"
        echo "2) 创建独立出版物文件"
        read -p "选择方式 (1-2): " pub_choice
        
        if [ "$pub_choice" = "1" ]; then
            echo "编辑主页 Publications 部分..."
            code _pages/about.md 2>/dev/null || nano _pages/about.md
        else
            read -p "请输入论文发表日期 (YYYY-MM-DD): " pub_date
            read -p "请输入论文简短标题 (用-连接): " pub_title
            filename="_publications/${pub_date}-${pub_title}.md"
            
            cat > "$filename" << EOF
---
title: "论文完整标题"
collection: publications
category: conferences
permalink: /publication/${pub_date%-*}-${pub_title}
excerpt: '论文简介'
date: ${pub_date%-*}
venue: '会议/期刊名称'
paperurl: '论文链接'
codeurl: '代码链接'
---

论文详细描述...

**Authors:** 作者列表

**Links:** [[Paper]](论文链接) [[Code]](代码链接)
EOF
            echo "✅ 已创建论文文件: $filename"
            code "$filename" 2>/dev/null || nano "$filename"
        fi
        ;;
    3)
        echo "👤 更新个人信息"
        echo "编辑配置文件..."
        code _config.yml 2>/dev/null || nano _config.yml
        ;;
    4)
        echo "🔄 检查同步状态"
        if [ -f "scripts/sync_content.py" ]; then
            python3 scripts/sync_content.py
        else
            echo "同步脚本不存在，进行手动检查..."
            echo "请确保以下文件内容一致:"
            echo "- _pages/about.md"
            echo "- README.md"
            echo "- _config.yml"
        fi
        ;;
    5)
        echo "🌐 启动本地预览服务器"
        if [ -f "run_server.sh" ]; then
            bash run_server.sh
        else
            echo "正在启动Jekyll服务器..."
            bundle exec jekyll serve --livereload
        fi
        ;;
    6)
        echo "📤 提交并发布更改"
        git add -A
        
        read -p "请输入提交信息: " commit_msg
        if [ -z "$commit_msg" ]; then
            commit_msg="Update homepage content"
        fi
        
        git commit -m "$commit_msg"
        
        echo "推送到GitHub..."
        git push origin master
        
        if [ $? -eq 0 ]; then
            echo "✅ 更新成功! 几分钟后在 https://zky04.github.io 查看更改"
        else
            echo "❌ 推送失败，请检查网络连接和权限"
        fi
        ;;
    0)
        echo "👋 再见!"
        exit 0
        ;;
    *)
        echo "❌ 无效选择"
        exit 1
        ;;
esac

echo ""
echo "✅ 操作完成!"
echo "💡 提示: 运行 'bash scripts/quick_update.sh' 随时使用此工具"