import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../widgets/mood_slider.dart';
import '../widgets/floating_bubble.dart';
import '../services/storage_service.dart';
import '../services/ai_service.dart';
import '../models/mood.dart';
import '../models/daily_tip.dart';
import '../models/chat_message.dart';
import '../utils/theme.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigate;
  
  const HomeScreen({super.key, this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storage = StorageService();
  double _currentMoodValue = 0.5;
  String _dailyQuote = '';
  DailyTip? _dailyTip;
  List<ChatMessage> _recentChats = [];
  int _streakDays = 0;
  double _todayMoodAverage = 0.5;
  bool _showMoodSlider = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadDailyQuote();
    await _loadDailyTip();
    await _loadRecentChats();
    await _loadStats();
  }

  Future<void> _loadDailyQuote() async {
    String? savedQuote = await _storage.getDailyQuote();
    if (savedQuote == null) {
      savedQuote = AIService.generateDailyQuote();
      await _storage.saveDailyQuote(savedQuote);
    }
    if (mounted) {
      setState(() {
        _dailyQuote = savedQuote!;
      });
    }
  }

  Future<void> _loadDailyTip() async {
    setState(() {
      _dailyTip = DailyTip.getRandomTip();
    });
  }

  Future<void> _loadRecentChats() async {
    final chats = await _storage.getRecentChats(limit: 3);
    if (mounted) {
      setState(() {
        _recentChats = chats;
      });
    }
  }

  Future<void> _loadStats() async {
    final streak = await _storage.getStreakDays();
    final todayAvg = await _storage.getTodayMoodAverage();
    if (mounted) {
      setState(() {
        _streakDays = streak;
        _todayMoodAverage = todayAvg;
      });
    }
  }

  Future<void> _saveMood() async {
    final record = MoodRecord(
      timestamp: DateTime.now(),
      moodValue: _currentMoodValue,
    );
    await _storage.saveMoodRecord(record);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('心情已记录 💕'),
          backgroundColor: AppTheme.electricPurple,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      setState(() {
        _showMoodSlider = false;
      });
      _loadStats();
    }
  }

  Future<void> _quickSaveMood(double moodValue) async {
    final record = MoodRecord(
      timestamp: DateTime.now(),
      moodValue: moodValue,
    );
    await _storage.saveMoodRecord(record);
    
    if (mounted) {
      final mood = Mood.fromValue(moodValue);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('已记录心情：${mood.label} ${mood.emoji}'),
          backgroundColor: AppTheme.vibrantPink,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      _loadStats();
    }
  }

  Future<void> _refreshDailyQuote() async {
    await _storage.clearDailyQuote();
    await _loadDailyQuote();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('已换一句新共鸣 ✨'),
          backgroundColor: AppTheme.vibrantPink,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _openAIChat([String? presetText]) {
    widget.onNavigate?.call(2);
    // 若有预设文案，可在此通过某种方式传给 ChatScreen（如全局/路由参数），此处仅跳转
  }

  void _showBoundaryPhrase() {
    const phrases = [
      '「我现在不方便，下次再说吧。」',
      '「这件事我做不到，抱歉。」',
      '「我不喜欢这样，请停止。」',
      '「这是我的底线，没法退让。」',
      '「我需要一点时间考虑，稍后回复你。」',
    ];
    final i = DateTime.now().millisecond % phrases.length;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.deepMidnight,
        title: Row(
          children: [
            Icon(Icons.shield_outlined, color: AppTheme.vibrantPink, size: 28),
            const SizedBox(width: 12),
            const Text('边界话术', style: TextStyle(color: AppTheme.textPrimary, fontSize: 20)),
          ],
        ),
        content: Text(
          phrases[i],
          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('再换一句', style: TextStyle(color: AppTheme.vibrantPink)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  static const _dailyQuestions = [
    {'q': '今天有好好照顾自己的情绪吗？', 'a': '无论多忙，都值得留一点时间给自己。'},
    {'q': '有什么事让你想说「谢谢」？', 'a': '感恩小事，会让心态更平和。'},
    {'q': '如果只能做一件让自己开心的事，你会选什么？', 'a': '选好了就去做，哪怕只有五分钟。'},
    {'q': '最近有没有一段关系让你感到疲惫？', 'a': '健康的边界不是自私，是自爱。'},
    {'q': '你允许自己「不够好」吗？', 'a': '允许自己慢慢来，也是一种勇气。'},
  ];

  void _showDailyQuestion() {
    final i = DateTime.now().day % _dailyQuestions.length;
    final item = _dailyQuestions[i];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.deepMidnight,
        title: const Text('每日一问', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['q']!,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.vibrantPink.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.vibrantPink.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: AppTheme.vibrantPink, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item['a']!,
                      style: TextStyle(color: AppTheme.textSecondary.withOpacity(0.95), fontSize: 14, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('明天再问', style: TextStyle(color: AppTheme.vibrantPink)),
          ),
        ],
      ),
    );
  }

  void _showTipDetail() {
    if (_dailyTip == null) return;
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _dailyTip!.emoji,
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 16),
              Text(
                _dailyTip!.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _dailyTip!.category,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _dailyTip!.content,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.electricPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('知道了', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部标题和统计
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '心动信号',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'PulseMind AI',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.textSecondary.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  if (_streakDays > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            '🔥',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '$_streakDays天',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),

              // 快速情绪记录
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '快速记录心情',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: Mood.moods.map((mood) {
                        return GestureDetector(
                          onTap: () => _quickSaveMood(mood.value),
                          child: Column(
                            children: [
                              Text(
                                mood.emoji,
                                style: const TextStyle(fontSize: 32),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                mood.label,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 每日小贴士
              if (_dailyTip != null)
                GestureDetector(
                  onTap: _showTipDetail,
                  child: GlassCard(
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              _dailyTip!.emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _dailyTip!.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '点击查看详情',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppTheme.textSecondary.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // 今日共鸣
              GlassCard(
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '今日共鸣',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _dailyQuote,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 最近对话
              if (_recentChats.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '最近对话',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => widget.onNavigate?.call(2),
                      child: const Text('查看全部'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ..._recentChats.map((chat) {
                  return GlassCard(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          chat.sender == MessageSender.user
                              ? Icons.person
                              : Icons.smart_toy,
                          color: chat.sender == MessageSender.user
                              ? AppTheme.vibrantPink
                              : AppTheme.electricPurple,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            chat.content,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),
              ],

              // 功能气泡区域
              const Text(
                '探索功能',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  FloatingBubble(
                    label: '深夜树洞',
                    icon: Icons.nightlight_round,
                    onTap: () => widget.onNavigate?.call(2),
                  ),
                  FloatingBubble(
                    label: '恋爱练习',
                    icon: Icons.favorite,
                    onTap: () => widget.onNavigate?.call(1),
                  ),
                  FloatingBubble(
                    label: '反PUA训练',
                    icon: Icons.shield,
                    onTap: () => widget.onNavigate?.call(1),
                  ),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
