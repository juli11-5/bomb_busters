import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart%20';
import 'package:go_router/go_router.dart';
import 'package:bomb_busters/routes/routes.dart';
import 'package:bomb_busters/app_button.dart';
import 'package:bomb_busters/input_field.dart';
import 'package:bomb_busters/providers.dart';

class JoinScreen extends ConsumerStatefulWidget {
  const JoinScreen({super.key});

  @override
  ConsumerState<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends ConsumerState<JoinScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double buttonHeight = size.height * 0.15;
    final double buttonWidth = size.width * 0.7;
    final double spacingHeight = size.height * 0.02;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: size.height * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: buttonWidth,
            child: InputField(
            controller: nameController,
              hint: "NAME ...",
            ),
          ),
          SizedBox(height: spacingHeight),

          Container(
            width: buttonWidth,
            child: InputField(
              controller: codeController,
              hint: "SPIELCODE ...",
            ),
          ),
          SizedBox(height: spacingHeight),

          AppButton(
            text: "SPIEL BEITRETEN",
            onPressed: () {
              context.goNamed(AppRoute.lobby.name, extra: false, queryParameters: {'name': nameController.text, 'gameId': codeController.text});
              ref.read(joinGameProvider((codeController.text, nameController.text)));
            },
            width: buttonWidth,
            height: buttonHeight,
          ),
        ],
      ),
    );
  }
}
