import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  void dispose() {
    nameController.dispose();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double buttonHeight = size.height * 0.15;
    final double buttonWidth = size.width * 0.7;
    final double spacingHeight = size.height * 0.02;

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05, vertical: size.height * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: buttonWidth,
              child: InputField(
                controller: nameController,
                hint: "NAME ...",
              ),
            ),
            SizedBox(height: spacingHeight),
            SizedBox(
              width: buttonWidth,
              child: InputField(
                controller: codeController,
                hint: "SPIELCODE ...",
              ),
            ),
            SizedBox(height: spacingHeight),
            AppButton(
              text: "SPIEL BEITRETEN",
              onPressed: () async {
                final name = nameController.text.trim();
                final gameId = codeController.text.trim();

                // Validierung
                if (name.isEmpty) {
                  _showSnackBar(context, 'Bitte gib einen Namen ein!');
                  return;
                }

                if (gameId.isEmpty) {
                  _showSnackBar(context, 'Bitte gib eine Spiel-ID ein!');
                  return;
                }

                try {
                  await ref.read(joinGameProvider({
                    'gameId': gameId,
                    'name': name,
                  }).future);

                  if (!mounted) return;

                  context.goNamed(
                    AppRoute.lobby.name,
                    extra: {
                      'isAdmin': false,
                      'gameId': gameId,
                      'name': name,
                    },
                  );
                } catch (e) {
                  _showSnackBar(context, 'Spiel konnte nicht beigetreten werden!');
                }
              },
              width: buttonWidth,
              height: buttonHeight,
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        ),
      );
  }
}
