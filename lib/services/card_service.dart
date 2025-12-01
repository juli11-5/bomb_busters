import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:bomb_busters/models/card.dart';
import 'package:bomb_busters/models/level.dart';
import 'package:bomb_busters/services/game_service.dart';

class CardService {
  final String apiURL;
  final GameService gameService;

  CardService({required this.apiURL, required this.gameService});

  CardsResponse _parseCardResponse(String body) {
    final dynamic decoded = jsonDecode(body);
    if (decoded is List) {
      if (decoded.isEmpty) {
        return CardsResponse(gameId: '', name: '', cards: []);
      }
      return CardsResponse.fromJson(decoded.first);
    } else if (decoded is Map<String, dynamic>) {
      return CardsResponse.fromJson(decoded);
    }
    return CardsResponse(gameId: '', name: '', cards: []);
  }

  Future<void> postCards(String gameId, List<String> players, Level level) async {
    final List<CardData> bag = await _fillBag(level, gameId);
    final Map<String, List<CardData>> cardsByPlayer = _distributeCards(players, bag, level.takeRed, level.takeYellow);

    for (final player in players) {
      print(player);
      final CardsResponse body = CardsResponse(
        gameId: gameId,
        name: player,
        cards: cardsByPlayer[player]!,
      );

      final response = await http.post(
        Uri.parse(apiURL),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body.toJson()),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to post cards for $player');
      }
    }

    await gameService.makeGameActive(gameId, true);
  }

  Future<List<CardData>> getCards(String gameId, String name) async {
    final response = await http.get(
      Uri.parse('$apiURL?gameid=$gameId&name=$name'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final cardResponse = _parseCardResponse(response.body);
      return cardResponse.cards;
    }
    return [];
  }

  Future<void> deleteCards(String gameId) async {
    final getUri = Uri.parse('$apiURL?gameid=$gameId');
    final getResponse = await http.get(getUri);

    if (getResponse.statusCode != 200) {
      return;
    }

    final List<dynamic> cardsResponseJson = json.decode(getResponse.body);
    final List<CardsResponse> cardsToDelete = cardsResponseJson
        .map((jsonItem) => CardsResponse.fromJson(jsonItem as Map<String, dynamic>))
        .toList();

    final List<Future<void>> deleteFutures = [];

    for (final cardResponse in cardsToDelete) {
      final deleteUri = Uri.parse('$apiURL/${cardResponse.id}');
      deleteFutures.add(http.delete(deleteUri, headers: {'Content-Type': 'application/json'}).then((response) {
      }));
    }

    await Future.wait(deleteFutures);

    await gameService.makeGameActive(gameId, false);
  }

  Future<List<CardData>> _fillBag(Level level, String gameId) async {
    final List<double> redPool = List.generate(level.blue - 1, (i) => (i + 1) + 0.5)..shuffle();
    final List<double> yellowPool = List.generate(level.blue -1, (i) => (i + 1) + 0.1)..shuffle();

    final List<CardData> bag = [];

    for (int i = 1; i <= level.blue; i++) {
      for (int j = 0; j < 4; j++) {
        bag.add(CardData(i.toDouble(), CardColor.blue));
      }
    }

    final List<CardData> redCards = redPool.take(level.red).map((v) => CardData(v, CardColor.red)).toList();
    final List<CardData> yellowCards = yellowPool.take(level.yellow).map((v) => CardData(v, CardColor.yellow)).toList();

    bag.addAll(redCards);
    bag.addAll(yellowCards);

    await gameService.addYellowRed(yellowCards, redCards, gameId);

    bag.shuffle();
    return bag;
  }

  Map<String, List<CardData>> _distributeCards(List<String> players, List<CardData> bag, int takeRed, int takeYellow) {
    final result = { for (var p in players) p: <CardData>[] };
    int currentPlayer = 0;

    for (final card in bag) {
      final player = players[currentPlayer];

      if ((card.color == CardColor.red && takeRed > 0) ||
          (card.color == CardColor.yellow && takeYellow > 0) ||
          card.color == CardColor.blue) {

        result[player]!.add(card);
        currentPlayer = (currentPlayer + 1) % players.length;

        if (card.color == CardColor.red) takeRed--;
        if (card.color == CardColor.yellow) takeYellow--;
      }
    }
    return result;
  }
}
