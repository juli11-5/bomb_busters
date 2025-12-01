import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bomb_busters/routes/routes.dart';
import 'package:bomb_busters/app_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double buttonHeight = size.height * 0.15;
    final double buttonWidth = size.width * 0.7;
    final double spacingHeight = size.height * 0.05;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: size.height * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppButton(
            text: "SPIEL ERSTELLEN",
            onPressed: () => context.goNamed(AppRoute.create.name),
            height: buttonHeight,
            width: buttonWidth,
          ),

          SizedBox(height: spacingHeight),

          AppButton(
            text: "SPIEL BEITRETEN",
            onPressed: () => context.goNamed(AppRoute.join.name),
            height: buttonHeight,
            width: buttonWidth,
          ),
        ],
      ),
    );
  }
}
