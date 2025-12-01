import 'package:bomb_busters/app_button.dart';
import 'package:bomb_busters/input_field.dart';
import 'package:bomb_busters/models/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bomb_busters/routes/routes.dart';
import 'package:bomb_busters/providers.dart';
import 'dart:math';

class CreateScreen extends ConsumerStatefulWidget {
  const CreateScreen({super.key});


  @override
  ConsumerState<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends ConsumerState<CreateScreen> {
  final TextEditingController nameController = TextEditingController();
  final _secureRandom = Random.secure();

  @override
  void dispose() {
    nameController.dispose();
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
            AppButton(
              text: "SPIEL ERSTELLEN",
              onPressed: () async {
                final String name = nameController.text;
                final String gameId = _generateGameId();

                await ref.read(createGameProvider(Game(
                  gameId: gameId,
                  players: [name],
                  isActive: false,
                  cards: [],
                  admin: name,
                  captain: name,
                )).future);

                if (mounted) {
                  context.goNamed(
                    AppRoute.lobby.name,
                    extra: {
                      'isAdmin': true,
                      'gameId': gameId,
                      'name': name,
                    },
                  );
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

  String _generateGameId({int length = 6}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
      length,
      (_) => chars[_secureRandom.nextInt(chars.length)],
    ).join();
  }

}
