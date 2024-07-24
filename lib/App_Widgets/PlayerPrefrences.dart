import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../Model/PlayersTeamCreateData/PlayersData.dart';
// import '../view/create_your_team/createTeam.dart';

class PlayerPreferences {
  static Future<void> savePlayerLists({
    required List<PlayersData> batsmen,
    required List<PlayersData> bowlers,
    required List<PlayersData> wicketkeeper,
    required List<PlayersData> allrounders,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('batsmen', _convertListToJson(batsmen));
    prefs.setStringList('bowlers', _convertListToJson(bowlers));
    prefs.setStringList('wicketkeeper', _convertListToJson(wicketkeeper));
    prefs.setStringList('allrounders', _convertListToJson(allrounders));

  }

  static Future<List<PlayersData>> getPlayerList(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? playerListJson = prefs.getStringList(key);

    if (playerListJson != null) {
      return playerListJson.map((json) => PlayersData.fromJson(jsonDecode(json))).toList();
    } else {
      return [];
    }
  }

  static List<String> _convertListToJson(List<PlayersData> playerList) {
    return playerList.map((player) => jsonEncode(player.toJson())).toList();
  }
}