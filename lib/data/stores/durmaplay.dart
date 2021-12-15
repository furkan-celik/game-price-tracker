import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import '../offer.dart';
import '../store.dart';

class DurmaPlay implements Store {
  @override
  Future<Offer?> fetchOffer(String gameName) async {
    try {
      final response = await http.Client().get(Uri.parse(searchUrl + gameName));

      if (response.statusCode < 300) {
        var document = parser.parse(response.body);

        try {
          var gameList = document.getElementsByClassName("search-page");

          if (gameList.isNotEmpty) {
            var game = gameList[0];
            var gamePriceItem = game
                .getElementsByClassName("price")[0]
                .getElementsByClassName("max")[0];
            var gamePrice = gamePriceItem.text.replaceAll(" ", "");

            gamePrice = gamePrice.substring(4);
            var gameLink = homeUrl + game.attributes["href"]!;

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
  String get homeUrl => "https://www.durmaplay.com";

  @override
  String get logoUrl =>
      "https://media.durmaplay.com/d/icon?format=png&height=64";

  @override
  String get name => "DurmaPlay";

  @override
  String get searchUrl => "https://www.durmaplay.com/tr/search?query=";
}
