# AI 数据共享同意对话框 - App Store 合规说明

## 概述
根据 Apple App Store 审核指南 5.1.1(i) 和 5.1.2(i)，在使用第三方 AI 服务之前，必须明确告知用户数据共享的详细信息并获得同意。

## 实现位置
- 文件：`lib/screens/chat_screen.dart`
- 方法：`_showAIDataConsentDialog()`
- 触发时机：
  1. 首次打开聊天界面时（如果用户未同意）
  2. 用户尝试发送消息但未同意时

## 对话框内容结构

### 1. 标题
- 图标：隐私提示图标
- 文字：「使用 AI 对话服务须知」

### 2. 核心信息（三个关键部分）

#### ✅ 什么数据（发送的数据）
明确列出将要发送的数据类型：
- 您输入的对话文本内容
- 您选择的 AI 人格类型

**视觉设计**：紫色卡片，带有文档图标

#### ✅ 发送给谁（接收方）
明确标识第三方服务商：
- **DeepSeek（深度求索）**

**视觉设计**：粉色卡片，带有云图标

#### ✅ 用途（数据用途）
说明数据的使用目的：
- 用于生成 AI 回复、提供情感支持和对话服务

**视觉设计**：蓝色卡片，带有星星图标

### 3. 重要提示
橙色提示框，说明：
- 仅在用户同意后才发送数据
- 引导用户查看完整隐私政策

### 4. 操作按钮
- **不同意**：灰色文本按钮，关闭对话框
- **查看隐私政策**：紫色文本按钮，跳转到隐私政策页面
- **同意并继续**：粉色实心按钮，保存同意状态并继续操作

## 合规要点

### ✅ 符合 App Store 要求
1. **清晰明确**：使用分块卡片设计，信息层次清晰
2. **三要素齐全**：
   - ✓ 什么数据
   - ✓ 发送给谁
   - ✓ 用途
3. **用户控制**：提供明确的同意/拒绝选项
4. **隐私政策链接**：提供查看完整隐私政策的入口
5. **不可绕过**：`barrierDismissible: false` 确保用户必须做出选择
6. **首次使用触发**：在用户首次使用 AI 功能前显示

### ✅ 用户体验优化
1. **视觉分区**：使用不同颜色的卡片区分不同信息类型
2. **图标辅助**：每个部分都有对应的图标，提高可读性
3. **字体层级**：标题、正文、提示文字使用不同字号和粗细
4. **按钮层级**：主要操作使用实心按钮，次要操作使用文本按钮

## 触发逻辑

### 首次启动
```dart
@override
void initState() {
  super.initState();
  _loadConsentAndShowDialogIfNeeded();
}

Future<void> _loadConsentAndShowDialogIfNeeded() async {
  final consent = await _storage.getAIDataSharingConsent();
  if (!consent) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showAIDataConsentDialog(thenSend: false);
    });
  }
}
```

### 发送消息前检查
```dart
Future<void> _sendMessage() async {
  if (!_hasConsent) {
    _showAIDataConsentDialog(thenSend: true);
    return;
  }
  // 继续发送消息...
}
```

## 数据存储
用户的同意状态保存在本地 SharedPreferences 中：
- Key: `ai_data_sharing_consent`
- 方法: `StorageService.setAIDataSharingConsent(bool)`
- 读取: `StorageService.getAIDataSharingConsent()`

## 测试步骤

### 测试场景 1：首次使用
1. 清除应用数据或重新安装
2. 登录应用
3. 进入聊天界面
4. 验证对话框自动弹出
5. 检查所有信息是否清晰显示

### 测试场景 2：拒绝后再次尝试
1. 点击「不同意」
2. 尝试发送消息
3. 验证对话框再次弹出

### 测试场景 3：查看隐私政策
1. 点击「查看隐私政策」
2. 验证跳转到隐私政策页面
3. 返回后验证对话框重新显示

### 测试场景 4：同意并继续
1. 点击「同意并继续」
2. 验证对话框关闭
3. 如果是发送消息触发，验证消息正常发送
4. 关闭应用重新打开，验证不再显示对话框

## 视觉效果

```
┌─────────────────────────────────────────┐
│ 🔒 使用 AI 对话服务须知                    │
├─────────────────────────────────────────┤
│                                         │
│ 为向您提供 AI 对话功能，本应用需要与      │
│ 第三方 AI 服务商共享您的数据。            │
│                                         │
│ ┌─────────────────────────────────┐    │
│ │ 📄 发送的数据                    │    │
│ │ • 您输入的对话文本内容            │    │
│ │ • 您选择的 AI 人格类型            │    │
│ └─────────────────────────────────┘    │
│                                         │
│ ┌─────────────────────────────────┐    │
│ │ ☁️  接收方（第三方服务商）         │    │
│ │ DeepSeek（深度求索）              │    │
│ └─────────────────────────────────┘    │
│                                         │
│ ┌─────────────────────────────────┐    │
│ │ ✨ 数据用途                       │    │
│ │ 用于生成 AI 回复、提供情感支持    │    │
│ │ 和对话服务                        │    │
│ └─────────────────────────────────┘    │
│                                         │
│ ┌─────────────────────────────────┐    │
│ │ ℹ️  我们仅在您点击「同意并继续」   │    │
│ │ 后才会向上述第三方服务商发送数据。 │    │
│ └─────────────────────────────────┘    │
│                                         │
├─────────────────────────────────────────┤
│  不同意  查看隐私政策  [同意并继续]      │
└─────────────────────────────────────────┘
```

## App Store 审核回复模板

如果审核团队询问数据共享披露：

---

**Subject: AI Data Sharing Disclosure Implementation**

Dear App Review Team,

We have implemented a comprehensive data sharing disclosure dialog that appears before users can use AI features.

**When the dialog appears:**
1. First time user opens the Chat screen
2. When user attempts to send a message without prior consent

**Dialog content includes:**
- **What data**: User's input text and selected AI personality type
- **Who receives it**: DeepSeek (深度求索) - clearly identified
- **Purpose**: To generate AI responses and provide emotional support

**User controls:**
- "Disagree" button to decline
- "View Privacy Policy" button to read full policy
- "Agree and Continue" button to provide consent

The dialog cannot be dismissed without making a choice, and data is only sent after explicit user consent.

Thank you for your review.

---

## 相关文件
- 实现文件：`lib/screens/chat_screen.dart`
- 配置文件：`lib/config/privacy_config.dart`
- 隐私政策：`lib/screens/privacy_policy_screen.dart`
- 存储服务：`lib/services/storage_service.dart`

## 更新日期
2026年2月21日
