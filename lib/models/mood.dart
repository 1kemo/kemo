class Mood {
  final String label;
  final double value;
  final String emoji;

  const Mood({
    required this.label,
    required this.value,
    required this.emoji,
  });

  static const List<Mood> moods = [
    Mood(label: 'Emo', value: 0.0, emoji: '😢'),
    Mood(label: '低落', value: 0.25, emoji: '😔'),
    Mood(label: '平静', value: 0.5, emoji: '😐'),
    Mood(label: '愉悦', value: 0.75, emoji: '😊'),
    Mood(label: 'Happy', value: 1.0, emoji: '😄'),
  ];

  static Mood fromValue(double value) {
    if (value <= 0.125) return moods[0];
    if (value <= 0.375) return moods[1];
    if (value <= 0.625) return moods[2];
    if (value <= 0.875) return moods[3];
    return moods[4];
  }
}

class MoodRecord {
  final DateTime timestamp;
  final double moodValue;
  final String note;

  MoodRecord({
    required this.timestamp,
    required this.moodValue,
    this.note = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'moodValue': moodValue,
      'note': note,
    };
  }

  factory MoodRecord.fromJson(Map<String, dynamic> json) {
    return MoodRecord(
      timestamp: DateTime.parse(json['timestamp']),
      moodValue: json['moodValue'],
      note: json['note'] ?? '',
    );
  }
}
