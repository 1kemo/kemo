/// 隐私与数据共享披露配置（满足 App Store 5.1.1(i) / 5.1.2(i)）
/// 请将 [kPrivacyPolicyUrl] 替换为你的实际隐私政策页面地址。
///
/// 隐私政策页面须包含（审核要求）：
/// - 本应用收集哪些数据（如：对话文本、所选 AI 人格）
/// - 如何收集（如：用户输入、本地选择）
/// - 数据的所有用途（如：调用第三方 AI 生成回复、改善服务）
/// - 与哪些第三方共享（如：DeepSeek），并说明该第三方提供相同或同等的隐私保护

/// 第三方 AI 服务提供商名称（用于向用户披露「数据发送给谁」）
const String kThirdPartyAIName = 'DeepSeek（深度求索）';

/// 隐私政策完整版 URL（替换为实际链接后，应用内将优先打开该网页）
const String kPrivacyPolicyUrl =
    'https://sites.google.com/view/k-m111/%E9%A6%96%E9%A1%B5';

/// 是否为占位 URL（未配置真实链接时，应用内会展示本地隐私政策以保证审核时可读）
bool get kPrivacyPolicyUrlIsPlaceholder =>
    kPrivacyPolicyUrl.isEmpty ||
    kPrivacyPolicyUrl.contains('your-domain.com');
