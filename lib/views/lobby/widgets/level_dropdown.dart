import 'package:flutter/material.dart';
import 'package:bomb_busters/models/level.dart';

class LevelDropdown extends StatelessWidget {
  final List<Level> levels;
  final Level initialLevel;
  final void Function(Level) onChanged;
  final double height;
  final double width;

  const LevelDropdown({
    super.key,
    required this.levels,
    required this.initialLevel,
    required this.onChanged,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF7CB9E8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE88E5D), width: 3),
      ),
      child: Center(
        child: DropdownButton<Level>(
          isExpanded: true,
          value: initialLevel,
          underline: const SizedBox(),
          items: levels.map((level) {
            return DropdownMenuItem(
              value: level,
              child: Text(
                level.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            );
          }).toList(),
          onChanged: (Level? level) {
            if (level != null) {
              onChanged(level);
            }
          },
        ),
      ),
    );
  }
}
