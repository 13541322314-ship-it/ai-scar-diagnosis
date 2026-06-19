#!/bin/bash
# ============================================
# 🚀 AI疤痕面诊 - 一键部署脚本
# 支持 GitHub Pages / Vercel / Netlify
# ============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo ""
echo "╔══════════════════════════════════════╗"
echo "║  🚀 AI疤痕面诊 · 一键部署           ║"
echo "║  选一种方式，自动上线                ║"
echo "╚══════════════════════════════════════╝"
echo ""

# 检测 git 是否就绪
if [ ! -d ".git" ]; then
    echo "📦 初始化 Git 仓库..."
    git init
    git add -A
    git commit -m "init: AI疤痕面诊 v2.0 PWA版"
fi

echo "请选择部署方式："
echo ""
echo "  1) GitHub Pages（推荐·免费）"
echo "  2) Vercel（全球加速·国内友好）"
echo "  3) Netlify（自动HTTPS）"
echo "  4) 手动（仅生成部署文件）"
echo ""
read -p "输入 1-4 [默认1]: " CHOICE
CHOICE=${CHOICE:-1}

case $CHOICE in
    1)
        echo ""
        echo "📦 部署到 GitHub Pages"
        echo ""
        
        # 检查 gh CLI
        if command -v gh &>/dev/null; then
            if gh auth status &>/dev/null; then
                echo "✅ GitHub CLI 已登录"
                REPO="ai-scar-diagnosis"
                
                gh repo create "$REPO" --public --description "AI疤痕面诊 - 拍照测疤痕，3秒出智能报告" 2>/dev/null || echo "  仓库已存在"
                
                git remote remove origin 2>/dev/null || true
                git remote add origin "https://github.com/$(gh api user -q .login)/$REPO.git"
                git push -u origin main
                
                # 启用 Pages
                gh api "repos/$(gh api user -q .login)/$REPO/pages" -X POST \
                  -f source.branch=main -f source.path=/ 2>/dev/null || true
                
                URL="https://$(gh api user -q .login).github.io/$REPO/"
                echo "$URL" > .deployed
                echo "✅ 部署完成！"
                echo "🌍 $URL"
            else
                echo "⚠️ 请先登录 GitHub：gh auth login"
                exit 1
            fi
        else
            echo "⚠️ 未安装 GitHub CLI"
            echo ""
            echo "   安装方法："
            echo "   brew install gh"
            echo "   或 https://cli.github.com/"
            echo ""
            echo "📋 手动部署步骤："
            echo "   1. 在 github.com 新建仓库"
            echo "   2. 执行以下命令："
            echo ""
            echo "   cd \"$SCRIPT_DIR\""
            echo "   git remote add origin https://github.com/你的用户名/ai-scar-diagnosis.git"
            echo "   git push -u origin main"
            echo ""
            echo "   3. 仓库 Settings → Pages → 选 main 分支 → Save"
        fi
        ;;
    2)
        echo ""
        echo "📦 部署到 Vercel"
        echo ""
        if command -v vercel &>/dev/null; then
            vercel --prod
        elif command -v npx &>/dev/null; then
            npx vercel --prod
        else
            echo "⚠️ 请先安装 Vercel CLI：npm i -g vercel"
            echo "   或访问 vercel.com 导入 Git 仓库"
        fi
        ;;
    3)
        echo ""
        echo "📦 部署到 Netlify"
        echo ""
        echo "   拖拽以下文件夹到 https://app.netlify.com/drop"
        echo "   → 或连接 Git 仓库自动部署"
        echo ""
        echo "📂 需要部署的文件夹：$SCRIPT_DIR"
        ;;
    4)
        echo ""
        echo "📦 生成部署文件（供手动上传）"
        echo ""
        echo "📂 所有文件已就绪：$SCRIPT_DIR"
        echo "   上传到任何静态托管服务即可"
        echo "   或直接双击 index.html 在本地打开"
        ;;
esac

echo ""
echo "📱 部署后安装为 App："
echo "   iPhone: Safari打开 → 分享 → 添加到主屏幕"
echo "   Mac: Safari打开 → 文件 → 添加到程序坞"
echo "   Android/Windows: Chrome打开 → 安装"
echo ""
