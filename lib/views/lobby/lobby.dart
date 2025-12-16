import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    Level("Level 1", 6, 0, 0, 0, 0),
    Level("Level 2", 8, 0, 2, 0, 2),
    Level("Level 3", 10, 1, 0, 1, 0),
    Level("Level 4", 12, 1, 2, 1, 2),
    Level("Level 5", 12, 1, 3, 1, 2),
    Level("Level 6", 12, 1, 4, 1, 4),
    Level("Level 7", 12, 2, 0, 1, 0),
    Level("Level 8", 12, 2, 3, 1, 2),
    Level("Level 9", 12, 1, 2, 1, 2),
    Level("Level 10", 12, 1, 4, 1, 4),
    Level ("Level 11", 12, 0, 2, 0, 2),
    Level("Level 12", 12, 1, 4, 1, 4),
    Level("Level 13", 12, 3, 0, 3, 0)
  ];

  final bool isAdmin;
  final String gameId;
  final String name;

  LobbyScreen({
    super.key,
    required this.isAdmin,
    required this.gameId,
    required this.name,
  });

  @override
  ConsumerState<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends ConsumerState<LobbyScreen> {
  late Level _activeLevel;

  @override
  void initState() {
    super.initState();
    _activeLevel = widget._levels[0];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double buttonHeight = size.height * 0.045;
    final double spacingHeight = size.height * 0.01;
    final double componentHeight = size.width * 0.08;
    final double teamHeight = size.height * 0.2;
    final double width = size.width * 0.7;

    final gameAsync = ref.watch(getStreamGameProvider(widget.gameId));

    ref.listen<AsyncValue<Game>>(getStreamGameProvider(widget.gameId), (_, next) {
      if (!widget.isAdmin) {
        next.whenData((game) {
          if (game.isActive && mounted) {
            context.goNamed(
              AppRoute.showCards.name,
              extra: {
                'gameId': widget.gameId,
                'name': widget.name,
              },
            );
          }
        });
      }
    });

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.15, vertical: size.height * 0.03),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextDisplay(text: "SPIELCODE"),
          CodeDisplay(width: width, height: componentHeight, gameId: widget.gameId),

          if (widget.isAdmin) ...[
            TextDisplay(text: "LEVEL"),
            LevelDropdown(
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
          ],

          TextDisplay(text: "TEAM"),
          TeamDisplay(width: width, height: teamHeight, isAdmin: widget.isAdmin, gameId: widget.gameId),
          SizedBox(height: spacingHeight),

          if (widget.isAdmin)
            AppButton(
              text: "SPIEL STARTEN",
              onPressed: () {
                ref.read(postCardsProvider({
                  'gameId': widget.gameId,
                  'players': gameAsync.value?.players ?? [],
                  'level': _activeLevel,
                }));

                context.goNamed(
                  AppRoute.lobby.name,
                  extra: {
                    'name': widget.name,
                    'gameId': widget.gameId,
                  },
                );
              },
              width: width,
              height: buttonHeight,
            ),

          if (!widget.isAdmin)
            gameAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.blue)),
              error: (err, stack) => Text('Error: $err'),
              data: (game) => const Center(child: CircularProgressIndicator(color: Colors.blue)),
            ),

          SizedBox(height: spacingHeight),

          AppButton(
            text: "HAUPTMENÜ",
            onPressed: () {
              ref.read(leaveGameProvider({
                'gameId': widget.gameId,
                'name': widget.name,
              }));
              context.goNamed(AppRoute.start.name);
            },
            width: width,
            height: buttonHeight,
          ),
        ],
      ),
    );
  }
}
