#!/usr/bin/env bash
# ==============================================================================
# Awesome Android Tuning - 设备一键体检诊断脚本
# ==============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检测 adb
if ! command -v adb >/dev/null 2>&1; then
  echo -e "${RED}[错误] 未检测到 adb 工具，请先安装 Android Platform Tools。${NC}"
  exit 1
fi

# 设备选择逻辑
TARGET_DEVICE="$1"
if [ "$1" = "-s" ] && [ -n "$2" ]; then
  TARGET_DEVICE="$2"
fi

if [ -z "$TARGET_DEVICE" ]; then
  DEVICES_COUNT=$(adb devices | grep -v "List" | grep "device$" | wc -l | tr -d ' ')
  if [ "$DEVICES_COUNT" -eq 0 ]; then
    echo -e "${RED}[错误] 未检测到已授权连接的 Android 设备，请检查数据线与 USB 调试开关。${NC}"
    exit 1
  elif [ "$DEVICES_COUNT" -gt 1 ]; then
    echo -e "${YELLOW}[提示] 检测到多台连接设备，请选择目标设备：${NC}"
    adb devices -l | grep -v "List" | grep "device"
    echo ""
    read -r -p "请输入目标设备序列号: " TARGET_DEVICE
  else
    TARGET_DEVICE=$(adb devices | grep -v "List" | grep "device$" | awk '{print $1}')
  fi
fi

ADB_CMD="adb -s $TARGET_DEVICE"

echo -e "${BLUE}================================================================${NC}"
echo -e "${GREEN}🔍 正在对设备 [${TARGET_DEVICE}] 执行全面体检...${NC}"
echo -e "${BLUE}================================================================${NC}"

# 1. 基础硬件与系统
BRAND=$($ADB_CMD shell getprop ro.product.brand | tr -d '\r')
MODEL=$($ADB_CMD shell getprop ro.product.model | tr -d '\r')
ANDROID_VER=$($ADB_CMD shell getprop ro.build.version.release | tr -d '\r')
SDK_VER=$($ADB_CMD shell getprop ro.build.version.sdk | tr -d '\r')
ONEUI_VER=$($ADB_CMD shell getprop ro.build.version.oneui 2>/dev/null | tr -d '\r')

echo -e "📱 ${YELLOW}设备基本信息${NC}:"
echo "  - 品牌/型号: $BRAND $MODEL"
echo "  - Android 版本: $ANDROID_VER (API $SDK_VER)"
[ -n "$ONEUI_VER" ] && echo "  - One UI 版本: $ONEUI_VER"

# 2. 电池状态与真实健康度
echo -e "\n🔋 ${YELLOW}电池健康度与状态${NC}:"
BATTERY_LEVEL=$($ADB_CMD shell dumpsys battery | grep "  level:" | head -1 | awk '{print $2}' | tr -d '\r')
BATTERY_TEMP=$($ADB_CMD shell dumpsys battery | grep "  temperature:" | head -1 | awk '{print $2}' | tr -d '\r')
BATTERY_ASOC=$($ADB_CMD shell dumpsys battery | grep "mSavedBatteryAsoc" | head -1 | sed 's/.*\[//;s/\].*//' | tr -d '\r')
BATTERY_DATE=$($ADB_CMD shell dumpsys battery | grep "FirstUseDate" | head -1 | sed 's/.*\[//;s/\].*//' | tr -d '\r')
FAST_CHARGE=$($ADB_CMD shell settings get global super_fast_charging 2>/dev/null | tr -d '\r')

echo "  - 当前电量: ${BATTERY_LEVEL}%"
if [ -n "$BATTERY_TEMP" ]; then
  TEMP_C=$(awk "BEGIN {print $BATTERY_TEMP/10}")
  echo "  - 电池温度: ${TEMP_C}°C"
fi
[ -n "$BATTERY_ASOC" ] && echo "  - 电池健康度 (ASOC): ${BATTERY_ASOC}%"
[ -n "$BATTERY_DATE" ] && echo "  - 首次激活日期: ${BATTERY_DATE}"
echo "  - 超级快充开关: $([ "$FAST_CHARGE" = "1" ] && echo "✅ 已开启" || echo "❌ 未开启")"

# 3. 内存与存储
echo -e "\n💾 ${YELLOW}内存与存储容量${NC}:"
MEM_TOTAL=$($ADB_CMD shell cat /proc/meminfo | grep "MemTotal" | awk '{print int($2/1024)}')
MEM_AVAIL=$($ADB_CMD shell cat /proc/meminfo | grep "MemAvailable" | awk '{print int($2/1024)}')
echo "  - 物理内存 (RAM): 总计 ${MEM_TOTAL} MB / 剩余可用 ${MEM_AVAIL} MB"

STORAGE_INFO=$($ADB_CMD shell df -h /data 2>/dev/null | tail -1)
STORAGE_SIZE=$(echo "$STORAGE_INFO" | awk '{print $2}')
STORAGE_USED=$(echo "$STORAGE_INFO" | awk '{print $3}')
STORAGE_AVAIL=$(echo "$STORAGE_INFO" | awk '{print $4}')
STORAGE_USE_PCT=$(echo "$STORAGE_INFO" | awk '{print $5}')
echo "  - 用户存储 (/data): 总计 ${STORAGE_SIZE} / 已用 ${STORAGE_USED} (${STORAGE_USE_PCT}) / 剩余可用 ${STORAGE_AVAIL}"

# 4. 关键调优参数状态
echo -e "\n⚙️ ${YELLOW}当前关键调优配置${NC}:"
W_ANIM=$($ADB_CMD shell settings get global window_animation_scale | tr -d '\r')
T_ANIM=$($ADB_CMD shell settings get global transition_animation_scale | tr -d '\r')
A_ANIM=$($ADB_CMD shell settings get global animator_duration_scale | tr -d '\r')
GPU_UI=$($ADB_CMD shell settings get global force_hw_ui 2>/dev/null | tr -d '\r')
DNS_MODE=$($ADB_CMD shell settings get global private_dns_mode 2>/dev/null | tr -d '\r')
DNS_SPEC=$($ADB_CMD shell settings get global private_dns_specifier 2>/dev/null | tr -d '\r')
WIFI_SCAN=$($ADB_CMD shell settings get global wifi_scan_always_enabled 2>/dev/null | tr -d '\r')

echo "  - 动画缩放: 窗口=${W_ANIM:-1.0}x | 过渡=${T_ANIM:-1.0}x | 时长=${A_ANIM:-1.0}x"
echo "  - 强制 GPU 渲染: $([ "$GPU_UI" = "1" ] && echo "✅ 已开启" || echo "❌ 未开启")"
echo "  - Private DNS: 模式=${DNS_MODE:-关闭} | 地址=${DNS_SPEC:-无}"
echo "  - Wi-Fi 始终扫描: $([ "$WIFI_SCAN" = "0" ] && echo "✅ 已关闭(省电)" || echo "⚠️ 开启中(耗电)")"

# 5. 预装应用统计
TOTAL_PKGS=$($ADB_CMD shell pm list packages 2>/dev/null | wc -l | tr -d ' ')
DISABLED_PKGS=$($ADB_CMD shell pm list packages -d 2>/dev/null | wc -l | tr -d ' ')
THIRD_PKGS=$($ADB_CMD shell pm list packages -3 2>/dev/null | wc -l | tr -d ' ')

echo -e "\n📦 ${YELLOW}应用生态统计${NC}:"
echo "  - 总应用包数: $TOTAL_PKGS"
echo "  - 用户第三方应用: $THIRD_PKGS"
echo "  - 已冻结/禁用应用: $DISABLED_PKGS"

echo -e "\n${GREEN}✅ 体检完成！${NC}"
echo -e "${BLUE}================================================================${NC}"
