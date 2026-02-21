# App Store 合规性改进总结

## 项目信息
- **应用名称**: 心动信号 (PulseMind AI)
- **版本**: 0.1.0
- **改进日期**: 2026年2月21日
- **合规指南**: Apple App Store Guidelines 5.1.1(v), 5.1.1(i), 5.1.2(i)

---

## 改进概述

本次更新针对 Apple App Store 审核要求，实现了两个关键合规功能：

### 1. ✅ 账号删除功能（Guideline 5.1.1(v)）
### 2. ✅ AI 数据共享披露（Guideline 5.1.1(i) & 5.1.2(i)）

---

## 一、账号删除功能

### 问题描述
> The app supports account creation but does not include an option to initiate account deletion.

### 解决方案
在个人资料页面添加了完整的账号删除功能。

### 实现位置
- **文件**: `lib/screens/profile_screen.dart`
- **方法**: `_deleteAccount()`
- **入口**: 精神轨道（Profile）→ 滚动到底部 → "删除账号"

### 功能特点
✅ 易于访问：从 Profile 页面直接访问  
✅ 清晰确认：详细的确认对话框，列出将被删除的所有数据  
✅ 完整删除：删除所有本地数据（心情记录、聊天历史、设置等）  
✅ 自动登出：删除后自动返回登录界面  
✅ 无需客服：完全在应用内完成，无需联系客服  

### 用户流程
```
Profile 页面
    ↓
滚动到底部
    ↓
点击 "删除账号"
    ↓
查看确认对话框
    ├─ 显示将被删除的数据
    ├─ 警告不可恢复
    └─ 提供取消选项
    ↓
确认删除
    ↓
删除所有数据 + 自动登出
    ↓
返回登录界面
```

### 相关文档
- [ACCOUNT_DELETION.md](docs/ACCOUNT_DELETION.md)
- [ACCOUNT_DELETION_GUIDE.txt](docs/ACCOUNT_DELETION_GUIDE.txt)
- [APP_STORE_REVIEW_RESPONSE.md](APP_STORE_REVIEW_RESPONSE.md)

---

## 二、AI 数据共享披露优化

### 问题描述
需要在用户使用 AI 功能之前，清晰告知：
1. 发送什么数据
2. 发送给谁（第三方服务商）
3. 数据用途

### 解决方案
优化了 AI 数据共享同意对话框，使用分块卡片设计，信息清晰明确。

### 实现位置
- **文件**: `lib/screens/chat_screen.dart`
- **方法**: `_showAIDataConsentDialog()`
- **触发时机**: 
  - 首次打开聊天界面
  - 尝试发送消息但未同意时

### 对话框内容

#### 📄 发送的数据（紫色卡片）
- 您输入的对话文本内容
- 您选择的 AI 人格类型

#### ☁️ 接收方（粉色卡片）
- **DeepSeek（深度求索）**

#### ✨ 数据用途（蓝色卡片）
- 用于生成 AI 回复、提供情感支持和对话服务

#### ℹ️ 重要提示（橙色卡片）
- 仅在用户同意后才发送数据
- 提供隐私政策链接

### 用户选项
1. **不同意** - 关闭对话框，不使用 AI 功能
2. **查看隐私政策** - 跳转到完整隐私政策页面
3. **同意并继续** - 保存同意状态，开始使用 AI 功能

### 技术实现
```dart
// 首次启动检查
Future<void> _loadConsentAndShowDialogIfNeeded() async {
  final consent = await _storage.getAIDataSharingConsent();
  if (!consent) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showAIDataConsentDialog(thenSend: false);
    });
  }
}

// 发送消息前检查
Future<void> _sendMessage() async {
  if (!_hasConsent) {
    _showAIDataConsentDialog(thenSend: true);
    return;
  }
  // 继续发送...
}
```

### 相关文档
- [AI_DATA_CONSENT_DIALOG.md](docs/AI_DATA_CONSENT_DIALOG.md)
- [CONSENT_DIALOG_IMPROVEMENTS.md](docs/CONSENT_DIALOG_IMPROVEMENTS.md)

---

## 合规性检查清单

### Guideline 5.1.1(v) - Account Deletion
- [x] 提供账号删除选项
- [x] 易于访问（从 Profile 页面）
- [x] 包含确认步骤防止误删
- [x] 完全在应用内完成
- [x] 无需客服联系
- [x] 删除所有用户数据
- [x] 自动登出用户

### Guideline 5.1.1(i) - Data Collection Disclosure
- [x] 明确说明收集的数据类型
- [x] 说明数据收集目的
- [x] 标识第三方服务商
- [x] 提供隐私政策链接
- [x] 首次使用前显示

### Guideline 5.1.2(i) - Data Sharing Disclosure
- [x] 明确标识数据接收方
- [x] 说明共享数据的类型
- [x] 说明共享目的
- [x] 用户可以拒绝
- [x] 未同意前不发送数据

---

## 测试指南

### 测试账号删除功能
1. 登录应用并添加一些数据
2. 进入 Profile 页面
3. 滚动到底部找到"删除账号"
4. 点击并查看确认对话框
5. 确认删除
6. 验证返回登录界面
7. 重新登录，验证数据已清空

### 测试 AI 数据共享披露
1. 清除应用数据或重新安装
2. 登录应用
3. 进入聊天界面
4. 验证自动弹出同意对话框
5. 检查所有信息是否清晰显示
6. 测试"不同意"按钮
7. 测试"查看隐私政策"按钮
8. 测试"同意并继续"按钮
9. 验证同意后不再显示对话框

---

## App Store 审核回复模板

### 针对账号删除（5.1.1(v)）

**Subject**: Account Deletion Feature Implementation

Dear App Review Team,

We have implemented account deletion functionality in our app.

**How to access:**
1. Open app → Profile tab (精神轨道)
2. Scroll to bottom
3. Tap "删除账号" (Delete Account)
4. Confirm in dialog

**What happens:**
- All user data is permanently deleted
- User is logged out automatically
- Returns to login screen
- No customer service contact required

Thank you for your review.

---

### 针对数据共享披露（5.1.1(i) & 5.1.2(i)）

**Subject**: AI Data Sharing Disclosure Implementation

Dear App Review Team,

We have implemented a comprehensive data sharing disclosure dialog.

**When it appears:**
- First time user opens Chat screen
- When user attempts to send message without consent

**Dialog includes:**
- **What data**: User's input text and AI personality selection
- **Who receives**: DeepSeek (深度求索) - clearly identified
- **Purpose**: Generate AI responses and provide emotional support

**User controls:**
- "Disagree" to decline
- "View Privacy Policy" to read full policy
- "Agree and Continue" to provide consent

Data is only sent after explicit user consent.

Thank you for your review.

---

## 文件变更清单

### 修改的文件
1. `lib/screens/profile_screen.dart`
   - 添加 `_deleteAccount()` 方法
   - 添加"删除账号"菜单项

2. `lib/screens/chat_screen.dart`
   - 优化 `_showAIDataConsentDialog()` 方法
   - 改进视觉设计和信息结构

### 新增的文档
1. `docs/ACCOUNT_DELETION.md` - 账号删除功能文档
2. `docs/ACCOUNT_DELETION_GUIDE.txt` - 账号删除用户指南
3. `docs/AI_DATA_CONSENT_DIALOG.md` - AI 数据同意对话框文档
4. `docs/CONSENT_DIALOG_IMPROVEMENTS.md` - 对话框改进说明
5. `APP_STORE_REVIEW_RESPONSE.md` - 审核回复模板
6. `APP_STORE_COMPLIANCE_SUMMARY.md` - 本文档

---

## 技术细节

### 数据存储
所有用户数据存储在本地 SharedPreferences：
- 心情记录
- 聊天历史
- AI 人格选择
- 通知设置
- 数据共享同意状态

### 删除机制
```dart
// 账号删除
await _storage.clearAllData(); // 清除所有 SharedPreferences
Navigator.pushAndRemoveUntil(...); // 返回登录界面
```

### 同意状态管理
```dart
// 保存同意状态
await _storage.setAIDataSharingConsent(true);

// 检查同意状态
final consent = await _storage.getAIDataSharingConsent();
```

---

## 后续维护

### 定期检查
- [ ] 监控 App Store 审核指南更新
- [ ] 检查第三方服务商信息是否变更
- [ ] 收集用户反馈并优化文案

### 可选优化
- [ ] 添加多语言支持
- [ ] 优化深色模式显示
- [ ] 添加动画效果
- [ ] 改进无障碍支持

---

## 联系信息

如有问题，请参考以下文档：
- 技术实现：查看源代码注释
- 用户指南：`docs/` 目录下的文档
- 审核回复：`APP_STORE_REVIEW_RESPONSE.md`

---

## 版本历史

### v0.1.0 (2026-02-21)
- ✅ 实现账号删除功能
- ✅ 优化 AI 数据共享披露对话框
- ✅ 完善相关文档

---

**状态**: ✅ 已完成，可提交审核

**最后更新**: 2026年2月21日
