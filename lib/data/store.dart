import 'package:gamehunterz_app/data/offer.dart';

abstract class Store {
  final String name;
  final String homeUrl;
  final String searchUrl;
  final String logoUrl;

  Store({
    this.name = "",
    this.homeUrl = "",
    this.searchUrl = "",
    this.logoUrl = "",
  });

  Future<Offer?> fetchOffer(String gameName) async {
    return null;
  }
}
