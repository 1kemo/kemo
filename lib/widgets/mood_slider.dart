import 'package:flutter/material.dart';
import '../models/mood.dart';
import '../utils/theme.dart';

class MoodSlider extends StatefulWidget {
  final double initialValue;
  final Function(double) onChanged;

  const MoodSlider({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<MoodSlider> createState() => _MoodSliderState();
}

class _MoodSliderState extends State<MoodSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  Color _getColorForValue(double value) {
    if (value < 0.33) {
      return const Color(0xFF6366F1); // 蓝紫色 (Emo)
    } else if (value < 0.66) {
      return AppTheme.electricPurple; // 紫色 (平静)
    } else {
      return AppTheme.vibrantPink; // 粉色 (Happy)
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentMood = Mood.fromValue(_currentValue);
    final currentColor = _getColorForValue(_currentValue);

    return Column(
      children: [
        Text(
          currentMood.emoji,
          style: const TextStyle(fontSize: 48),
        ),
        const SizedBox(height: 8),
        Text(
          currentMood.label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: currentColor,
          ),
        ),
        const SizedBox(height: 24),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 8,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
            activeTrackColor: currentColor,
            inactiveTrackColor: currentColor.withOpacity(0.2),
            thumbColor: currentColor,
            overlayColor: currentColor.withOpacity(0.2),
          ),
          child: Slider(
            value: _currentValue,
            onChanged: (value) {
              setState(() {
                _currentValue = value;
              });
              widget.onChanged(value);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: Mood.moods.map((mood) {
              final isActive = _currentValue >= mood.value - 0.1 &&
                  _currentValue <= mood.value + 0.1;
              return Opacity(
                opacity: isActive ? 1.0 : 0.3,
                child: Text(
                  mood.emoji,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
