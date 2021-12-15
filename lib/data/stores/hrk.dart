import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import '../offer.dart';
import '../store.dart';

class HRK implements Store {
  @override
  Future<Offer?> fetchOffer(String gameName) async {
    try {
      final response = await http.Client().get(Uri.parse(searchUrl + gameName));

      if (response.statusCode < 300) {
        var document = parser.parse(response.body);

        try {
          var gameList = document.getElementsByClassName("item");

          if (gameList.isNotEmpty) {
            var game = gameList[0];

            if (game.getElementsByClassName("price").isEmpty) {
              return null;
            }
            var gamePriceItem = game.getElementsByClassName("price")[0];
            var gamePrice = gamePriceItem.text.replaceAll(" ", "");
            gamePrice = gamePrice.substring(1);

            var gameLink =
                game.getElementsByClassName("ui image")[0].attributes["href"]!;

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
  String get homeUrl => "https://www.hrkgame.com/en/";

  @override
  String get logoUrl => "https://www.hrkgame.com/allstaticfiles/img/logo.png";

  @override
  String get name => "HRK Game";

  @override
  String get searchUrl => "https://www.hrkgame.com/en/games/products/?search=";
}
