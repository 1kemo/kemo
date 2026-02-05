class DailyTip {
  final String title;
  final String content;
  final String emoji;
  final String category;

  const DailyTip({
    required this.title,
    required this.content,
    required this.emoji,
    required this.category,
  });

  static List<DailyTip> getAllTips() {
    return [
      const DailyTip(
        title: '情绪管理小技巧',
        content: '当感到焦虑时，试试"5-4-3-2-1"接地技巧：说出5样你能看到的东西，4样你能触摸的，3样你能听到的，2样你能闻到的，1样你能尝到的。',
        emoji: '🧘',
        category: '情绪管理',
      ),
      const DailyTip(
        title: '沟通的艺术',
        content: '在表达不满时，使用"我感到..."而不是"你总是..."。这样能减少对方的防御心理，让沟通更有效。',
        emoji: '💬',
        category: '沟通技巧',
      ),
      const DailyTip(
        title: '自我关爱',
        content: '每天给自己留出15分钟的"me time"，做一件让你快乐的小事，可以是喝杯茶、听首歌，或者只是发呆。',
        emoji: '💝',
        category: '自我关爱',
      ),
      const DailyTip(
        title: '识别PUA信号',
        content: '如果有人经常让你觉得"都是你的错"、"你不够好"，这可能是PUA的信号。记住：你值得被尊重和善待。',
        emoji: '🛡️',
        category: '反PUA',
      ),
      const DailyTip(
        title: '建立边界感',
        content: '学会说"不"是一种能力。你有权拒绝让你不舒服的要求，这不是自私，而是自我保护。',
        emoji: '🚧',
        category: '边界感',
      ),
      const DailyTip(
        title: '情绪日记',
        content: '每天记录3件让你开心的小事，即使很微小。这能帮助你培养积极心态，发现生活中的美好。',
        emoji: '📝',
        category: '情绪记录',
      ),
      const DailyTip(
        title: '深呼吸练习',
        content: '感到压力时，试试4-7-8呼吸法：吸气4秒，憋气7秒，呼气8秒。重复3-4次，能快速平复情绪。',
        emoji: '🌬️',
        category: '放松技巧',
      ),
      const DailyTip(
        title: '正念时刻',
        content: '吃饭时专注于食物的味道、质地和温度，这是最简单的正念练习，能帮你活在当下。',
        emoji: '🍽️',
        category: '正念练习',
      ),
    ];
  }

  static DailyTip getRandomTip() {
    final tips = getAllTips();
    final random = DateTime.now().day % tips.length;
    return tips[random];
  }
}
