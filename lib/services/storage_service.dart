import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mood.dart';
import '../models/chat_message.dart';
import '../models/ai_personality.dart';

class StorageService {
  static const String _moodRecordsKey = 'mood_records';
  static const String _chatHistoryKey = 'chat_history';
  static const String _selectedPersonalityKey = 'selected_personality';
  static const String _dailyQuoteKey = 'daily_quote';
  static const String _lastQuoteDateKey = 'last_quote_date';
  static const String _notificationEnabledKey = 'notification_enabled';
  static const String _isLoggedInKey = 'is_logged_in';

  Future<void> saveMoodRecord(MoodRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = await getMoodRecords();
    records.add(record);
    
    final jsonList = records.map((r) => r.toJson()).toList();
    await prefs.setString(_moodRecordsKey, jsonEncode(jsonList));
  }

  Future<List<MoodRecord>> getMoodRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_moodRecordsKey);
    
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => MoodRecord.fromJson(json)).toList();
  }

  Future<List<MoodRecord>> getWeeklyMoodRecords() async {
    final records = await getMoodRecords();
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return records.where((r) => r.timestamp.isAfter(weekAgo)).toList();
  }

  Future<void> saveChatMessage(ChatMessage message) async {
    final prefs = await SharedPreferences.getInstance();
    final messages = await getChatHistory();
    messages.add(message);
    
    // 只保留最近100条消息
    if (messages.length > 100) {
      messages.removeRange(0, messages.length - 100);
    }
    
    final jsonList = messages.map((m) => m.toJson()).toList();
    await prefs.setString(_chatHistoryKey, jsonEncode(jsonList));
  }

  Future<List<ChatMessage>> getChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_chatHistoryKey);
    
    if (jsonString == null) return [];
    
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => ChatMessage.fromJson(json)).toList();
  }

  Future<void> clearChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chatHistoryKey);
  }

  Future<void> saveSelectedPersonality(PersonalityType type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedPersonalityKey, type.toString());
  }

  Future<PersonalityType> getSelectedPersonality() async {
    final prefs = await SharedPreferences.getInstance();
    final typeString = prefs.getString(_selectedPersonalityKey);
    
    if (typeString == null) return PersonalityType.sweet;
    
    return PersonalityType.values.firstWhere(
      (e) => e.toString() == typeString,
      orElse: () => PersonalityType.sweet,
    );
  }

  Future<void> saveDailyQuote(String quote) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dailyQuoteKey, quote);
    await prefs.setString(_lastQuoteDateKey, DateTime.now().toIso8601String());
  }

  Future<String?> getDailyQuote() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDateString = prefs.getString(_lastQuoteDateKey);
    
    if (lastDateString != null) {
      final lastDate = DateTime.parse(lastDateString);
      final now = DateTime.now();
      
      // 如果是同一天，返回保存的quote
      if (lastDate.year == now.year &&
          lastDate.month == now.month &&
          lastDate.day == now.day) {
        return prefs.getString(_dailyQuoteKey);
      }
    }
    
    return null;
  }

  Future<List<ChatMessage>> getRecentChats({int limit = 5}) async {
    final messages = await getChatHistory();
    if (messages.isEmpty) return [];
    
    // 返回最近的几条消息
    final startIndex = messages.length > limit ? messages.length - limit : 0;
    return messages.sublist(startIndex);
  }

  Future<double> getTodayMoodAverage() async {
    final records = await getMoodRecords();
    final today = DateTime.now();
    
    final todayRecords = records.where((r) {
      return r.timestamp.year == today.year &&
          r.timestamp.month == today.month &&
          r.timestamp.day == today.day;
    }).toList();
    
    if (todayRecords.isEmpty) return 0.5;
    
    double sum = 0;
    for (var record in todayRecords) {
      sum += record.moodValue;
    }
    return sum / todayRecords.length;
  }

  Future<bool> getNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationEnabledKey) ?? true;
  }

  Future<void> setNotificationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationEnabledKey, enabled);
  }

  Future<void> clearMoodRecords() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_moodRecordsKey);
  }

  Future<void> clearDailyQuote() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dailyQuoteKey);
    await prefs.remove(_lastQuoteDateKey);
  }

  Future<int> getStreakDays() async {
    final records = await getMoodRecords();
    if (records.isEmpty) return 0;
    
    // 按日期排序
    records.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    int streak = 0;
    DateTime? lastDate;
    
    for (var record in records) {
      final recordDate = DateTime(
        record.timestamp.year,
        record.timestamp.month,
        record.timestamp.day,
      );
      
      if (lastDate == null) {
        lastDate = recordDate;
        streak = 1;
      } else {
        final difference = lastDate.difference(recordDate).inDays;
        if (difference == 1) {
          streak++;
          lastDate = recordDate;
        } else if (difference > 1) {
          break;
        }
      }
    }
    
    return streak;
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> setLoginStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, status);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
  }
}
