#!/usr/bin/env bash
# ==============================================================================
# Awesome Android Tuning - 三星 One UI 一键全量恢复脚本
# 将之前被冻结的三星预装组件全部解除禁用，恢复出厂默认状态
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
  read -r -p "请输入目标设备序列号: " TARGET_DEVICE
  ADB_CMD="adb -s $TARGET_DEVICE"
else
  TARGET_DEVICE=$(adb devices | grep -v "List" | grep "device$" | awk '{print $1}')
  ADB_CMD="adb -s $TARGET_DEVICE"
fi

echo -e "${BLUE}================================================================${NC}"
echo -e "${YELLOW}🔄 准备为三星设备 [${TARGET_DEVICE}] 执行预装恢复...${NC}"
echo -e "${BLUE}================================================================${NC}"

RESTORE_PKGS=(
  "com.samsung.android.bixby.agent"
  "com.samsung.android.bixby.wakeup"
  "com.samsung.android.bixbyhelper"
  "com.samsung.android.bixbytouch"
  "com.samsung.android.visionintelligence"
  "com.samsung.android.game.gos"
  "com.samsung.android.game.gametools"
  "com.samsung.gpuwatchapp"
  "com.samsung.android.aremoji"
  "com.samsung.android.app.dressroom"
  "com.samsung.android.stickercenter"
  "com.samsung.android.musewallpaper"
  "com.samsung.android.wallpaper.live"
  "com.samsung.android.dynamiclock"
  "com.samsung.android.app.camera.sticker.facearavatar.preload"
  "com.samsung.android.scloud"
  "com.samsung.android.mobileservice"
  "com.samsung.android.rubin.app"
  "com.samsung.android.da.daagent"
  "com.samsung.android.storyservice"
  "com.samsung.petservice"
  "com.samsung.mediasearch"
  "com.samsung.mfcontents"
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
  "com.sec.android.app.samsungapps"
)

RESTORED=0
for pkg in "${RESTORE_PKGS[@]}"; do
  res=$($ADB_CMD shell pm enable --user 0 "$pkg" 2>&1)
  if echo "$res" | grep -q "new state: enabled"; then
    echo -e "  ${GREEN}✅ 已恢复${NC}: $pkg"
    RESTORED=$((RESTORED + 1))
  fi
done

echo -e "\n${BLUE}================================================================${NC}"
echo -e "${GREEN}🎉 恢复完成！共恢复已禁用组件: ${RESTORED} 个。${NC}"
echo -e "${BLUE}================================================================${NC}"
