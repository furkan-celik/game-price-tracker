import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import '../offer.dart';
import '../store.dart';

class EpicGames implements Store {
  @override
  Future<Offer?> fetchOffer(String gameName) async {
    try {
      final response = await http.Client().get(Uri.parse(searchUrl + gameName));

      if (response.statusCode < 300) {
        var document = parser.parse(response.body);

        try {
          var gameList = document.getElementsByClassName("css-lrwy1y");

          if (gameList.isNotEmpty) {
            var game = gameList[0];

            var gamePriceItem = game.getElementsByClassName("css-z3vg5b")[0];
            var gamePrice = gamePriceItem.text.replaceAll(" ", "");
            gamePrice = gamePrice.substring(4);

            var gameLink = homeUrl +
                game
                    .getElementsByClassName("css-1jx3eyg")[0]
                    .attributes["href"]!;

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
  String get homeUrl => "https://www.epicgames.com/store/en-US";

  @override
  String get logoUrl =>
      "https://w7.pngwing.com/pngs/617/329/png-transparent-epic-games-gears-of-war-3-unreal-fortnite-paragon-others-miscellaneous-label-text.png";

  @override
  String get name => "Epic Games";

  @override
  String get searchUrl =>
      "https://www.epicgames.com/store/en-US/sortBy=relevancy&sortDir=DESC&count=40&browse?q=";
}
