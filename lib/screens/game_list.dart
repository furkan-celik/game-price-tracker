import 'package:flutter/material.dart';
import 'package:gamehunterz_app/data/game.dart';
import 'package:gamehunterz_app/providers/pc_games.dart';
import 'package:gamehunterz_app/widgets/pagination.dart';
import 'package:provider/provider.dart';

import '../providers/games.dart';
import '../widgets/game_card.dart';

class GameList extends StatefulWidget {
  const GameList({Key? key}) : super(key: key);

  @override
  State<GameList> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  int _currentPage = 1;
  int _selectedIndex = 0;
  bool _isWaiting = false;
  late final Games _gameProvier = Provider.of<PcGames>(context, listen: false);
  late Stream<List<Game>> _gameLoader = _gameProvier.initGames(
      // url: _selectedIndex == 0
      //     ? "https://www.gamehunterz.com/pc-oyunlari?page="
      //     : "https://www.gamehunterz.com/ps-oyunlari?page=",
      page: _currentPage);

  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _gameProvier.wipeList();
    _gameLoader = _gameProvier.initGames(
        // url: _selectedIndex == 0
        //     ? "https://www.gamehunterz.com/pc-oyunlari?page="
        //     : "https://www.gamehunterz.com/ps-oyunlari?page=",
        page: _currentPage);
  }

  @override
  void initState() {
    super.initState();
  }

  void gatherNewGames() {
    _gameLoader = _gameProvier.initGames(page: _currentPage);
    _isWaiting = true;
  }

  @override
  Widget build(BuildContext context) {
    final games = Provider.of<PcGames>(context, listen: true)
        .games
        .where((element) => element.platform.index == _selectedIndex)
        .toList();

    for (var i = 0; i < games.length; i++) {
      games[i].priceList.sort((x, y) => x.price.compareTo(y.price));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("GameHunterz"),
      ),
      backgroundColor: Colors.grey.shade300,
      body: StreamBuilder(
        stream: _gameLoader,
        builder: (ctx, snp) => !snp.hasData
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  _gameProvier.wipeList();
                  _gameProvier.initGames();
                },
                child: ListView.builder(
                  itemBuilder: (ctx, i) {
                    if (i == (snp.data as List<Object?>).length) {
                      if (snp.connectionState != ConnectionState.done) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Pagination(
                        _isWaiting,
                        _currentPage,
                        (target) => setState(() {
                          _currentPage = target;
                          gatherNewGames();
                        }),
                      );
                    }
                    return GameCard(_gameProvier.games[i]);
                  },
                  itemCount: (snp.data as List<Object?>).length + 1,
                ),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.computer),
            label: "PC",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: "PS4/5",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.one_x_mobiledata),
            label: "Xbox",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
