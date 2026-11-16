#!/usr/bin/env bash
# ==============================================================================
# Awesome Android Tuning - 全机型通用核心调优脚本
# ==============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

if ! command -v adb >/dev/null 2>&1; then
  echo -e "${RED}[错误] 未检测到 adb 工具。${NC}"
  exit 1
fi

DEVICES_COUNT=$(adb devices | grep -v "List" | grep "device$" | wc -l | tr -d ' ')

if [ "$DEVICES_COUNT" -eq 0 ]; then
  echo -e "${RED}[错误] 未检测到已连接设备。${NC}"
  exit 1
elif [ "$DEVICES_COUNT" -gt 1 ]; then
  echo -e "${YELLOW}[提示] 检测到多台连接设备：${NC}"
  adb devices -l | grep -v "List" | grep "device"
  read -r -p "请输入目标设备序列号: " TARGET_DEVICE
  ADB_CMD="adb -s $TARGET_DEVICE"
else
  TARGET_DEVICE=$(adb devices | grep -v "List" | grep "device$" | awk '{print $1}')
  ADB_CMD="adb -s $TARGET_DEVICE"
fi

echo -e "${BLUE}================================================================${NC}"
echo -e "${GREEN}⚡ 开始为设备 [${TARGET_DEVICE}] 应用通用核心调优...${NC}"
echo -e "${BLUE}================================================================${NC}"

# 1. 动画缩放提速至 0.5x
echo -e "\n1️⃣  正在调优界面动画速度 (1.0x -> 0.5x)..."
$ADB_CMD shell settings put global window_animation_scale 0.5
$ADB_CMD shell settings put global transition_animation_scale 0.5
$ADB_CMD shell settings put global animator_duration_scale 0.5
echo -e "   ${GREEN}✅ 窗口/过渡/时长动画缩放已全部设为 0.5x${NC}"

# 2. 开启强制 GPU 硬件加速渲染
echo -e "\n2️⃣  正在开启强制 GPU 硬件加速渲染..."
$ADB_CMD shell settings put global force_hw_ui 1
echo -e "   ${GREEN}✅ 强制 GPU 渲染已开启 (force_hw_ui = 1)${NC}"

# 3. 配置高兼容性阿里 Private DNS (防运营商劫持)
echo -e "\n3️⃣  正在配置防劫持阿里 Private DNS (dns.alidns.com)..."
$ADB_CMD shell settings put global private_dns_mode hostname
$ADB_CMD shell settings put global private_dns_specifier dns.alidns.com
echo -e "   ${GREEN}✅ Private DNS 已指向 dns.alidns.com (解析加速且不影响国内 CDN 图片)${NC}"

# 4. 关闭 Wi-Fi 始终后台扫描 (省电 + 防追踪)
echo -e "\n4️⃣  正在关闭后台持续 Wi-Fi 扫描..."
$ADB_CMD shell settings put global wifi_scan_always_enabled 0
echo -e "   ${GREEN}✅ Wi-Fi 始终扫描已关闭 (wifi_scan_always_enabled = 0)${NC}"

# 5. 清理非必要的常驻无障碍服务
echo -e "\n5️⃣  正在检查并治理无障碍常驻服务..."
ACC_SERVICES=$($ADB_CMD shell settings get secure enabled_accessibility_services 2>/dev/null | tr -d '\r')
if [ -n "$ACC_SERVICES" ] && [ "$ACC_SERVICES" != "null" ]; then
  echo -e "   检测到当前启用的无障碍服务: $ACC_SERVICES"
  read -r -p "   是否清空以获得极致跟手度与低功耗? (y/N): " CONFIRM
  if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    $ADB_CMD shell settings delete secure enabled_accessibility_services
    echo -e "   ${GREEN}✅ 无障碍服务已清空${NC}"
  else
    echo -e "   ${YELLOW}已跳过无障碍清理${NC}"
  fi
else
  echo -e "   ${GREEN}✅ 当前无常驻无障碍服务，状态良好${NC}"
fi

echo -e "\n${BLUE}================================================================${NC}"
echo -e "${GREEN}🎉 全机型通用核心调优已全部执行完毕！即刻生效，无需重启。${NC}"
echo -e "${BLUE}================================================================${NC}"
