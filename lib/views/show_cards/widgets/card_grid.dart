import 'package:bomb_busters/views/show_cards/widgets/card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bomb_busters/providers.dart';

class CardGrid extends ConsumerWidget {

  final double height;
  final double width;
  final String gameId;
  final String name;

  CardGrid({super.key, required this.height, required this.width, required this.gameId, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardsAsyncValue = ref.watch(getCardsProvider((gameId, name)));

    return Container(
      width: width, 
      height: height,
      decoration: BoxDecoration(
          color: const Color(0xFF7DBBE5),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.orange, width: 3),
        ),
      padding: const EdgeInsets.all(5.0),
      child: cardsAsyncValue.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, stack) => Center(
          child: Text('Fehler: $err'),
        ),
        data: (cardList) {
          if (cardList.isEmpty) {
            return const Center(
              child: Text('Keine Karten gefunden.'),
            );
          }

          double aspectRatio = _calculateAspectRatio(cardList.length);
          
          return GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 15.0,
            mainAxisSpacing: 15.0,
            childAspectRatio: aspectRatio,
            physics: const NeverScrollableScrollPhysics(),
            children: cardList
                .map((data) => CardItem(data: data))
                .toList(),
          );
        },
      ),
    );
  }

  double _calculateAspectRatio(int length) {
    final int crossAxisCount = 4;
    final double crossAxisSpacing = 15.0;
    final double mainAxisSpacing = 15.0;
    final int cardCount = length;
            
    final double requiredRows = (cardCount / crossAxisCount).ceilToDouble(); 

    final double gridWidth = width;
    final double gridHeight = height;

    final double cardWidthAvailable = (gridWidth - (crossAxisSpacing * (crossAxisCount - 1))) / crossAxisCount;
    final double cardHeightAvailable = (gridHeight - (mainAxisSpacing * (requiredRows - 1))) / requiredRows - 5.0; 
            
    return cardWidthAvailable / cardHeightAvailable;
  }

}