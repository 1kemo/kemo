import 'package:flutter/material.dart';

enum PersonalityType {
  toxic,
  sweet,
  rational,
}

class AIPersonality {
  final PersonalityType type;
  final String name;
  final String description;
  final Color primaryColor;
  final Color secondaryColor;
  final IconData icon;
  final List<String> traits;

  const AIPersonality({
    required this.type,
    required this.name,
    required this.description,
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
    required this.traits,
  });

  static const List<AIPersonality> personalities = [
    AIPersonality(
      type: PersonalityType.toxic,
      name: '毒舌教主',
      description: '言辞犀利，负责骂醒你',
      primaryColor: Color(0xFFEC4899),
      secondaryColor: Color(0xFF1F1F1F),
      icon: Icons.flash_on,
      traits: ['直言不讳', '一针见血', '现实主义'],
    ),
    AIPersonality(
      type: PersonalityType.sweet,
      name: '甜系奶狗',
      description: '极致的情绪价值提供',
      primaryColor: Color(0xFFD8B4FE),
      secondaryColor: Color(0xFFFBCFE8),
      icon: Icons.favorite,
      traits: ['温柔体贴', '情绪陪伴', '正能量'],
    ),
    AIPersonality(
      type: PersonalityType.rational,
      name: '理性机器',
      description: '纯逻辑分析错误',
      primaryColor: Color(0xFFC0C0C0),
      secondaryColor: Color(0xFFA855F7),
      icon: Icons.psychology,
      traits: ['逻辑清晰', '客观分析', '理性思考'],
    ),
  ];

  static AIPersonality getByType(PersonalityType type) {
    return personalities.firstWhere((p) => p.type == type);
  }
}
