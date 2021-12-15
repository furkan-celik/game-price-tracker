import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import '../offer.dart';
import '../store.dart';

class Oyunfor implements Store {
  @override
  Future<Offer?> fetchOffer(String gameName) async {
    try {
      final response = await http.Client().get(Uri.parse(searchUrl + gameName));

      if (response.statusCode < 300) {
        var document = parser.parse(response.body);

        try {
          var gameList = document
              .getElementsByClassName("col-md-33 col-xl-20 mt-4 col-50");

          if (gameList.isNotEmpty) {
            var gamePage = await http.Client()
                .get(Uri.parse(gameList[0].children[0].attributes["href"]!));
            var gameDoc = parser.parse(gamePage.body);
            var game = gameDoc.getElementsByClassName("productBox")[0];

            var gamePriceItem = game.getElementsByClassName("notranslate")[0];
            var gamePrice = gamePriceItem.text.replaceAll(" ", "");
            gamePrice = gamePrice.substring(0, gamePrice.length - 2);

            var gameLink = gameList[0].children[0].attributes["href"]!;

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
  String get homeUrl => "https://www.oyunfor.com/";

  @override
  String get logoUrl =>
      "https://cdn.oyunfor.com/Public/standart/web/dist/img/logo.png";

  @override
  String get name => "Oyunfor";

  @override
  String get searchUrl => "https://www.oyunfor.com/ara?q=";
}
