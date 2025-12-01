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
        throw Exception('Card response not found');
      }
      return CardsResponse.fromJson(decoded.first); 
    } 
    else if (decoded is Map<String, dynamic>) {
      return CardsResponse.fromJson(decoded);
    } 
    
    throw Exception('Unexpected response format in CardService');
  }


  Future<void> postCards(String gameId, List<String> players, Level level) async {
    List<CardData> bag = await _fillBag(level, gameId);
    Map<String, List<CardData>> cardsByPlayer = _dragCards(players, bag, level.takeRed, level.takeYellow);
    
    for(int i = 0; i < players.length; i++){
      CardsResponse body = CardsResponse(
        gameId: gameId,
        name: players[i],
        cards: cardsByPlayer[players[i]]!
      );

      final response = await http.post(
        Uri.parse('$apiURL'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body.toJson()),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to post cards');
      }
    }

    gameService.makeGameActive(gameId, true);
  }

  Future<List<CardData>> getCards(String gameId, String name) async {
    final response = await http.get(
        Uri.parse('$apiURL?gameid=$gameId&name=$name'),
        headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final cardResponse = _parseCardResponse(response.body);
      return cardResponse.cards;
    } else {
      throw Exception("Failed to get card");
    }
  }

  Future<void> deleteCards(String gameId) async {
    final getUri = Uri.parse('$apiURL?gameid=$gameId');
    final getResponse = await http.get(getUri);

    if (getResponse.statusCode != 200) {
      throw Exception('Failed to fetch cards for deletion: ${getResponse.statusCode}');
    }

    final List<dynamic> cardsResponseJson = json.decode(getResponse.body);
    final List<CardsResponse> cardsToDelete = cardsResponseJson
        .map((jsonItem) => CardsResponse.fromJson(jsonItem as Map<String, dynamic>))
        .toList();

    final List<Future<http.Response>> deleteFutures = [];

    for (final cardResponse in cardsToDelete) {
      final deleteUri = Uri.parse('$apiURL/${cardResponse.id}');
      
      deleteFutures.add(
        http.delete(
          deleteUri,
          headers: {'Content-Type': 'application/json'},
        )
      );
    }

  final results = await Future.wait(deleteFutures);

  for (final response in results) {
    if (response.statusCode != 200 && response.statusCode != 204) {
      print('Warning: Failed to delete a card. Status: ${response.statusCode}');
    }
  }

  gameService.makeGameActive(gameId, false);
}


  Future<List<CardData>> _fillBag(Level level, String gameId) async {
      
    final List<double> redPool = List.generate(11, (i) => (i + 1) + 0.5);
    redPool.shuffle();

    final List<double> yellowPool = List.generate(11, (i) => (i + 1) + 0.1);
    yellowPool.shuffle();

    List<CardData> bag = [];

    for (int i = 1; i <= level.blue; i++) {
      for (int j = 0; j < 4; j++) {
        bag.add(CardData(i.toDouble(), CardColor.blue));
      }
    }

    List<CardData> redCards = redPool
        .take(level.red)
        .map((value) => CardData(value, CardColor.red))
        .toList();
    bag.addAll(redCards);

    List<CardData> yellowCards = yellowPool
        .take(level.yellow)
        .map((value) => CardData(value, CardColor.yellow))
        .toList();
    bag.addAll(yellowCards);

    await gameService.addYellowRed(yellowCards, redCards, gameId);

    bag.shuffle();
    return bag;
  }

  Map<String, List<CardData>> _dragCards(List<String> players, List<CardData> bag, int takeRed, int takeYellow) {

    final result = { for (var p in players) p: <CardData>[] };
    int currentPlayer = 0;
    for (int i = 0; i < bag.length; i++) {
      final player = players[currentPlayer];
      final card = bag[i];
      if((card.color == CardColor.red && takeRed > 0) || (card.color == CardColor.yellow && takeYellow > 0) || (card.color == CardColor.blue)){
        result[player]!.add(card);
        currentPlayer++;
        if(currentPlayer >= players.length){
          currentPlayer = 0;
        }
        if(card.color == CardColor.red){
          takeRed--;
        }else if(card.color == CardColor.yellow){
          takeYellow--;
        }
      }
    }
    return result;
  }
}