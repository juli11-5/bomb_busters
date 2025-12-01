import 'dart:convert';
import 'package:bomb_busters/models/card.dart';
import 'package:http/http.dart' as http;
import 'package:bomb_busters/models/game.dart';

class GameService {
  final String apiURL;

  GameService({required this.apiURL});

  Map<String, dynamic> _parseResponse(String body) {
    final decoded = jsonDecode(body);
    
    if (decoded is List) {
      if (decoded.isEmpty) {
        throw Exception('Game not found (List is empty)');
      }
      return decoded.first as Map<String, dynamic>;
    } 

    else if (decoded is Map<String, dynamic>) {
      return decoded;
    } 
    
    throw Exception('Unexpected response format');
  }

  Future<void> createGame(Game game) async {
    final response = await http.post(
      Uri.parse('$apiURL'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(game.toJson()),
    );

    if (response.statusCode == 201) {
      return;
    } else {
      throw Exception('Failed to create game');
    }
  }

  Future<void> joinGame(String gameId, String playerName) async {
    final getResponse = await http.get(
      Uri.parse('$apiURL?gameid=$gameId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (getResponse.statusCode != 200) {
      throw Exception('Failed to fetch game before join');
    }

    final gameData = _parseResponse(getResponse.body);
    Game game = Game.fromJson(gameData);

    if (!game.players.contains(playerName)) {
      game.players.add(playerName);
    }

    String validPutUrl = '$apiURL?gameid=$gameId'; 
    if (gameData.containsKey('id')) {
        validPutUrl = '$apiURL/${gameData['id']}';
    }

    final putResponse = await http.put(
      Uri.parse(validPutUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(game.toJson()),
    );

    if (putResponse.statusCode != 200 && putResponse.statusCode != 201) {
      throw Exception('Failed to post cards');
    }
  }

  Future<Game> getGame(String gameId) async {
    final response = await http.get(
      Uri.parse('$apiURL?gameid=$gameId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final gameData = _parseResponse(response.body);
      return Game.fromJson(gameData);
    } else {
      throw Exception('Failed to get game');
    }
  }

  Future<void> setCaptain(String gameId, String memberName) async {
    final getResponse = await http.get(
      Uri.parse('$apiURL?gameid=$gameId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (getResponse.statusCode != 200) {
      throw Exception('Failed to fetch game before setting admin');
    }

    final gameData = _parseResponse(getResponse.body);
    Game game = Game.fromJson(gameData);

    game = Game(
      gameId: game.gameId,
      admin: game.admin,
      players: game.players,
      isActive: game.isActive,
      cards: game.cards,
      captain: memberName,
    );
    
    String validPutUrl = '$apiURL?gameid=$gameId'; 
    if (gameData.containsKey('id')) {
        validPutUrl = '$apiURL/${gameData['id']}';
    }

    final putResponse = await http.put(
      Uri.parse(validPutUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(game.toJson()),
    );

    if (putResponse.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to update game during set admin');
    }
  }

  Future<void> addYellowRed(List<CardData> yellowCards, List<CardData> redCards, String gameId) async{
    final getResponse = await http.get(
      Uri.parse('$apiURL?gameid=$gameId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (getResponse.statusCode != 200) {
      throw Exception('Failed to fetch game before join');
    }

    final gameData = _parseResponse(getResponse.body);
    Game game = Game.fromJson(gameData);

    game.cards = yellowCards;
    game.cards.addAll(redCards);

    String validPutUrl = '$apiURL?gameid=$gameId'; 
    if (gameData.containsKey('id')) {
        validPutUrl = '$apiURL/${gameData['id']}';
    }

    final putResponse = await http.put(
      Uri.parse(validPutUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(game.toJson()),
    );

    if (putResponse.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to update yellow/red cards');
    }
  }

  Future<void> makeGameActive(String gameId, bool condition) async {
        final getResponse = await http.get(
      Uri.parse('$apiURL?gameid=$gameId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (getResponse.statusCode != 200) {
      throw Exception('Failed to fetch game before join');
    }

    final gameData = _parseResponse(getResponse.body);
    Game game = Game.fromJson(gameData);

    game.isActive = condition;

    String validPutUrl = '$apiURL?gameid=$gameId'; 
    if (gameData.containsKey('id')) {
        validPutUrl = '$apiURL/${gameData['id']}';
    }

    final putResponse = await http.put(
      Uri.parse(validPutUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(game.toJson()),
    );

    if (putResponse.statusCode != 200) {
      throw Exception('Failed to update yellow/red cards');
    }
  }
}