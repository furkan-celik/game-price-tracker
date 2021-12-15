import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import '../offer.dart';
import '../store.dart';

class G2APC implements Store {
  @override
  Future<Offer?> fetchOffer(String gameName) async {
    try {
      final response = await http.Client().get(Uri.parse(searchUrl + gameName));

      if (response.statusCode < 300) {
        var document = parser.parse(response.body);

        try {
          var gameList = document.getElementsByClassName("pc-digital");

          if (gameList.isNotEmpty) {
            var game = gameList[0];
            var gamePriceItem = game.getElementsByClassName(
                "indexes__PriceCurrentBase-wklrsw-86 iPgINw")[0];
            var gamePrice = gamePriceItem.text.replaceAll(" ", "");

            var gameLink = homeUrl +
                game
                    .getElementsByClassName(
                        "indexes__Banner-wklrsw-76 indexes__StyledBanner-wklrsw-114")[0]
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
  String get homeUrl => "https://www.g2a.com";

  @override
  String get logoUrl =>
      "https://www.g2a.com/static/assets/images/logo_g2a_white.svg";

  @override
  String get name => "G2A";

  @override
  String get searchUrl =>
      "https://www.g2a.com/search?sort=price-lowest-first&query=";
}
