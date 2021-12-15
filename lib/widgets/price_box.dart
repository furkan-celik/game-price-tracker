import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/offer.dart';

class PriceBox extends StatelessWidget {
  final Offer _offer;
  const PriceBox(this._offer, {Key? key}) : super(key: key);

  void _launchURL(_url) async {
    await canLaunch(_url) ? await launch(_url) : throw "Could not launc $_url";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              actionsAlignment: MainAxisAlignment.spaceBetween,
              title: Text(_offer.name),
              content: Text(
                  "You will be forwared to ${_offer.name}. Which is an external website where you can buy your game."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text("Close"),
                ),
                TextButton(
                  onPressed: () {
                    _launchURL(_offer.link);
                    Navigator.of(ctx).pop();
                  },
                  child: Text("Go to ${_offer.name}"),
                ),
              ],
            );
          },
        );
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 5),
        child: Container(
          padding: const EdgeInsets.all(5),
          alignment: Alignment.center,
          width: 80,
          height: 80,
          color: const Color(0xffbbdefb),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(_offer.icon),
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(
                height: 5,
              ),
              Text("${_offer.price}TL"),
            ],
          ),
        ),
      ),
    );
  }
}
