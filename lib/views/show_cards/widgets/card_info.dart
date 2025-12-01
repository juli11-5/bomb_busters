import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart ';
import 'package:bomb_busters/models/card.dart';
import 'package:bomb_busters/views/show_cards/widgets/card_item.dart';
import 'package:bomb_busters/providers.dart';
import 'package:bomb_busters/models/game.dart';


class CardInfo extends ConsumerWidget {
  final double width;
  final double height;
  final String gameId;

  CardInfo({Key? key, required this.width, required this.height, required this.gameId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Game? game = ref.watch(getStreamGameProvider(gameId)).value;
    if (game == null) {
      return Container();
    }
    List<CardData> cardList = game.cards;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF7DBBE5),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.orange, width: 3),
      ),
      padding: const EdgeInsets.all(1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: cardList
            .map((data) => Expanded(
                child: CardItem(data: data),
              ))
            .toList(),
      ),
    );
  }
}