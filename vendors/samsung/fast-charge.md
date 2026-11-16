# 三星超级快充与电池保护指南

三星 Galaxy 旗舰机型（如 S23 Ultra / S24 Ultra）硬件最高支持 45W 协议（Super Fast Charging 2.0），但由于出厂默认策略或更新后偶发关闭，部分设备处于仅开启「自适应快充 (15W~25W)」甚至「慢充」的状态。

---

## 1. 开启 45W 超级快充 (Super Fast Charging)

### 开启命令
```bash
adb shell settings put global super_fast_charging 1
```

### 验证状态
```bash
adb shell settings get global super_fast_charging
# 返回 1 代表已开启超级快充
```

---

## 2. 电池保护模式 (Battery Protect) 策略

在 One UI 6.1+ 中，三星提供了 3 种电池保护等级：
- **最大保护 (Maximum)**：充至 80% 立即停止充电。
- **自适应保护 (Adaptive)**：夜间充至 80%，根据起床闹钟前自动补满至 100%。
- **基本保护 (Basic)**：充至 100% 断充，降至 95% 时重新补电。

### 检查当前保护阈值
```bash
adb shell dumpsys battery | grep -E "mProtectBatteryMode|mProtectionThreshold"
```

如果你希望延长锂电池寿命（如保持 ASOC 健康度在 90% 以上长达数年），建议在日常办公室或桌面插线使用时开启 80% 限制。
