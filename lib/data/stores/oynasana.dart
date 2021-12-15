import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import '../offer.dart';
import '../store.dart';

class Oynasana implements Store {
  @override
  Future<Offer?> fetchOffer(String gameName) async {
    try {
      final response = await http.Client().get(Uri.parse(searchUrl + gameName));

      if (response.statusCode < 300) {
        var document = parser.parse(response.body);

        try {
          var gameList = document.getElementsByClassName("product");

          if (gameList.isNotEmpty) {
            var game = gameList[0];

            var gamePriceItem =
                game.getElementsByClassName("product__price--on-sale").isEmpty
                    ? game.getElementsByClassName("product__price")[0]
                    : game.getElementsByClassName("product__price--on-sale")[0];
            var gamePrice =
                gamePriceItem.text.replaceAll(" ", "").replaceAll("\n", "");
            gamePrice = gamePrice.substring(
                game.getElementsByClassName("product__price--on-sale").isEmpty
                    ? 11
                    : 15,
                gamePrice.length - 2);

            var gameLink = homeUrl +
                game
                    .getElementsByClassName("supports-js")[0]
                    .children[0]
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
  String get homeUrl => "https://oynasana.com/";

  @override
  String get logoUrl =>
      "https://cdn.shopify.com/s/files/1/2667/1576/files/header-logo-bw_360x.gif?v=1517864265";

  @override
  String get name => "Oynasana";

  @override
  String get searchUrl => "https://oynasana.com/search?q=";
}
