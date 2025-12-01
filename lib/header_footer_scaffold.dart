import 'package:flutter/material.dart';

class HeaderFooterScaffold extends StatelessWidget {
  final Widget child;

  const HeaderFooterScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;
            final screenWidth = constraints.maxWidth;

            final double headerHeight = screenHeight * 0.15;
            final double footerHeight = screenHeight * 0.22;
            final double footerWidth = screenWidth * 0.95;

            return Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: const Color(0xFF2B4C88),
                  ),
                ),

                Positioned(
                  top: screenHeight * 0.05,
                  left: 10,
                  right: 10,
                  height: headerHeight,
                  child: Image.asset(
                    'assets/images/bomb_busters.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.topCenter,
                  ),
                ),

                Positioned(
                  bottom: 0,
                  width: footerWidth,
                  left: screenWidth * 0.025,
                  child: Image.asset(
                    'assets/images/bottom.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                  ),
                ),

                Positioned(
                  top: headerHeight,
                  bottom: footerHeight,
                  left: 0,
                  right: 0,
                  child: Center(child: child),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
