// ignore_for_file: file_names

import 'package:flutter/foundation.dart';

import '../data/game.dart';

abstract class Games with ChangeNotifier {
  final List<Game> _list = [];

  List<Game> get games {
    return _list;
  }

  void addGame(Game _new) {
    _list.add(_new);

    // notifyListeners();
  }

  Game findGame(String name) {
    return _list.firstWhere((element) => element.name == name);
  }

  Stream<List<Game>> initGames({int page = 1}) async* {
    throw Exception("Did not implemented");
  }

  Future<Game?> parseGame(String url, String gameName) async {
    throw Exception("Did not implemented");
  }

  void wipeList() {
    _list.clear();
  }
}
