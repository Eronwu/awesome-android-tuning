# Awesome Android Tuning ⚡

> **免 Root、无损、可逆的 Android 现代设备深度调优指南与自动化脚本箱。**  
> 从全机型通用的底层内核、动画、网络与隐私调优，到各大厂商（Samsung One UI、Xiaomi HyperOS、Google Pixel 等）专属的预装精简与功耗温控。

---

## 🌟 核心理念

1. **零破坏，随时可逆 (Zero Harm, Fully Reversible)**：
   - 绝不使用高危删库命令，优先使用 `pm disable-user --user 0` 冻结预装，随时可以通过一条命令完整恢复。
2. **实机实测支撑 (Battle Tested)**：
   - 拒绝盲目照抄陈旧列表。每一项配置、每个包名都在具体机型和具体 Android 版本下经过实机检验。
3. **分层架构设计 (Layered Architecture)**：
   - **通用核心层 (Core)**：全机型通用的流畅度、GPU 硬件加速、Private DNS 防劫持与后台策略。
   - **厂商专精层 (Vendors)**：针对三星 One UI、小米 HyperOS 等特定系统的精简与专有特性。
   - **脚本工具箱 (Scripts)**：即插即用，一条命令完成体检与优化。

---

## 📂 项目结构

```text
awesome-android-tuning/
├── README.md               # 总体导引与快速开始
├── LICENSE                 # MIT License
├── core/                   # 🌐 全机型通用优化指南
│   ├── adb-basics.md       # ADB 环境配置与基础命令
│   ├── ui-performance.md   # 动画 0.5x、强制 GPU 渲染、触控跟手度
│   ├── network-privacy.md  # Private DNS 防劫持选型、后台网络/扫描治理
│   └── background-power.md # 后台限制、应用待机与电池健康度洞察
├── vendors/                # 📱 厂商专精模块
│   ├── samsung/            # ⭐ 首发实测：三星 One UI 深度调优
│   │   ├── README.md       # 三星专区调优指南
│   │   ├── debloat-list.md # 59+ 经实测验证的安全精简清单（含用途分析）
│   │   └── fast-charge.md  # 超级快充开启与电池寿命养护
│   ├── xiaomi/             # 预留：HyperOS / MIUI 广告与系统精简
│   └── google-pixel/       # 预留：Pixel 原生系统本地化与功耗优化
└── scripts/                # 🛠️ 开箱即用 Shell 脚本箱
    ├── check_device.sh     # 📱 设备全面体检（识别硬件、版本、电池 ASOC、内存）
    ├── apply_core_tune.sh  # ⚡ 通用优化一键应用（动画缩放、GPU 渲染、DNS 等）
    ├── samsung_debloat.sh  # 🧹 三星安全精简一键执行
    ├── samsung_restore.sh  # 🔄 三星预装一键全部恢复（防误伤）
    └── kill_background.sh  # 🛑 常见高频后台应用批量强退降温
```

---

## 🚀 快速开始

### 1. 准备工作

- 一台电脑（macOS / Linux / Windows WSL）
- 安装好 `adb` 工具并配置环境变量
- 手机打开 **开发者选项** -> 开启 **USB 调试** -> 用数据线连接电脑并授权

### 2. 一键设备体检

```bash
# 进入脚本目录
cd scripts/

# 给脚本赋予执行权限
chmod +x *.sh

# 对连接的设备进行体检
./check_device.sh
```

### 3. 一键应用通用调优（全机型通用）

优化动画缩放至 0.5x、开启强制 GPU 硬件渲染、配置阿里防劫持 Private DNS、关闭 WiFi 始终后台扫描：

```bash
./apply_core_tune.sh
```

### 4. 三星专精：安全精简与恢复

如果你使用的是三星 Galaxy 设备（One UI 6.x ~ 8.x）：

```bash
# 执行安全精简（冻结 50+ 预装冗余服务，保留 Galaxy Store 与穿戴联动）
./samsung_debloat.sh

# 如有需要，一键恢复全部被禁用的预装组件
./samsung_restore.sh
```

---

## 📱 首发实测机型档案

| 参数 | 实测规格 |
|---|---|
| **设备型号** | Samsung Galaxy S24 Ultra (SM-S9110 国行版) |
| **系统版本** | One UI 8.0.5 / Android 16 (API 36) |
| **核心配置** | Snapdragon 8 Gen 3 for Galaxy / 12GB RAM |
| **实测成效** | 冻结 59 个臃肿预装组件，可用内存释放约 **400MB+**，充电速率与界面跟手度明显改善 |

---

## ⚠️ 免责声明 (Disclaimer)

- 本项目所有命令和脚本均遵循 **无 Root、仅禁用（Disable）非卸载（Uninstall）** 的安全原则。
- 尽管脚本经过严格实测，修改系统隐藏设置仍需了解基本常识，请提前备份重要数据。

---

## 🤝 贡献与共建

欢迎提交 Issue 和 Pull Request！
- 补充更多厂商模块（Xiaomi、OPPO、vivo、Honor、Pixel）
- 报告新系统版本下的包名变更
- 改进自动化脚本与体验
