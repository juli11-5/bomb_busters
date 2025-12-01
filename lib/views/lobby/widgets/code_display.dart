import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeDisplay extends StatelessWidget {
  final double width;
  final double height;
  final String gameId;

  const CodeDisplay({
    super.key,
    required this.width,
    required this.height,
    required this.gameId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: gameId));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Spielcode kopiert!'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFF7DBBE5),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.orange, width: 3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  gameId,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const FittedBox(
              fit: BoxFit.scaleDown,
              child: Icon(
                Icons.copy,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
