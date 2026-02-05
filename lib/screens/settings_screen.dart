import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../widgets/glass_card.dart';
import '../utils/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final StorageService _storage = StorageService();
  bool _notificationEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final enabled = await _storage.getNotificationEnabled();
    if (mounted) {
      setState(() => _notificationEnabled = enabled);
    }
  }

  Future<void> _clearChatHistory() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.deepMidnight,
        title: const Text('清除聊天记录', style: TextStyle(color: Colors.white)),
        content: const Text(
          '确定要清空所有 AI 对话记录吗？此操作不可恢复。',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('确定', style: TextStyle(color: AppTheme.vibrantPink)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _storage.clearChatHistory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('聊天记录已清除'),
            backgroundColor: AppTheme.electricPurple,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  Future<void> _clearMoodRecords() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.deepMidnight,
        title: const Text('清除心情记录', style: TextStyle(color: Colors.white)),
        content: const Text(
          '确定要清空所有心情记录吗？连续打卡天数等统计将重置。',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('确定', style: TextStyle(color: AppTheme.vibrantPink)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _storage.clearMoodRecords();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('心情记录已清除'),
            backgroundColor: AppTheme.electricPurple,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  Future<void> _refreshDailyQuote() async {
    await _storage.clearDailyQuote();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('每日共鸣已刷新，返回首页即可看到新内容'),
          backgroundColor: AppTheme.vibrantPink,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.deepMidnight,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.favorite, color: AppTheme.textPrimary, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('可陌', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('可陌 · 版本 0.1.0', style: TextStyle(color: AppTheme.textSecondary)),
              SizedBox(height: 12),
              Text(
                '记录心情、与 AI 对话、发现共鸣，陪你更好地认识自己的情感世界。',
                style: TextStyle(color: AppTheme.textSecondary, height: 1.5),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('知道了', style: TextStyle(color: AppTheme.vibrantPink)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 顶部栏
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.textSecondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textPrimary, size: 20),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        '设置',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              // 设置列表
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '通用',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GlassCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            _SettingTile(
                              icon: Icons.notifications_outlined,
                              title: '消息提醒',
                              subtitle: '每日共鸣、心情记录等提醒',
                              trailing: Switch(
                                value: _notificationEnabled,
                                onChanged: (v) async {
                                  await _storage.setNotificationEnabled(v);
                                  setState(() => _notificationEnabled = v);
                                },
                                activeTrackColor: AppTheme.vibrantPink.withOpacity(0.5),
                              ),
                            ),
                            Divider(height: 1, color: AppTheme.textSecondary.withOpacity(0.08)),
                            _SettingTile(
                              icon: Icons.refresh_rounded,
                              title: '刷新每日共鸣',
                              subtitle: '立即获取新的每日一句话',
                              onTap: _refreshDailyQuote,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '数据',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GlassCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            _SettingTile(
                              icon: Icons.chat_bubble_outline_rounded,
                              title: '清除聊天记录',
                              subtitle: '清空所有 AI 对话内容',
                              onTap: _clearChatHistory,
                              textColor: AppTheme.textSecondary,
                            ),
                            Divider(height: 1, color: AppTheme.textSecondary.withOpacity(0.08)),
                            _SettingTile(
                              icon: Icons.mood_outlined,
                              title: '清除心情记录',
                              subtitle: '清空心情与连续打卡数据',
                              onTap: _clearMoodRecords,
                              textColor: AppTheme.textSecondary,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '关于',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GlassCard(
                        padding: EdgeInsets.zero,
                        child: _SettingTile(
                          icon: Icons.info_outline_rounded,
                          title: '关于我们',
                          subtitle: '版本 0.1.0',
                          onTap: _showAbout,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? textColor;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? Colors.white;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.vibrantPink.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.vibrantPink, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 13, color: (textColor ?? Colors.white).withOpacity(0.6))),
                ],
              ),
            ),
            if (trailing != null) trailing! else if (onTap != null)
              Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary.withOpacity(0.4), size: 24),
          ],
        ),
      ),
    );
  }
}
