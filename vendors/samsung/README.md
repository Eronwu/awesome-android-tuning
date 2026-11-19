# 三星 Galaxy (One UI) 深度调优专区

三星的 One UI 功能强大、定制维度极高，但同时也包含了大量服务生态捆绑（Bixby、AR Emoji、Samsung Pay、游戏优化 GOS、云端同步以及国行特供安全组件）。

本专区汇总针对三星设备的专有调优方案，并在 **Galaxy S23 (SM-S9110, One UI 8.0.5 / Android 16)** 上完成了严苛的实机可用性验证。

---

## 🎯 调优核心目标

1. **消除冗余常驻**：冻结 50+ 个用户几乎不用的后台常驻与遥测服务。
2. **保护核心生态**：明确保留 **Galaxy Store (三星应用商店)**、**穿戴设备套件 (Galaxy Watch / Buds Manager)**、**Good Lock**、**S Pen / 相机核心算法**。
3. **性能与续航双赢**：释放 ~400MB+ 系统 RAM，解除充电功率限制，降低待机发热。

---

## 📑 模块导航

- **[安全精简清单 (Debloat List)](debloat-list.md)**：包含 50+ 经过逐一验证的三星预装包名、用途解析、冻结影响分析。
- **[超级快充与电池养护 (Fast Charge)](fast-charge.md)**：开启 45W 完整超级快充与配置保护阈值。
- **自动化脚本**：
  - `../../scripts/samsung_debloat.sh`：一键安全冻结
  - `../../scripts/samsung_restore.sh`：一键全量恢复
