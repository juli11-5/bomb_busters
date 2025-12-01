import 'package:flutter/material.dart';

enum CardColor { yellow, red, blue }

class CardData {
  final double number;
  final CardColor color;

  CardData(this.number, this.color);

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'color': color.name,
    };
  }

  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      (json['number'] as num).toDouble(),
      CardColor.values.firstWhere(
        (e) => e.name == json['color'],
        orElse: () => CardColor.yellow,
      ),
    );
  }

}

Color getColorForCard(CardColor color) {
   switch (color) {
     case CardColor.yellow:
      return const Color(0xFFFACC4A);
    case CardColor.red:
      return const Color(0xFFC7433B);
    case CardColor.blue:
      return const Color(0xFF4A88B0); 
    }
}

class CardsResponse {
  final String gameId;
  final String name;
  final List<CardData> cards;
  final int? id;

  CardsResponse({
    required this.gameId,
    required this.name,
    required this.cards,
    this.id,
  });

  factory CardsResponse.fromJson(Map<String, dynamic> json) {
    return CardsResponse(
      id: json['id'],
      gameId: json['gameId'],
      name: json['name'],
      cards: (json['cards'] as List)
          .map((c) => CardData.fromJson(c))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "gameId": gameId,
      "name": name,
      "cards": cards.map((c) => c.toJson()).toList(),
    };
  }
}
