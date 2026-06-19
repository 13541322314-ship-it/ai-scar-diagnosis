#!/bin/bash
# 创建独立 macOS 桌面应用（无需Xcode）
# 使用 Safari 的 Web Clip 技术

set -e

APP_NAME="AI疤痕面诊"
APP_DIR="$HOME/Desktop/Apps/$APP_NAME.app"
INDEX_HTML="$HOME/Desktop/work/ai-army/face-diagnosis/index.html"
ICON_PNG="$HOME/Desktop/work/ai-army/face-diagnosis/icons/icon-512.png"

# 检测是否已部署到线上，优先使用线上地址（可加载 manifest 实现PWA）
# 如果部署了，把下面这行的路径换成 URL
WEB_URL="file://${INDEX_HTML}"

echo "📦 正在创建 $APP_NAME.app ..."

# 删除旧版本
rm -rf "$APP_DIR"

# 创建 app bundle 结构
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

# === 方案 A: WebKit 原生渲染（最佳体验）===
# 使用 macOS 内置的 WebKit 创建独立窗口
cat > "$APP_DIR/Contents/MacOS/$APP_NAME" << 'RUNEOF'
#!/bin/bash
# 启动 AI疤痕面诊 - WebKit 独立窗口模式
# 使用 Safari 以 webapp 模式打开

APP_URL="file://$HOME/Desktop/work/ai-army/face-diagnosis/index.html"

# 尝试用 Safari 的 WebApp 模式
# 先检查是否已部署
DEPLOYED_URL=""
if [ -f "$HOME/Desktop/work/ai-army/face-diagnosis/.deployed" ]; then
    DEPLOYED_URL=$(cat "$HOME/Desktop/work/ai-army/face-diagnosis/.deployed")
fi

if [ -n "$DEPLOYED_URL" ]; then
    open -a Safari "$DEPLOYED_URL"
else
    open -a Safari "$APP_URL"
fi

# 提示添加到程序坞
osascript -e '
tell application "Safari"
    activate
end tell
delay 0.5
tell application "System Events"
    tell process "Safari"
        set frontmost to true
    end tell
end tell
display alert "✨ AI疤痕面诊 已启动！
📱 如需像原生App一样独立使用：
在Safari菜单 → 文件 → 添加到程序坞...
勾选「单独窗口」→ 添加" buttons {"知道了"} default button 1
'
RUNEOF

chmod +x "$APP_DIR/Contents/MacOS/$APP_NAME"

# Info.plist
cat > "$APP_DIR/Contents/Info.plist" << PLISTEOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>com.sunzhanyun.ai-scar-diagnosis</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundleDisplayName</key>
    <string>$APP_NAME</string>
    <key>CFBundleVersion</key>
    <string>2.0</string>
    <key>CFBundleShortVersionString</key>
    <string>2.0.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>LSMinimumSystemVersion</key>
    <string>11.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>LSUIElement</key>
    <false/>
</dict>
</plist>
PLISTEOF

# 生成图标
python3 << 'PYEOF'
import struct, os

png_path = os.path.expanduser("$ICON_PNG")
icns_path = os.path.expanduser("$APP_DIR/Contents/Resources/AppIcon.icns")

with open("$ICON_PNG", 'rb') as f:
    png_data = f.read()

entry_type = b'ic07'
entry_size = 8 + len(png_data)
header_size = 8 + entry_size

icns_data = b'icns' + struct.pack('>I', header_size)
icns_data += entry_type + struct.pack('>I', entry_size) + png_data

with open("$APP_DIR/Contents/Resources/AppIcon.icns", 'wb') as f:
    f.write(icns_data)

print("  ✅ 图标已生成")
PYEOF

touch "$APP_DIR"

echo ""
echo "✅ 创建成功！"
echo "📍 位置：$APP_DIR"
echo ""
echo "双击 $APP_NAME.app 即可启动"
echo "或用命令打开：open \"$APP_DIR\""
echo ""
echo "📱 提示：也可以用 Safari 打开页面后"
echo "   「文件 → 添加到程序坞」获得原生窗口体验"
