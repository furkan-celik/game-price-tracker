import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import '../offer.dart';
import '../store.dart';

class CdKeys implements Store {
  @override
  Future<Offer?> fetchOffer(String gameName) async {
    try {
      final response = await http.Client().get(Uri.parse(searchUrl + gameName));

      if (response.statusCode < 300) {
        var document = parser.parse(response.body);

        try {
          var gameList = document.getElementsByClassName("result-wrapper");

          if (gameList.isNotEmpty) {
            var game = gameList[0];

            var gamePriceItem =
                game.getElementsByClassName("after_special promotion")[0];
            var gamePrice = gamePriceItem.text.replaceAll(" ", "");
            gamePrice = gamePrice.substring(1);

            var gameLink = game
                .getElementsByClassName("result-thumbnail")[0]
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
  String get homeUrl => "https://www.cdkeys.com/";

  @override
  String get logoUrl =>
      "https://www.g2a.com/static/assets/images/logo_g2a_white.svg";

  @override
  String get name => "CdKeys";

  @override
  String get searchUrl => "https://www.cdkeys.com/catalogsearch/result/?q=gta5";
}
