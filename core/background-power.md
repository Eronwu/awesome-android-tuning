# 后台调度与电池健康洞察

Android 内存与后台管理是保持设备长期不卡顿、待机不崩电的关键。

---

## 1. 电池健康度与真实寿命洞察 (Battery Health)

很多用户在手机系统设置中只能看到大致百分比，而无法获取硬件底层的真实损耗。

通过 `dumpsys battery`，可以读取内核上报的关键健康参数：

```bash
adb shell dumpsys battery
```

### 关键字段解析

- `mSavedBatteryAsoc: [92]`：ASOC (Absolute State of Charge)，代表电池的真实绝对健康度百分比。92 即代表损耗约 8%。
- `battery FirstUseDate: [20240629]`：电池出厂/首次激活使用日期。
- `level: 100`：当前电量。
- `temperature: 350`：电池当前温度（350 代表 35.0°C）。
- `voltage: 4261`：电池实时电压（单位 mV）。

---

## 2. 无障碍服务 (Accessibility Services) 清理

无障碍服务（Accessibility Service）虽然能够实现自动化点击等强大功能，但它会在每一帧界面更新时拦截系统事件树，对内存常驻和触控延迟有显著影响。

### 查看当前启用的无障碍服务
```bash
adb shell settings get secure enabled_accessibility_services
```

### 清空/关闭全部无障碍常驻服务
```bash
adb shell settings delete secure enabled_accessibility_services
```

---

## 3. 后台进程数量控制与待机策略

Android 系统自带 `App Standby` 机制。对于多任务重载且可用内存吃紧的设备，可以调控后台进程总数：

```bash
# 开启应用待机 (App Standby)
adb shell settings put global app_standby_enabled 1

# 限制后台缓存进程数量（例如限制为 4 个，默认 null 为自适应）
# adb shell settings put global background_process_limit 4
```

---

## 4. 批量强退后台顽固应用 (Force Stop)

国内很多应用具备互保与频繁后台常驻特征。在发热或者游戏前，可以通过脚本执行批量 `am force-stop`，释放数百兆可用 RAM。
（详见 `scripts/kill_background.sh`）
