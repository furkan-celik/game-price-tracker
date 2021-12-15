import '../data/store.dart';
import '../data/stores/cdkeys.dart';
import '../data/stores/durmaplay.dart';
import '../data/stores/epicgames.dart';
import '../data/stores/g2a.dart';
import '../data/stores/hrk.dart';
import '../data/stores/oynasana.dart';
import '../data/stores/oyunfor.dart';
import '../data/stores/playstore.dart';
import '../data/stores/steam.dart';
import '../data/stores/voidu.dart';

import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import './games.dart';
import '../data/game.dart';
import '../data/offer.dart';

class PcGames extends Games {
  final List<Store> _pcStores = [
    CdKeys(),
    DurmaPlay(),
    EpicGames(),
    G2APC(),
    HRK(),
    Oynasana(),
    Oyunfor(),
    PlayStore(),
    Steam(),
    Voidu(),
  ];

  @override
  Stream<List<Game>> initGames({int page = 1}) async* {
    final response = await http.Client().get(
        Uri.parse(
            "https://store.steampowered.com/search/?filter=topsellers&os=win&page=" +
                page.toString()),
        headers: {
          "wants_mature_content": "1",
          "steamCountry": "TR%7C876b87f3aed2a360ec10a0b3508cac22",
          "birthtime": "-318304799",
          "lastagecheckage": "1-0-1960",
        });

    if (response.statusCode < 300) {
      var document = parser.parse(response.body);

      var gameList = document.getElementById("search_resultsRows")!.children;

      for (var i = 0; i < gameList.length; i++) {
        try {
          var game = gameList[i];

          var gameTitle = game.getElementsByClassName("title")[0].text;
          var gamePriceItem =
              game.getElementsByClassName("col search_price")[0];
          var gamePrice = gamePriceItem.text.replaceAll(" ", "");

          if (gamePriceItem.className.contains("discounted")) {
            gamePrice = gamePrice.substring(
                gamePrice.length ~/ 2 + 1, gamePrice.length - 2);
          } else {
            gamePrice = gamePrice.substring(0, gamePrice.length - 2);
          }
          var gameLink = game.attributes["href"]!;

          // print("$gameTitle: $gamePrice at $gameLink");

          Game parsedGame = await parseGame(
              gameLink,
              gameTitle.substring(
                  0,
                  gameTitle.lastIndexOf("-") == -1
                      ? gameTitle.length
                      : gameTitle.lastIndexOf("-"))) as Game;
          parsedGame.priceList.sort((o1, o2) => o1.price.compareTo(o2.price));
          super.addGame(parsedGame);

          yield games;
        } catch (e) {
          print(e);
        }
      }

      notifyListeners();
    }
  }

  @override
  Future<Game?> parseGame(String url, String gameName) async {
    final response = await http.Client().get(Uri.parse(url), headers: {
      "cookie":
          "timezoneOffset=10800,0; lastagecheckage=1-0-1916; steamCountry=TR%7C876b87f3aed2a360ec10a0b3508cac22; birthtime=-1706837988;",
    });

    if (response.statusCode >= 400) {
      return null;
    }

    try {
      var document = parser.parse(response.body);
      var gameInfo = document.getElementById("game_highlights")!;
      List<Offer> _priceList = [];
      List<Future<Offer?>> _futures = [];

      for (var store in _pcStores) {
        try {
          _futures.add(store.fetchOffer(gameName));
        } on Exception catch (e) {
          print(store.name + " no game avaliable");
        }
      }

      for (var offer in await Future.wait(_futures)) {
        if (offer != null) _priceList.add(offer);
      }

      return Game(
        name: document.getElementById("appHubAppName")!.text,
        releaseDate: gameInfo
            .getElementsByClassName("release_date")[0]
            .getElementsByClassName("date")[0]
            .text,
        producer: document
            .getElementById("developers_list")!
            .children[0]
            .text
            .split(" ")
            .map((element) =>
                element[0].toUpperCase() + element.substring(1).toLowerCase())
            .join(" "),
        publisher: document
            .getElementsByClassName("dev_row")[1]
            .children[1]
            .text
            .split(" ")
            .map((element) =>
                element[0].toUpperCase() + element.substring(1).toLowerCase())
            .join(" "),
        platform: StringToGamePlatform(document
            .getElementsByClassName("game_area_purchase_platform")[0]
            .children[0]
            .className),
        pictures: [
          document
              .getElementsByClassName("game_header_image_full")[0]
              .attributes["src"]
              .toString(),
          ...document
              .getElementsByClassName("highlight_screenshot_link")
              .map<String>((e) => e.attributes["href"].toString())
              .toList()
        ],
        // priceList: document
        //     .getElementsByClassName("row price-card-inside")
        //     .where((e) =>
        //         double.tryParse(e.children[2].text.toString().trim().substring(
        //             0, e.children[2].text.toString().trim().length - 1)) !=
        //         null)
        //     .map((e) {
        //   return Offer(
        //     name: e.children[1].text.toString(),
        //     price: double.parse(e.children[2].text
        //         .toString()
        //         .trim()
        //         .substring(0, e.children[2].text.toString().trim().length - 1)),
        //     icon: e.children[0].children[0].attributes["data-src"].toString(),
        //     link: e.children[3].children[0].children[0].attributes["onclick"]
        //         .toString(),
        //   );
        // }).toList(),
        priceList: _priceList,
      );
    } catch (e) {
      print(e);
    }
  }
}
