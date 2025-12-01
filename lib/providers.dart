import 'package:bomb_busters/models/card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import 'package:bomb_busters/services/game_service.dart';
import 'package:bomb_busters/models/game.dart';
import 'package:bomb_busters/services/card_service.dart';
import 'package:bomb_busters/models/level.dart';

final gameProvider = Provider<GameService>((ref) {
  return GameService(apiURL:"https://retoolapi.dev/pKIR1i/game");
});

final createGameProvider = FutureProvider.family<void, Game>((ref, game) {
  final gameService = ref.watch(gameProvider);
  return gameService.createGame(game);
});

final joinGameProvider = FutureProvider.family<void, (String, String)>((ref, data) {
  final gameService = ref.watch(gameProvider);
  return gameService.joinGame(data.$1, data.$2);
});

final getGameProvider = FutureProvider.family<Game, String>((ref, gameId) {
  final gameService = ref.watch(gameProvider);
  return gameService.getGame(gameId);
});

final setAdminProvider = FutureProvider.family<void, (String, String)>((ref, data) {
  final gameService = ref.watch(gameProvider);
  return gameService.setCaptain(data.$1, data.$2);
});


final getStreamGameProvider = StreamProvider.autoDispose.family<Game, String>((ref, gameId) async* {
  const pollingInterval = Duration(seconds: 3); 
  final gameService = ref.watch(gameProvider);
  yield await gameService.getGame(gameId);
  await for (final _ in Stream.periodic(pollingInterval)) {
    yield await gameService.getGame(gameId);
  }
});

final cardProvider = Provider<CardService>((ref) {
  final gameService = ref.watch(gameProvider);
  return CardService(apiURL: "https://retoolapi.dev/8ZAg73/card", gameService: gameService);
});

final postCardsProvider = FutureProvider.family<void, (String, List<String>, Level)>((ref, data) async {
  final cardService = ref.watch(cardProvider);
  return cardService.postCards(data.$1, data.$2, data.$3);
});

final getCardsProvider = FutureProvider.family<List<CardData>, (String, String)>((ref, data) async {
  final cardService = ref.watch(cardProvider);
  return cardService.getCards(data.$1, data.$2);
});

final deleteCardsProvider = FutureProvider.family<void, String>((ref, gameId) async {
  final cardService = ref.watch(cardProvider);
  return cardService.deleteCards(gameId);
});
