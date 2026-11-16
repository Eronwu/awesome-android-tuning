#!/usr/bin/env bash
# ==============================================================================
# Awesome Android Tuning - 三星 One UI 安全精简脚本
# 仅针对冗余组件执行 disable-user，严禁暴力卸载，保留 Galaxy Store 与手表生态
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

# 设备选择逻辑
TARGET_DEVICE="$1"
if [ "$1" = "-s" ] && [ -n "$2" ]; then
  TARGET_DEVICE="$2"
fi

if [ -z "$TARGET_DEVICE" ]; then
  DEVICES_COUNT=$(adb devices | grep -v "List" | grep "device$" | wc -l | tr -d ' ')
  if [ "$DEVICES_COUNT" -eq 0 ]; then
    echo -e "${RED}[错误] 未检测到已连接设备。${NC}"
    exit 1
  elif [ "$DEVICES_COUNT" -gt 1 ]; then
    echo -e "${YELLOW}[提示] 检测到多台连接设备：${NC}"
    adb devices -l | grep -v "List" | grep "device"
    read -r -p "请输入目标设备序列号: " TARGET_DEVICE
  else
    TARGET_DEVICE=$(adb devices | grep -v "List" | grep "device$" | awk '{print $1}')
  fi
fi

ADB_CMD="adb -s $TARGET_DEVICE"

BRAND=$($ADB_CMD shell getprop ro.product.brand | tr -d '\r')
if [ "$BRAND" != "samsung" ]; then
  echo -e "${YELLOW}[警告] 当前设备品牌为 [$BRAND]，非三星设备！此脚本专门针对 Samsung One UI。${NC}"
  read -r -p "是否依然强行继续? (y/N): " FORCE_CONT
  if [[ ! "$FORCE_CONT" =~ ^[Yy]$ ]]; then
    echo "已取消操作。"
    exit 0
  fi
fi

echo -e "${BLUE}================================================================${NC}"
echo -e "${GREEN}🧹 准备为三星设备 [${TARGET_DEVICE}] 执行安全精简...${NC}"
echo -e "   - 策略: 使用 pm disable-user --user 0 冻结，不删除 apk"
echo -e "   - 保留: Galaxy Store、穿戴组件、相机、S Pen、Samsung Pay"
echo -e "${BLUE}================================================================${NC}"

# 精简包名清单
PACKAGES_TO_DISABLE=(
  # --- 1. Bixby 语音与识屏 ---
  "com.samsung.android.bixby.agent"
  "com.samsung.android.bixby.wakeup"
  "com.samsung.android.bixbyhelper"
  "com.samsung.android.bixbytouch"
  "com.samsung.android.visionintelligence"

  # --- 2. 游戏优化服务 (GOS) 与工具 ---
  "com.samsung.android.game.gos"
  "com.samsung.android.game.gametools"
  "com.samsung.gpuwatchapp"

  # --- 3. AR 虚拟形象与壁纸特效 ---
  "com.samsung.android.aremoji"
  "com.samsung.android.app.dressroom"
  "com.samsung.android.stickercenter"
  "com.samsung.android.musewallpaper"
  "com.samsung.android.wallpaper.live"
  "com.samsung.android.dynamiclock"
  "com.samsung.android.app.camera.sticker.facearavatar.preload"

  # --- 4. 冗余云服务、推广与大数据遥测 ---
  "com.samsung.android.scloud"
  "com.samsung.android.mobileservice"
  "com.samsung.android.rubin.app"
  "com.samsung.android.da.daagent"
  "com.samsung.android.storyservice"
  "com.samsung.petservice"
  "com.samsung.mediasearch"
  "com.samsung.mfcontents"

  # --- 5. 中国特供组件与运营商臃肿预装 ---
  "com.samsung.hongbaoassistant"
  "com.samsung.android.tencentwifisecurity"
  "com.samsung.hidden.china"
  "com.samsung.android.sm_cn"
  "com.samsung.chn.apps.devicemanagement"
  "com.samsung.android.chnfileshare.kit"
  "com.samsung.android.messaging.extension.chn"
  "com.baidu.location.fused"
  "com.tencent.soter.soterserver"
  "com.microsoft.appmanager"
  "com.samsung.preloadapp"
  "com.sec.android.yellowpage"

  # --- 6. 不常用边缘功能套件 ---
  "com.samsung.android.app.sharelive"
  "com.samsung.android.smartmirroring"
  "com.samsung.android.app.interpreter"
  "com.samsung.android.smartmeeting"
  "com.samsung.android.smartcopywriting"
  "com.samsung.android.smartsuggestions"
  "com.samsung.android.app.clipboardedge"
  "com.samsung.android.video"
  "com.samsung.android.app.dofviewer"
  "com.samsung.android.widget.pictureframe"
  "com.samsung.android.app.sketchbook"
  "com.samsung.android.kidsinstaller"
  "com.samsung.android.app.parentalcare"
  "com.samsung.android.minormode"
  "com.samsung.android.beaconmanager"
  "com.samsung.android.carlink"
  "com.samsung.android.carkey"
  "com.samsung.android.mocca"
  "com.samsung.android.inputshare"
  "com.samsung.sightcare"
  "com.sec.android.app.sbrowser"
)

SUCCESS_COUNT=0
SKIP_COUNT=0

echo -e "正在执行冻结操作...\n"
for pkg in "${PACKAGES_TO_DISABLE[@]}"; do
  # 检查包是否存在
  if $ADB_CMD shell pm list packages | grep -q "$pkg"; then
    result=$($ADB_CMD shell pm disable-user --user 0 "$pkg" 2>&1)
    if echo "$result" | grep -q "new state: disabled"; then
      echo -e "  ${GREEN}✅ 已冻结${NC}: $pkg"
      SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    else
      echo -e "  ${YELLOW}⚠️ 跳过 (可能已冻结或受保护)${NC}: $pkg"
      SKIP_COUNT=$((SKIP_COUNT + 1))
    fi
  else
    echo -e "  ⚪ 未安装: $pkg"
    SKIP_COUNT=$((SKIP_COUNT + 1))
  fi
done

# 顺带检查快充设置
echo -e "\n正在确保超级快充开启..."
$ADB_CMD shell settings put global super_fast_charging 1
echo -e "  ${GREEN}✅ 超级快充开关已激活 (super_fast_charging = 1)${NC}"

echo -e "\n${BLUE}================================================================${NC}"
echo -e "${GREEN}🎉 三星安全精简完成！成功冻结: ${SUCCESS_COUNT} 个组件，跳过/未安装: ${SKIP_COUNT} 个。${NC}"
echo -e "💡 如需随时还原，请运行: ./samsung_restore.sh"
echo -e "${BLUE}================================================================${NC}"
