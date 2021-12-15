import 'package:flutter/material.dart';

import '../data/game.dart';
import './price_box.dart';
import './side_gallery.dart';
import '../screens/game_details_screen.dart';

class GameCard extends StatelessWidget {
  const GameCard(
    this._game, {
    Key? key,
  }) : super(key: key);

  final Game _game;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 3,
      ),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
          GameDetailsScreen.routeName,
          arguments: {"game": _game.name},
        ),
        child: Card(
          elevation: 10,
          color: const Color(0xBBeeffff),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  height: 200,
                  width: 800,
                  child: Hero(
                      tag: _game.name,
                      child: SideGallery(
                        _game.pictures,
                        key: ValueKey(_game.name),
                      )),
                ),
              ),
              const Divider(),
              Text(
                _game.name,
                overflow: TextOverflow.fade,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const Divider(),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PriceBox(_game.priceList[0]),
                    if (_game.priceList.length >= 2)
                      PriceBox(_game.priceList[1]),
                    if (_game.priceList.length >= 3)
                      PriceBox(_game.priceList[2]),
                    if (_game.priceList.length >= 4)
                      PriceBox(_game.priceList[3]),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
