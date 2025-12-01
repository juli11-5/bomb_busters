import 'package:bomb_busters/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:bomb_busters/routes/routes.dart';
import 'package:bomb_busters/app_button.dart';
import 'package:bomb_busters/views/show_cards/widgets/card_grid.dart';
import 'package:bomb_busters/views/show_cards/widgets/card_info.dart';
import 'package:bomb_busters/models/game.dart';

class ShowCardsScreen extends ConsumerStatefulWidget {

  final String gameId;
  final String name;

  const ShowCardsScreen({super.key, required this.gameId, required this.name});
  @override
  ConsumerState<ShowCardsScreen> createState() => _ShowCardsScreenState();
}

class _ShowCardsScreenState extends ConsumerState<ShowCardsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double buttonHeight = size.height * 0.05;
    final double buttonWidth = size.width * 0.7;
    final double spacingHeight = size.height * 0.03;
    final double verticalPadding = size.height * 0.03;
    final double horizontalPadding = size.width * 0.05;
    final double gridHeight = size.height * 0.35;
    final double width = size.width - 2 * horizontalPadding;
    final double infoHeight = size.height * 0.05;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          CardInfo(height:infoHeight, width:width, gameId: widget.gameId),

          SizedBox(height: spacingHeight),

          CardGrid(height: gridHeight, width: width, gameId: widget.gameId, name: widget.name),

          SizedBox(height: spacingHeight),

          AppButton(
            text: "ZURÜCK ZUR LOBBY",
            onPressed: () async{
              final gameAsyncValue = await ref.read(getGameProvider(widget.gameId).future);
              ref.watch(deleteCardsProvider(widget.gameId));
              final bool isAdmin = _isAdmin(gameAsyncValue);
              context.goNamed(AppRoute.lobby.name, extra:isAdmin, queryParameters: {'name': widget.name, 'gameId': widget.gameId});
            },
            height: buttonHeight,
            width: buttonWidth,
          ),
        ],
      ),
    );
  }

  bool _isAdmin(Game? game) {
    if (game == null) {
      return false;
    }
    return game.admin == widget.name;
  }
}
