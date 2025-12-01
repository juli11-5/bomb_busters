import 'package:flutter/material.dart';

class TextDisplay extends StatelessWidget {
  final String text;

  const TextDisplay({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double responsiveFontSize = screenWidth * 0.04;

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: responsiveFontSize,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 1.5,
              shadows: [
                Shadow(
                  offset: const Offset(2, 2),
                  blurRadius: 3,
                  color: Colors.black.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
