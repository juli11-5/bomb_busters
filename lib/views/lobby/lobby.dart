import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart%20';
import 'package:go_router/go_router.dart';

import 'package:bomb_busters/views/lobby/widgets/team.dart';
import 'package:bomb_busters/app_button.dart';
import 'package:bomb_busters/views/lobby/widgets/code_display.dart';
import 'package:bomb_busters/views/lobby/widgets/text_display.dart';
import 'package:bomb_busters/views/lobby/widgets/level_dropdown.dart';
import 'package:bomb_busters/routes/routes.dart';
import 'package:bomb_busters/providers.dart';
import 'package:bomb_busters/models/level.dart';
import 'package:bomb_busters/models/game.dart';


class LobbyScreen extends ConsumerStatefulWidget {
  final List<Level> _levels = [
    Level("Level 1", 6, 0, 2, 0, 2),
    Level("Level 2", 12, 1, 2, 1, 2),
  ];

  final bool isAdmin;
  final String gameId;
  final String name;

  LobbyScreen({super.key, required this.isAdmin, required this.gameId, required this.name});

  @override
  ConsumerState<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends ConsumerState<LobbyScreen> {
  late Level _activeLevel = widget._levels[0];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double buttonHeight = size.height * 0.045;
    final double spacingHeight = size.height * 0.01;
    final double componentHeight = size.width * 0.08;
    final double teamHeight = size.height * 0.2;
    final double width = size.width * 0.7;

    final gameAsync = ref.watch(getStreamGameProvider(widget.gameId));

    ref.listen<AsyncValue<Game>>(getStreamGameProvider(widget.gameId), (previous, next) {
      if (!widget.isAdmin) {
        next.whenData((game) {
          if (game.isActive) {
            context.goNamed(
              AppRoute.show_cards.name,
              extra: (widget.gameId, widget.name),
            );
          }
        });
      }
    });

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.15, vertical: size.height * 0.03
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextDisplay("SPIELCODE"),
          CodeDisplay(width: width, height: componentHeight, gameId: widget.gameId,),

          Visibility(
            visible: widget.isAdmin,
            child: TextDisplay("LEVEL"),
          ),
          
          Visibility(
            visible: widget.isAdmin,
              child: LevelDropdown(
                levels: widget._levels,
                initialLevel: _activeLevel,
                onChanged: (level) {
                  setState(() {
                    _activeLevel = level;
                  });
                },
                height: componentHeight,
                width: width,
              ),
          ),

          TextDisplay("TEAM"),
          TeamDisplay(width: width, height: teamHeight, isAdmin: widget.isAdmin, gameId: widget.gameId),
          SizedBox(height: spacingHeight),

          Visibility(
            visible: widget.isAdmin,
            child: AppButton(
              text: "SPIEL STARTEN",
              onPressed: () {
                ref.read(postCardsProvider((widget.gameId, gameAsync.value!.players, _activeLevel)));
                context.goNamed(AppRoute.lobby.name, extra: false, queryParameters: {'name': widget.name, 'gameId': widget.gameId});
              },
              width: width,
              height: buttonHeight,
            ),
          ),

          Visibility(
            visible: !widget.isAdmin,
            child: gameAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              ),
              error: (err, stack) => Text('Error: $err'),
              data: (game) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                );
              },
            ),
          ),

          SizedBox(height: spacingHeight),

          AppButton(
            text: "HAUPTMENÜ",
            onPressed: () => context.goNamed(AppRoute.start.name),
            width: width,
            height: buttonHeight,
          ),
        ],
      ),
    );
  }
}