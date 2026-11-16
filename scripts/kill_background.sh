#!/usr/bin/env bash
# ==============================================================================
# Awesome Android Tuning - 高频常驻后台批量降温杀后台脚本
# 针对国内高频常驻、自启、推送保活的常见第三方应用执行 force-stop
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
echo -e "${YELLOW}🛑 正在对 [${TARGET_DEVICE}] 的非必要后台进程执行强退降温...${NC}"
echo -e "${BLUE}================================================================${NC}"

COMMON_BACKGROUND_APPS=(
  # 社交与工作沟通
  "com.tencent.mm"
  "com.ss.android.lark"
  "com.tencent.mobileqq"
  "com.alibaba.android.rimet"
  "com.whatsapp"
  "org.telegram.messenger"
  "com.instagram.android"
  "com.twitter.android"

  # 电商与生活服务
  "com.taobao.taobao"
  "com.jingdong.app.mall"
  "com.xunmeng.pinduoduo"
  "com.taobao.idlefish"
  "com.sankuai.meituan"
  "com.dianping.v1"
  "com.xingin.xhs"
  "ctrip.android.view"
  "com.autonavi.minimap"
  "com.baidu.BaiduMap"

  # 资讯与流媒体
  "tv.danmaku.bili"
  "com.zhihu.android"
  "com.douban.frodo"
  "com.netease.cloudmusic"
  "com.tencent.qqmusic"
  "com.kugou.android"
  "com.spotify.music"
  "com.tencent.weread"

  # 云盘与网盘
  "com.baidu.netdisk"
  "com.alicloud.databox"
  "com.chinamobile.mcloud"
  "com.cn21.ecloud"
  "com.dropbox.android"

  # AI / 大模型
  "com.deepseek.chat"
  "com.openai.chatgpt"
  "com.google.android.apps.bard"
  "ai.x.grok"
  "com.moonshot.kimichat"
)

COUNT=0
for pkg in "${COMMON_BACKGROUND_APPS[@]}"; do
  # 判断该包名是否在设备中安装
  if $ADB_CMD shell pm list packages | grep -q "$pkg"; then
    $ADB_CMD shell am force-stop "$pkg" 2>/dev/null
    COUNT=$((COUNT + 1))
  fi
done

echo -e "${GREEN}✅ 已强退处理 ${COUNT} 个活跃或常驻第三方应用。${NC}"

# 查看释放后内存
MEM_AVAIL=$($ADB_CMD shell cat /proc/meminfo | grep "MemAvailable" | awk '{print int($2/1024)}')
echo -e "当前设备剩余可用内存: ${GREEN}${MEM_AVAIL} MB${NC}"
echo -e "${BLUE}================================================================${NC}"
