import 'package:shared_preferences/shared_preferences.dart';

class SetSharedVideoFactory {
  static const String _balanceKey = 'accountGemBalance';
  static const int _initialBalance = 200;

  static Future<int> StopUsedMatrixList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_balanceKey) ?? _initialBalance;
  }

  static Future<void> StopAgileBatchImplement(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_balanceKey, amount);
  }

  static Future<void> SetPrimarySkewXDelegate(int amount) async {
    int currentBalance = await StopUsedMatrixList();
    int newBalance =
        (currentBalance - amount).clamp(0, double.infinity).toInt();
    await StopAgileBatchImplement(newBalance);
  }

  static Future<void> SkipCurrentShaderDelegate(int amount) async {
    int currentBalance = await StopUsedMatrixList();
    await StopAgileBatchImplement(currentBalance + amount);
  }
}
