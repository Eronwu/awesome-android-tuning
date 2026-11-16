# 网络与隐私治理指南

现代 Android 设备在日常使用中，后台无感知的扫描与网络明文查询往往是耗电与隐私泄露的重灾区。

---

## 1. Private DNS（私有 DNS / DoT）选型与避坑实测

Android 9+ 引入了基于 TLS 的 Private DNS。在设备设置中开启私有 DNS，能够全系统防止运营商劫持（HTTP/DNS 劫持弹广告）。

### 国内主流方案横向实测对比

| 服务商 | 主机名 (Hostname) | 广告拦截 | 解析延迟 | 蜂窝网络兼容性 | 推荐结论 |
|---|---|---|---|---|---|
| **阿里 DNS (AliDNS)** | `dns.alidns.com` | ❌ 纯净 | 极低 (<15ms) | 极佳，CDN 不误杀 | ⭐⭐⭐⭐⭐ **国内首选** |
| **腾讯 DNSPod** | `dot.pub` | ❌ 纯净 | 极低 (<15ms) | 极佳 | ⭐⭐⭐⭐ 备用 |
| **AdGuard DNS** | `dns.adguard-dns.com` | ✅ 强力 | 较高 (境外路由) | ⚠️ **高概率误杀国内 CDN 图片** | 仅建议海外网络 |
| **Cloudflare** | `1dot1dot1dot1.cloudflare-dns.com` | ❌ 纯净 | 较高 | 偶尔丢包 | 不建议国内蜂窝直连 |

> ⚠️ **实战经验教训**：  
> 切勿盲目开启 AdGuard DNS 作为国内手机的 Private DNS。国内三大运营商蜂窝网络下，AdGuard 会导致大量主流 App（小红书、电商、微信朋友圈等）图片无法加载（误杀 CDN 域名）。  
> **推荐的最佳实践是**：系统级 Private DNS 采用 `dns.alidns.com` 防运营商劫持与提速；应用级去广告交给轻量浏览器（如 Via 自带规则）或本地 VPN 代理分流（Clash/Surge 规则）。

### 配置阿里 DNS
```bash
adb shell settings put global private_dns_mode hostname
adb shell settings put global private_dns_specifier dns.alidns.com
```

### 验证与关闭
```bash
# 验证
adb shell settings get global private_dns_specifier

# 关闭（恢复默认）
adb shell settings put global private_dns_mode off
```

---

## 2. 关闭 Wi-Fi 始终后台扫描 (Wi-Fi Scanning)

Android 默认在 Wi-Fi 处于关闭状态时，依然允许系统及具备定位权限的应用在后台持续唤醒射频模块扫描周围 Wi-Fi 热点以辅助粗略定位。该行为会产生静默耗电并泄露行踪。

### 关闭后台扫描
```bash
adb shell settings put global wifi_scan_always_enabled 0
```

### 验证状态
```bash
adb shell settings get global wifi_scan_always_enabled
# 返回 0 即代表彻底关闭后台扫描
```
