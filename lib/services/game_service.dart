import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bomb_busters/models/card.dart';
import 'package:bomb_busters/models/game.dart';

class GameService {
  final String apiURL;

  GameService({required this.apiURL});

  Map<String, dynamic> _parseResponse(String body) {
    final decoded = jsonDecode(body);

    if (decoded is List) {
      if (decoded.isEmpty) {
        return {}; // Leere Map statt Exception
      }
      return decoded.first as Map<String, dynamic>;
    } else if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return {};
  }

  Future<void> createGame(Game game) async {
    await http.post(
      Uri.parse(apiURL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(game.toJson()),
    );
  }

  Future<void> joinGame(String gameId, String playerName) async {
    final game = await _getGameById(gameId);
    if (!game.players.contains(playerName)) {
      game.players.add(playerName);
      await _putGame(game, gameId);
    }
  }

  Future<Game> getGame(String gameId) async {
    return await _getGameById(gameId);
  }

  Future<void> setCaptain(String gameId, String memberName) async {
    final game = await _getGameById(gameId);
    game.captain = memberName;
    await _putGame(game, gameId);
  }

  Future<void> addYellowRed(List<CardData> yellowCards, List<CardData> redCards, String gameId) async {
    final game = await _getGameById(gameId);
    game.cards = [...yellowCards, ...redCards];
    await _putGame(game, gameId);
  }

  Future<void> makeGameActive(String gameId, bool isActive) async {
    final game = await _getGameById(gameId);
    game.isActive = isActive;
    await _putGame(game, gameId);
  }

  // ---------------------------
  // Private helper methods
  // ---------------------------

  Future<Game> _getGameById(String gameId) async {
    final response = await http.get(
      Uri.parse('$apiURL?gameid=$gameId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = _parseResponse(response.body);
      if (data.isEmpty) {
        return Game(gameId: gameId, players: [], isActive: false, cards: [], admin: '', captain: '');
      }
      return Game.fromJson(data);
    }

    return Game(gameId: gameId, players: [], isActive: false, cards: [], admin: '', captain: '');
  }

  Future<void> _putGame(Game game, String gameId) async {
    final response = await http.get(
      Uri.parse('$apiURL?gameid=$gameId'),
      headers: {'Content-Type': 'application/json'},
    );

    String putUrl = '$apiURL?gameid=$gameId';
    final data = _parseResponse(response.body);
    if (data.containsKey('id')) {
      putUrl = '$apiURL/${data['id']}';
    }

    await http.put(
      Uri.parse(putUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(game.toJson()),
    );
  }
}
