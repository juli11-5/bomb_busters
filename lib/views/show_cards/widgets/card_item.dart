import 'package:flutter/material.dart';
import 'package:bomb_busters/models/card.dart';

class _WavyPainter extends CustomPainter {
  final CardColor cardColor;

  _WavyPainter(this.cardColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = getColorForCard(cardColor)
      ..style = PaintingStyle.fill;

    Path path = Path();
    double w = size.width;
    double h = size.height;

    path.moveTo(w * 0.25, 0); 
    path.cubicTo(w * 0.75, h * 0.25, w * 0.25, h * 0.75, w * 0.75, h);

    path.lineTo(w * 0.85, h);
    path.cubicTo(w * 0.35, h * 0.75, w * 0.85, h * 0.25, w * 0.35, 0);
    
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavyPainter oldDelegate) {
    return oldDelegate.cardColor != cardColor;
  }
}

class CardItem extends StatelessWidget {
  final CardData data;

  const CardItem({
    super.key,
    required this.data
    });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double fontSize = width * 0.22;

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2A3E59),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.orange, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CustomPaint(
              painter: _WavyPainter(data.color),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Stack(
                    children: [ 
                      Text(
                        data.number.toString(),
                        style: TextStyle(
                          fontSize: fontSize,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = Colors.black,
                        ),
                      ),
                      Text(
                        data.number.toString(),
                        style: TextStyle(
                          fontSize: fontSize,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
