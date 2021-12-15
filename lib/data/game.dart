import 'package:flutter/foundation.dart';

import './offer.dart';

enum GamePlatform { pc, ps4, ps5, xone, xs, none }

GamePlatform StringToGamePlatform(String platform) {
  if (platform.toLowerCase().contains("pc") |
      platform.toLowerCase().contains("win")) return GamePlatform.pc;
  if (platform.toLowerCase().contains("ps4")) return GamePlatform.ps4;
  if (platform.toLowerCase().contains("ps5")) return GamePlatform.ps5;
  if (platform.toLowerCase().contains("xone") |
      platform.toLowerCase().contains("xbox one")) return GamePlatform.xone;
  if (platform.toLowerCase().contains("xs") |
      platform.toLowerCase().contains("xbox series")) return GamePlatform.xone;
  return GamePlatform.none;
}

String GamePlatformToString(GamePlatform platform) {
  switch (platform) {
    case GamePlatform.pc:
      return "PC";
    case GamePlatform.ps4:
      return "PS4";
    case GamePlatform.ps5:
      return "PS5";
    case GamePlatform.xone:
      return "Xbox One";
    case GamePlatform.xs:
      return "Xbox Series S|X";
    default:
      return "NA";
  }
}

class Game with ChangeNotifier {
  final String name;
  final String releaseDate;
  final String producer;
  final String publisher;
  final GamePlatform platform;
  final List<String> pictures;
  final List<Offer> priceList;

  Game({
    required this.name,
    required this.releaseDate,
    required this.producer,
    required this.publisher,
    required this.platform,
    required this.pictures,
    required this.priceList,
  });
}
