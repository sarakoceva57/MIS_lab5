import 'package:flutter/foundation.dart';
import 'lokacija.dart';

class ListItem {
  final String id;
  final String predmet;
  final DateTime datum;
  // final String vreme;
  final Location location;

  ListItem(
      {required this.id,
      required this.predmet,
      required this.datum,
      // required this.vreme,
      required this.location});
}
