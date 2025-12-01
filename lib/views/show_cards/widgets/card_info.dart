import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bomb_busters/models/card.dart';
import 'package:bomb_busters/views/show_cards/widgets/card_item.dart';
import 'package:bomb_busters/providers.dart';

class CardInfo extends ConsumerWidget {
  final double width;
  final double height;
  final String gameId;

  const CardInfo({
    super.key,
    required this.width,
    required this.height,
    required this.gameId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameAsync = ref.watch(getStreamGameProvider(gameId));

    return gameAsync.when(
      data: (game) {
        final List<CardData> cardList = game.cards;

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
                .map((data) => Expanded(child: CardItem(data: data)))
                .toList(),
          ),
        );
      },
      loading: () => SizedBox(
        width: width,
        height: height,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => SizedBox(
        width: width,
        height: height,
        child: Center(child: Text('Error: $err')),
      ),
    );
  }
}
