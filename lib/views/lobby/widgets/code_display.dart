import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodeDisplay extends StatelessWidget {
  const CodeDisplay({
    required this.width,
    required this.height,
    required this.gameId,
  });

  final double width;
  final double height;
  final String gameId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: gameId));
        final snackBar = const SnackBar(
          content: Text('Spielcode kopiert!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFF7DBBE5),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.orange, width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    gameId,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const FittedBox(
                child: Icon(
                  Icons.copy,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
