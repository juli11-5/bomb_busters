import 'package:bomb_busters/app_button.dart';
import 'package:bomb_busters/input_field.dart';
import 'package:bomb_busters/models/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bomb_busters/routes/routes.dart';
import 'package:bomb_busters/providers.dart';

class CreateScreen extends ConsumerStatefulWidget {
  const CreateScreen({super.key});

  @override
  ConsumerState<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends ConsumerState<CreateScreen> {
  final TextEditingController nameController = TextEditingController();

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
          Column(
            children: [
              Container(
                width: buttonWidth,
                child: InputField(
                  controller: nameController,
                  hint: "NAME ...",
                ),
              ),
              SizedBox(height: spacingHeight),
              AppButton(
                text: "SPIEL ERSTELLEN",
                onPressed: () {
                  final String gameId = _generateGameId();
                  context.goNamed(AppRoute.lobby.name, extra: true, queryParameters: {'name': nameController.text, 'gameId': gameId});
                  ref.read(createGameProvider(Game(
                      gameId: gameId,
                      players: [nameController.text],
                      isActive: false,
                      cards: [],
                      admin: nameController.text,
                      captain: nameController.text
                  )));
                },
                width: buttonWidth,
                height: buttonHeight,
              ),
            ],
          ),
        ],
      ),
    );
  }
  String _generateGameId() {
    const length = 6;
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = DateTime.now().millisecondsSinceEpoch;
    String gameId = '';
    for (int i = 0; i < length; i++) {
      gameId += chars[(rand + i) % chars.length];
    }
    return gameId;
  }
}
