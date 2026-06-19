# 手动部署指南

## 方式一：GitHub Pages（推荐）

### 前置条件
- 有一个 GitHub 账号
- 安装 `gh`：`brew install gh` 或从 https://cli.github.com/ 下载

### 一键部署
```bash
cd ~/Desktop/work/ai-army/face-diagnosis
bash deploy.sh
```

### 手动部署
```bash
cd ~/Desktop/work/ai-army/face-diagnosis

# 1. 在 GitHub 上新建仓库
# 2. 推送到 GitHub
git remote add origin https://github.com/你的用户名/你的仓库名.git
git add .
git commit -m "init: AI疤痕面诊 PWA版"
git push -u origin main

# 3. 打开仓库 Settings → Pages → 选 main 分支 → Save
# 4. 等2分钟，访问 https://你的用户名.github.io/你的仓库名/
```

## 方式二：Vercel（全球加速）

1. 访问 https://vercel.com/ ，用 GitHub 登录
2. 点击「Add New → Project」
3. 导入你的 GitHub 仓库
4. 默认配置，直接 Deploy
5. 自动 HTTPS，国内访问速度快

## 安装为 App

部署成功后：
- **iPhone/iPad**：用 Safari 打开 → 分享按钮 → 「添加到主屏幕」
- **Android**：用 Chrome 打开 → 菜单 → 「安装应用」
- **Mac**：用 Safari 打开 → 文件 → 「添加到程序坞」
- **Windows**：用 Chrome 打开 → 地址栏右侧「安装」图标
