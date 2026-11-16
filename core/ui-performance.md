# UI 与性能调优指南

流畅度不仅取决于硬件绝对算力，更取决于动画曲线、GPU 硬件参与度以及系统的调度延迟。

---

## 1. 动画缩放提速 (0.5x 极致跟手)

Android 默认的窗口、过渡与动画时长均为 `1.0x`。将其压缩为 `0.5x` 可以大幅减少界面交互等待时间，体感性能显著飞跃。

### 调整指令
```bash
# 窗口动画缩放 (Window animation scale)
adb shell settings put global window_animation_scale 0.5

# 过渡动画缩放 (Transition animation scale)
adb shell settings put global transition_animation_scale 0.5

# 动画程序时长缩放 (Animator duration scale)
adb shell settings put global animator_duration_scale 0.5
```

### 验证状态
```bash
adb shell settings get global window_animation_scale
adb shell settings get global transition_animation_scale
adb shell settings get global animator_duration_scale
```

*若想恢复默认，只需将值改为 `1.0` 即可。*

---

## 2. 强制 GPU 硬件渲染 (Force GPU UI Rendering)

现代旗舰移动平台（如骁龙 8 系平台）的 Adreno GPU 算力极其充沛，而 CPU 经常因为主频调度策略、多任务争抢导致微小掉帧。

开启强制 GPU 渲染后，系统将所有窗口 2D 绘制全面卸载至 GPU 处理，大幅降低 CPU 开销并消除滑动偶发卡顿。

### 开启指令
```bash
adb shell settings put global force_hw_ui 1
```

### 验证状态
```bash
adb shell settings get global force_hw_ui
# 返回 1 即代表已开启
```

---

## 3. 高刷新率策略确认

对于支持 120Hz/144Hz LTPO 自适应高刷的设备，可以通过 dumpsys 确认当前屏幕档位与刷新模式：

```bash
adb shell dumpsys display | grep -E "mRefreshRate|DisplayModeRecord" | head -10
```

如果设备在某些特定应用强制锁 60Hz，可通过品牌专属模式或全局高刷强制指令解除（详见各厂商专区）。
