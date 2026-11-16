# 三星 One UI 安全精简与预装冻结清单

> **实机验证环境**：Samsung Galaxy S24 Ultra (SM-S9110) / One UI 8.0.5 / Android 16  
> **精简原则**：仅使用 `pm disable-user --user 0` 冻结，随时可通过 `pm enable --user 0` 恢复。

---

## 🚫 精简清单分类明细（已实测通过）

### 1. Bixby 语音与视觉生态（绝大部分国内用户使用外部语音助手或已习惯关闭）
| 包名 | 组件功能 | 冻结说明 |
|---|---|---|
| `com.samsung.android.bixby.agent` | Bixby 语音主代理服务 | 彻底关闭 Bixby 语音监听 |
| `com.samsung.android.bixby.wakeup` | Bixby 语音唤醒监听服务 | 消除后台麦克风监听与耗电 |
| `com.samsung.android.bixbyhelper` | Bixby 辅助框架 | 辅助通信进程 |
| `com.samsung.android.bixbytouch` | Bixby 触控识屏 | 界面触摸扫描组件 |
| `com.samsung.android.visionintelligence` | Bixby 视觉核心服务 | 相机/图库扫描识图 |

### 2. 游戏优化服务 (GOS) 与游戏工具
| 包名 | 组件功能 | 冻结说明 |
|---|---|---|
| `com.samsung.android.game.gos` | Game Optimizing Service | 三星温控降频降分辨率罪魁祸首，冻结可释放性能 |
| `com.samsung.android.game.gametools` | 游戏工具浮窗 | 游戏内弹窗菜单 |
| `com.samsung.gpuwatchapp` | GPU 监控调试工具 | 常驻监控组件 |

### 3. AR 虚拟形象与壁纸特效
| 包名 | 组件功能 | 冻结说明 |
|---|---|---|
| `com.samsung.android.aremoji` | AR Emoji 虚拟人偶 | 极高存储与常驻占用 |
| `com.samsung.android.app.dressroom` | AR 试衣间 | AR 换装组件 |
| `com.samsung.android.stickercenter` | 贴纸中心 | 动图与贴纸推送 |
| `com.samsung.android.musewallpaper` | 动态壁纸服务 | 动态锁屏壁纸后台 |
| `com.samsung.android.wallpaper.live` | 动态壁纸核心 | 动态锁屏 |
| `com.samsung.android.dynamiclock` | 动态锁屏轮播 | 锁屏自动更换壁纸与推送 |
| `com.samsung.android.app.camera.sticker.facearavatar.preload` | 相机人脸 AR 预装资源 | 冗余预装 |

### 4. 冗余云服务、推广与大数据遥测
| 包名 | 组件功能 | 冻结说明 |
|---|---|---|
| `com.samsung.android.scloud` | 三星云同步主程序 | 国内通常使用百度网盘/天翼云/本地备份 |
| `com.samsung.android.mobileservice` | 三星 Experience 服务 | 用户画像采集与联动推送 |
| `com.samsung.android.rubin.app` | Rubin 个人使用习惯分析引擎 | 持续扫描用户行为以提供个性化建议 |
| `com.samsung.android.da.daagent` | 诊断数据采集代理 | 崩溃日志与使用习惯回传 |
| `com.samsung.android.storyservice` | 图库故事自动生成 | 后台扫描相册分析人脸 |
| `com.samsung.petservice` | 宠物识别与贴图服务 | 后台图像分类 |
| `com.samsung.mediasearch` | 媒体搜索引擎 | 本地媒体自动索引 |
| `com.samsung.mfcontents` | 媒体内容推送 | 冗余推广服务 |

### 5. 中国特供组件与运营商臃肿预装
| 包名 | 组件功能 | 冻结说明 |
|---|---|---|
| `com.samsung.hongbaoassistant` | 微信红包助手 | 监听通知栏的特供插件 |
| `com.samsung.android.tencentwifisecurity` | 腾讯 Wi-Fi 安全检测 | 假性安全检测，频繁弹窗 |
| `com.samsung.hidden.china` | 中国特供隐藏配置管理 | 本地化定制常驻 |
| `com.samsung.android.sm_cn` | 三星智汇管家 (中国版特供) | 杀后台与多余安全管家 |
| `com.samsung.chn.apps.devicemanagement` | 三星中国设备管理 | 特供企业管理通道 |
| `com.samsung.android.chnfileshare.kit` | 中国文件互传套件 | 与第三方快传冲突 |
| `com.samsung.android.messaging.extension.chn` | 短信特供增强服务 | 智能短信解析推广 |
| `com.baidu.location.fused` | 百度网络融合定位核心 | 百度 SDK 冗余定位服务 |
| `com.tencent.soter.soterserver` | 腾讯 Soter 生物识别服务 | 部分银行/支付生物通道备选 |
| `com.microsoft.appmanager` | 微软应用链接与推广 | 链接至 Windows 冗余分发 |
| `com.samsung.preloadapp` | 预装应用释放器 | 出厂恢复时刷预装使用的组件 |
| `com.sec.android.yellowpage` | 电话黄页查询 | 拨号界面广告与商家信息展示 |

### 6. 不常用边缘功能与小众套件
| 包名 | 组件功能 | 冻结说明 |
|---|---|---|
| `com.samsung.android.app.sharelive` | 屏幕共享直播 | 会议同屏工具 |
| `com.samsung.android.smartmirroring` | 智能投屏增强组件 | 投屏高级功能 |
| `com.samsung.android.app.interpreter` | 同声传译独立组件 | 绝大多数用户使用专用 AI App |
| `com.samsung.android.smartmeeting` | 智能会议 | 三星会议助手 |
| `com.samsung.android.smartcopywriting` | 智能写作辅助 | 写作润色（现已被 ChatGPT/DeepSeek 取代） |
| `com.samsung.android.smartsuggestions` | 智能建议服务 | 负一屏智能推荐卡片 |
| `com.samsung.android.app.clipboardedge` | 侧屏幕剪贴板 | 侧边栏剪贴板（易造成剪贴板监听） |
| `com.samsung.android.video` | 三星自带视频播放器 | 界面老旧，推荐第三方播放器 (MX/VLC) |
| `com.samsung.android.app.dofviewer` | 景深照片查看器 | 独立景深渲染插件 |
| `com.samsung.android.widget.pictureframe` | 相框小组件 | 桌面相框小部件 |
| `com.samsung.android.app.sketchbook` | 涂鸦画板 | 边缘绘图应用 |
| `com.samsung.android.kidsinstaller` | 儿童天地安装器 | 儿童模式入口 |
| `com.samsung.android.app.parentalcare` | 家长控制中心 | 防沉迷与家长监控 |
| `com.samsung.android.minormode` | 未成年人模式 | 防沉迷 |
| `com.samsung.android.beaconmanager` | 蓝牙信标服务 | 室内信标定位检测 |
| `com.samsung.android.carlink` | 三星车机联动套件 | 无对应车机时纯占后台 |
| `com.samsung.android.carkey` | 数字车钥匙服务 | 不使用支持车型的用户可冻结 |
| `com.samsung.android.mocca` | 场景感知框架 | 运动/情景后台扫描 |
| `com.samsung.android.inputshare` | 多设备键鼠共享 | 类似随航的跨平板键鼠控制 |
| `com.samsung.sightcare` | 视力关怀护眼提醒 | 距离过近弹窗提醒 |
| `com.sec.android.app.sbrowser` | 三星自带浏览器 (SBrowser) | 推荐使用轻量 Via 或支持扩展的 Firefox |

---

## 🛡️ 严格保留清单（绝对不能禁用的系统核心）

为了保证三星核心生态体验与日常稳定，以下包名在脚本中**做了严格白名单保护，绝对不予冻结**：

- `com.sec.android.app.samsungapps`：**Galaxy Store (三星应用商店)** — 保证 Good Lock 模块升级与手表插件运行的命脉！
- `com.samsung.android.app.watchmanager`：Galaxy Wearable 手表管理。
- `com.samsung.wearable.watch7plugin`：Galaxy Watch 具体插件。
- `com.samsung.accessory.zenithmgr`：Galaxy Buds 耳机管理。
- `com.samsung.android.spay`：Samsung Pay（刷门禁卡/交通卡依赖）。
- `com.samsung.android.goodlock`：Good Lock 官方套件。
- `com.sec.android.app.camera` / 相机助理：官方相机与专业画质引擎。
- Knox 安全与生物认证模块 (`com.samsung.android.biometrics` 等)。
