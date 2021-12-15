import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import '../offer.dart';
import '../store.dart';

class PlayStore implements Store {
  @override
  Future<Offer?> fetchOffer(String gameName) async {
    try {
      final response = await http.Client().get(Uri.parse(searchUrl + gameName));

      if (response.statusCode < 300) {
        var document = parser.parse(response.body);

        try {
          var gameList = document.getElementsByClassName("result");

          if (gameList.isNotEmpty) {
            var game = gameList[0];

            var gamePriceItem = game
                .getElementsByClassName("prices")[0]
                .getElementsByClassName("current")[0];
            var gamePrice = gamePriceItem.text.replaceAll(" ", "");
            gamePrice = gamePrice +
                gamePriceItem
                    .getElementsByClassName("fraction")[0]
                    .text
                    .substring(0, 2);

            var gameLink = game
                .getElementsByClassName("image")[0]
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
  String get homeUrl => "http://www.playstore.com/";

  @override
  String get logoUrl =>
      "https://files.sikayetvar.com/lg/cmp/25/25009.png?1522650125";

  @override
  String get name => "PlayStore";

  @override
  String get searchUrl => "http://www.playstore.com/arama?ara=";
}
