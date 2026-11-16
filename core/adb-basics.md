# ADB 基础与通用环境配置

Android Debug Bridge (ADB) 是 Google 官方提供的通用设备调试桥梁，也是现代 Android 免 Root 调优的核心依托。

---

## 1. 安装 ADB

### macOS
使用 Homebrew 安装：
```bash
brew install android-platform-tools
```

### Linux (Ubuntu / Debian)
```bash
sudo apt update && sudo apt install -y android-tools-adb
```

### Windows
1. 访问 [Android Developer 官网](https://developer.android.com/tools/releases/platform-tools) 下载 Platform-Tools。
2. 解压后将目录添加至系统 `Path` 环境变量中。

---

## 2. 启用手机端调试权限

1. **进入开发者选项**：
   - 打开手机 **设置 -> 关于手机 -> 软件信息**。
   - 连续点击 **版本号 (Build Number)** 7 次，直至提示已处于开发者模式。
2. **启用 USB 调试**：
   - 返回设置根目录，进入 **系统 / 开发者选项**。
   - 打开 **USB 调试 (USB Debugging)** 开关。
3. **授权电脑**：
   - 用数据线连接手机与电脑。
   - 手机屏幕会弹出「允许 USB 调试吗？」弹窗，勾选 **始终允许来自这台计算机的调试** 并点击 **确定**。

---

## 3. 基础常用 ADB 指令集

### 检查连接状态
```bash
# 列出所有已连接且授权的设备
adb devices -l
```
*如果状态显示为 `unauthorized`，请解锁手机并在弹窗中确认授权。*

### 多设备指定目标
当电脑连接了多台设备时，通过 `-s` 参数指定具体设备序列号：
```bash
adb -s <DEVICE_SERIAL> shell getprop ro.product.model
```

### 应用状态管理（无损禁用的秘密）
- **安全禁用应用**（免 Root，仅对当前用户冻结）：
  ```bash
  adb shell pm disable-user --user 0 <PACKAGE_NAME>
  ```
- **重新启用应用**：
  ```bash
  adb shell pm enable --user 0 <PACKAGE_NAME>
  ```
- **查看已禁用的应用**：
  ```bash
  adb shell pm list packages -d
  ```
- **强退后台应用**：
  ```bash
  adb shell am force-stop <PACKAGE_NAME>
  ```

---

## 4. 无线调试 (Wireless Debugging)

Android 11+ 支持免数据线无线调试：
1. 手机连接与电脑相同的 Wi-Fi 网络。
2. 开发者选项中开启 **无线调试**。
3. 点击无线调试进入详情，点击「使用配对码配对设备」。
4. 电脑终端运行：
   ```bash
   adb pair <IP>:<PORT>
   # 输入弹窗给出的 6 位配对码
   adb connect <IP>:<CONNECT_PORT>
   ```
