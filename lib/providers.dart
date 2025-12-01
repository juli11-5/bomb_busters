import 'package:bomb_busters/models/card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import 'package:bomb_busters/services/game_service.dart';
import 'package:bomb_busters/models/game.dart';
import 'package:bomb_busters/services/card_service.dart';
import 'package:bomb_busters/models/level.dart';

/// --- GameService Provider ---
final gameProvider = Provider<GameService>((ref) {
  return GameService(apiURL: "https://retoolapi.dev/pKIR1i/game");
});

/// --- Game Operations ---
final createGameProvider = FutureProvider.family<void, Game>((ref, game) {
  final gameService = ref.watch(gameProvider);
  return gameService.createGame(game);
});

final joinGameProvider = FutureProvider.family<void, Map<String, String>>((ref, data) {
  final gameService = ref.watch(gameProvider);
  final gameId = data['gameId'] ?? '';
  final playerName = data['name'] ?? '';
  return gameService.joinGame(gameId, playerName);
});

final getGameProvider = FutureProvider.family<Game, String>((ref, gameId) {
  final gameService = ref.watch(gameProvider);
  return gameService.getGame(gameId);
});

final setAdminProvider = FutureProvider.family<void, Map<String, String>>((ref, data) {
  final gameService = ref.watch(gameProvider);
  final gameId = data['gameId'] ?? '';
  final playerName = data['name'] ?? '';
  return gameService.setCaptain(gameId, playerName);
});

final getStreamGameProvider = StreamProvider.autoDispose.family<Game, String>((ref, gameId) async* {
  const pollingInterval = Duration(seconds: 3);
  final gameService = ref.watch(gameProvider);

  yield await gameService.getGame(gameId);
  await for (final _ in Stream.periodic(pollingInterval)) {
    yield await gameService.getGame(gameId);
  }
});

/// --- CardService Provider ---
final cardProvider = Provider<CardService>((ref) {
  final gameService = ref.watch(gameProvider);
  return CardService(apiURL: "https://retoolapi.dev/8ZAg73/card", gameService: gameService);
});

/// --- Card Operations ---
final postCardsProvider = FutureProvider.family<void, Map<String, dynamic>>((ref, data) async {
  final cardService = ref.watch(cardProvider);
  final gameId = data['gameId'] as String;
  final players = List<String>.from(data['players'] ?? []);
  final Level level = data['level'] as Level;
  return cardService.postCards(gameId, players, level);
});

final getCardsProvider = FutureProvider.family<List<CardData>, Map<String, String>>((ref, data) async {
  final cardService = ref.watch(cardProvider);
  final gameId = data['gameId'] ?? '';
  final playerName = data['name'] ?? '';
  return cardService.getCards(gameId, playerName);
});

final deleteCardsProvider = FutureProvider.family<void, String>((ref, gameId) async {
  final cardService = ref.watch(cardProvider);
  return cardService.deleteCards(gameId);
});
