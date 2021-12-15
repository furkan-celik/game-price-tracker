import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import '../offer.dart';
import '../store.dart';

class Steam implements Store {
  @override
  Future<Offer?> fetchOffer(String gameName) async {
    try {
      final response = await http.Client().get(Uri.parse(searchUrl + gameName));

      if (response.statusCode < 300) {
        var document = parser.parse(response.body);

        try {
          var gameList =
              document.getElementById("search_resultsRows")!.children;

          if (gameList.isNotEmpty) {
            var gameSteam = gameList[0];
            var gamePriceItem =
                gameSteam.getElementsByClassName("col search_price")[0];
            var gamePrice = gamePriceItem.text.replaceAll(" ", "");

            if (gamePriceItem.className.contains("discounted")) {
              gamePrice = gamePrice.substring(
                  gamePrice.length ~/ 2 + 1, gamePrice.length - 2);
            } else {
              gamePrice = gamePrice.substring(0, gamePrice.length - 2);
            }
            var gameLink = gameSteam.attributes["href"]!;

            return Offer(
              name: name,
              price: double.parse(gamePrice.replaceAll(",", ".")),
              icon: logoUrl,
              link: gameLink,
            );
          }
          return null;
        } catch (e) {
          print(name);
          print(e);
          return null;
        }
      }
    } on Exception catch (e) {
      print("$name does not have $gameName");
    }
  }

  @override
  String get homeUrl =>
      "https://store.steampowered.com/search/?filter=topsellers&os=win";

  @override
  String get logoUrl =>
      "https://e7.pngegg.com/pngimages/1014/595/png-clipart-steam-computer-icons-logo-video-game-valves-steam-logo-symbol.png";

  @override
  String get name => "Steam";

  @override
  String get searchUrl => "https://store.steampowered.com/search/?term=";
}
