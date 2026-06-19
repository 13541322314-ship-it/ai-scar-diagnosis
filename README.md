# AI 疤痕面诊 · 拍照测疤痕

> AI智能疤痕分析，拍照即测，3秒出报告

## 在线体验

打开 `index.html` 即可使用。

## 部署指南

### 方式一：GitHub Pages（推荐）

```bash
# 1. 在 GitHub 新建仓库
# 2. 推送到 GitHub
git remote add origin https://github.com/你的用户名/你的仓库名.git
git add .
git commit -m "init: AI疤痕面诊页面"
git push -u origin main

# 3. 在仓库 Settings → Pages → 选择 main 分支 → 保存
```

### 方式二：Vercel

1. 导入 GitHub 仓库
2. 默认配置，无需修改
3. 自动部署，自动 HTTPS

### 方式三：自托管

直接将 `index.html` 部署到任何 Web 服务器即可。

## 配置说明

如需接入真实 AI 视觉分析（GPT-4o Vision），替换 `index.html` 中的模拟逻辑部分即可。欢迎 PR。

---

*孙湛云 · AI军团出品*
