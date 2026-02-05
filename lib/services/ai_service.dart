import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/ai_personality.dart';

class AIService {
  static const String _apiUrl = 'https://api.deepseek.com/chat/completions';
  static const String _model = 'deepseek-chat';
  static final Random _random = Random();

  /// 根据人格类型生成 system prompt
  static String _systemPromptFor(PersonalityType personality) {
    switch (personality) {
      case PersonalityType.toxic:
        return '你是一个毒舌教主，言辞犀利，负责骂醒用户。直言不讳、一针见血、现实主义。用简短有力的回复，不要啰嗦。';
      case PersonalityType.sweet:
        return '你是一个甜系奶狗，极致的情绪价值提供者。温柔体贴、情绪陪伴、正能量。用温暖、鼓励、共情的语气回复。';
      case PersonalityType.rational:
        return '你是一个理性机器，纯逻辑分析。逻辑清晰、客观分析、理性思考。用条理分明、客观中立的语气回复。';
    }
  }

  /// 调用 DeepSeek API 生成回复（异步）
  static Future<String> generateResponse(
    String userMessage,
    PersonalityType personality,
  ) async {
    final apiKey = deepSeekApiKey;
    if (apiKey.isEmpty || apiKey == 'YOUR_DEEPSEEK_API_KEY') {
      return _fallbackResponse(userMessage, personality);
    }

    try {
      final body = {
        'model': _model,
        'messages': [
          {'role': 'system', 'content': _systemPromptFor(personality)},
          {'role': 'user', 'content': userMessage},
        ],
        'stream': false,
      };

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        return _fallbackResponse(userMessage, personality);
      }

      final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final choices = data['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) {
        return _fallbackResponse(userMessage, personality);
      }

      final first = choices.first as Map<String, dynamic>;
      final message = first['message'] as Map<String, dynamic>?;
      final content = message?['content'] as String?;
      if (content != null && content.isNotEmpty) {
        return content.trim();
      }

      return _fallbackResponse(userMessage, personality);
    } catch (_) {
      return _fallbackResponse(userMessage, personality);
    }
  }

  static String _fallbackResponse(String userMessage, PersonalityType personality) {
    switch (personality) {
      case PersonalityType.toxic:
        return _generateToxicResponse(userMessage);
      case PersonalityType.sweet:
        return _generateSweetResponse(userMessage);
      case PersonalityType.rational:
        return _generateRationalResponse(userMessage);
    }
  }

  static String _generateToxicResponse(String message) {
    final responses = [
      '醒醒吧，你这是在浪费时间。',
      '说实话，你这个想法挺幼稚的。',
      '别自欺欺人了，面对现实吧。',
      '你确定你真的想清楚了吗？我看未必。',
      '停止自我感动，该清醒了。',
      '这种事还需要问？你心里不是早有答案了吗。',
      '别再给自己找借口了，该断就断。',
    ];
    return responses[_random.nextInt(responses.length)];
  }

  static String _generateSweetResponse(String message) {
    final responses = [
      '我能理解你的感受，这确实不容易呢 💕',
      '你已经做得很好了，给自己一个拥抱吧～',
      '别担心，一切都会好起来的！我会一直陪着你 🌸',
      '你的感受是完全正常的，慢慢来就好～',
      '相信自己，你比想象中更强大！✨',
      '无论发生什么，记得你值得被爱 💖',
      '深呼吸，让我陪你一起面对好吗？',
    ];
    return responses[_random.nextInt(responses.length)];
  }

  static String _generateRationalResponse(String message) {
    final responses = [
      '让我们理性分析一下：首先需要明确你的真实需求。',
      '从逻辑角度看，这个问题的关键在于权衡利弊。',
      '建议你列出所有可能的选项，然后逐一评估。',
      '这种情况下，最优解是保持冷静并收集更多信息。',
      '根据你的描述，问题的核心是沟通方式需要调整。',
      '客观来说，你需要先确定自己的底线和原则。',
      '从长远角度考虑，现在的决定会带来什么影响？',
    ];
    return responses[_random.nextInt(responses.length)];
  }

  // 生成每日共鸣语句
  static String generateDailyQuote() {
    final quotes = [
      '今天的你，值得被温柔以待 ✨',
      '情绪是流动的，允许自己慢慢来',
      '你不需要完美，只需要真实',
      '每一次心动，都是成长的信号',
      '学会爱自己，是一生的修行',
      '你的感受，永远值得被看见',
      '勇敢表达，是对自己最好的尊重',
      '今天也要好好照顾自己的心情哦',
      '你比昨天的自己更懂得爱了',
      '温柔而坚定，是最好的状态',
    ];
    return quotes[_random.nextInt(quotes.length)];
  }

  // 生成修罗场回复方案
  static Map<String, String> generateScenarioResponses(String scenario) {
    return {
      '绿茶版': '哎呀～我也不太懂这些呢，你说了算啦 💕',
      '直球版': '不好意思，我不太认同你的观点。',
      '高情商版': '我理解你的想法，不过我们可以换个角度看看这个问题～',
    };
  }

  // 生成模拟对话
  static String generateSimulationResponse(String role, String userInput) {
    final responses = {
      '前任': [
        '我最近一直在想我们的事...',
        '你过得还好吗？我挺想你的。',
        '我觉得我们还是有机会的，你觉得呢？',
      ],
      '暗恋对象': [
        '今天天气不错，要不要一起出去走走？',
        '你最近在忙什么呀？',
        '我发现我们有好多共同点呢～',
      ],
      '刁钻上司': [
        '这个方案我不太满意，重新做一遍。',
        '你这个效率也太慢了吧？',
        '别人都能做好，为什么你不行？',
      ],
    };

    final roleResponses = responses[role] ?? ['嗯，我知道了。'];
    return roleResponses[_random.nextInt(roleResponses.length)];
  }
}
