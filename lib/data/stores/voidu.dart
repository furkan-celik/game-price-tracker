import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import '../offer.dart';
import '../store.dart';

class Voidu implements Store {
  @override
  Future<Offer?> fetchOffer(String gameName) async {
    try {
      final response = await http.Client().get(Uri.parse(searchUrl + gameName));

      if (response.statusCode < 300) {
        var document = parser.parse(response.body);

        try {
          var gameList = document.getElementsByClassName("product-item");

          if (gameList.isNotEmpty) {
            var game = gameList[0];

            var gamePriceItem = game
                .getElementsByClassName("prices")[0]
                .getElementsByClassName("actual-price")[0];
            var gamePrice = gamePriceItem.text.replaceAll(" ", "");
            gamePrice = gamePrice.substring(0, gamePrice.length - 1);

            var gameLink = homeUrl +
                game
                    .getElementsByClassName("picture")[0]
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
  String get homeUrl => "https://www.voidu.com/";

  @override
  String get logoUrl =>
      "https://images.milledcdn.com/2018-10-08/6XobXYcjXK1M_pub/i1AY1n2j6O8w.png";

  @override
  String get name => "Voidu";

  @override
  String get searchUrl => "https://www.voidu.com/en/search?q=";
}
