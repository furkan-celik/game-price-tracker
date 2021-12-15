import 'package:flutter/material.dart';
import 'package:gamehunterz_app/providers/pc_games.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/game.dart';
import '../providers/games.dart';
import '../widgets/side_gallery.dart';

class GameDetailsScreen extends StatelessWidget {
  static const routeName = "/game-details";
  const GameDetailsScreen({Key? key}) : super(key: key);

  void _launchURL(_url) async {
    await canLaunch(_url) ? await launch(_url) : throw "Could not launc $_url";
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Game _game =
        Provider.of<PcGames>(context, listen: false).findGame(args["game"]);

    int cutOff = 0;
    for (var i = 0; i < _game.publisher.length; i++) {
      if (_game.publisher[i] != " " &&
          _game.publisher[i] != "\t" &&
          _game.publisher[i] != "\n") {
        cutOff = i;
      } else {
        break;
      }
    }
    _game.publisher = _game.publisher.substring(cutOff);

    return Scaffold(
      appBar: AppBar(
        title: Text(_game.name),
      ),
      body: Column(
        children: [
          Hero(
            tag: _game.name,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              height: 200,
              width: 800,
              child: SideGallery(
                _game.pictures,
                key: ValueKey(_game.name),
              ),
            ),
          ),
          const Divider(
            thickness: 2.5,
            height: 2.5,
          ),
          Container(
            width: double.infinity,
            height: 100,
            child: Card(
              elevation: 5,
              color: const Color(0xffeeffff),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Producer: ${_game.producer.substring(0, _game.producer.length >= 20 ? 20 : _game.producer.length)}...",
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                      Text(
                        "Publisher: ${_game.publisher.substring(0, _game.publisher.length >= 20 ? 20 : _game.publisher.length)}...",
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Release Date: ${_game.releaseDate}"),
                      Row(
                        children: [
                          const Text("Platforms: "),
                          Container(
                            width: 100,
                            height: 35,
                            child: Center(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (ctx, idx) => Chip(
                                  padding: const EdgeInsets.all(5),
                                  backgroundColor: Colors.red[200],
                                  label: Text(
                                    GamePlatformToString(_game.platform),
                                  ),
                                ),
                                itemCount: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Text("Platform: ${GamePlatformToString(_game.platform)}"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            thickness: 2.5,
            height: 5,
          ),
          Expanded(
            child: Card(
              elevation: 5,
              margin: const EdgeInsets.all(5),
              color: const Color(0xffeeffff),
              child: ListView.builder(
                itemBuilder: (ctx, i) => Column(
                  children: [
                    ListTile(
                      leading: Image.network(
                        _game.priceList[i].icon,
                        width: 100,
                      ),
                      title: Text(_game.priceList[i].name),
                      trailing: Container(
                        width: 100,
                        // color: const Color(0xffbbdefb),
                        child: ElevatedButton(
                          style: ButtonStyle().copyWith(
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0xffbbdefb),
                            ),
                            elevation: MaterialStateProperty.all<double>(5.0),
                          ),
                          child: Text(
                            "${_game.priceList[i].price} TL",
                            style: const TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  actionsAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  title: Text(_game.priceList[i].name),
                                  content: Text(
                                      "You will be forwared to ${_game.priceList[i].name}. Which is an external website where you can buy your game."),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(),
                                      child: const Text("Close"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _launchURL(_game.priceList[i].link);
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Text(
                                          "Go to ${_game.priceList[i].name}"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                      indent: 15,
                      endIndent: 15,
                    ),
                  ],
                ),
                itemCount: _game.priceList.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
