import 'package:flutter/material.dart';

class AppTheme {
  // 主色调 - 更鲜艳的渐变色
  static const Color electricPurple = Color(0xFF8B5CF6); // 更亮的紫色
  static const Color vibrantPink = Color(0xFFEC4899);
  static const Color skyBlue = Color(0xFF3B82F6); // 天空蓝
  static const Color sunsetOrange = Color(0xFFF59E0B); // 日落橙
  
  // 背景色 - 柔和的渐变
  static const Color lightBackground = Color(0xFFFAFAFC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // 文字颜色 - 超高对比度
  static const Color textPrimary = Color(0xFF000000); // 纯黑色
  static const Color textSecondary = Color(0xFF475569); // 更深的石板灰
  
  // 保留旧颜色以兼容
  static const Color deepMidnight = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFFFAFAFC);
  
  // 渐变色组合
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
  );
  
  static const LinearGradient blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
  );
  
  static const LinearGradient orangeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFEC4899)],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFDF4FF), // 淡紫色
      Color(0xFFFFF1F2), // 淡粉色
      Color(0xFFF0F9FF), // 淡蓝色
    ],
  );

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      primaryColor: electricPurple,
      colorScheme: const ColorScheme.light(
        primary: electricPurple,
        secondary: vibrantPink,
        surface: cardBackground,
        background: lightBackground,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w900,
          color: textPrimary,
          letterSpacing: -0.5,
          height: 1.2,
        ),
        headlineMedium: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w900,
          color: textPrimary,
          height: 1.3,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          height: 1.4,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textSecondary,
          height: 1.4,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimary, size: 24),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // 保留深色主题以备后用
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Color(0xFF0F172A),
      primaryColor: electricPurple,
      colorScheme: const ColorScheme.dark(
        primary: electricPurple,
        secondary: vibrantPink,
        surface: Color(0xFF0F172A),
        background: Color(0xFF020617),
      ),
    );
  }
}
