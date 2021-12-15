import 'package:flutter/material.dart';
import 'package:gamehunterz_app/providers/games.dart';
import 'package:gamehunterz_app/providers/pc_games.dart';
import 'package:gamehunterz_app/screens/game_details_screen.dart';
import 'package:gamehunterz_app/screens/game_list.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => PcGames(),
      child: MaterialApp(
        title: 'GameHunterz',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: const GameList(),
        routes: {
          GameDetailsScreen.routeName: (ctx) => const GameDetailsScreen(),
        },
      ),
    );
  }
}
