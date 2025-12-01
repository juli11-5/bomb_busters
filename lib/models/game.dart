import 'package:bomb_busters/models/card.dart';

class Game {
  final String gameId;
  final String admin;
  List<String> players;
  bool isActive;
  List<CardData> cards;
  final String captain;


  Game({
    required this.gameId,
    required this.admin,
    required this.players,
    this.isActive = false,
    required this.cards,
    required this.captain,
  });

  Map<String, dynamic> toJson() {
    return {
      'gameid': gameId,
      'admin': admin,
      'players': players,
      'isActive': isActive,
      'cards': cards.map((card) => card.toJson()).toList(),
      'captain': captain,
    };
  }

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      gameId: json['gameid'],
      admin: json['admin'],
      players: List<String>.from(json['players']),
      isActive: json['isActive'] ?? false,
      cards: (json['cards'] as List)
          .map((cardJson) => CardData.fromJson(cardJson))
          .toList(),
      captain: json['captain'],
    );
  }
}
