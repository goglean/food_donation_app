import 'package:google_maps_flutter/google_maps_flutter.dart';

class Restaurent {
  final String name, uniId;
  final String posLat, posLng;

  Restaurent(
      {required this.name,
      required this.posLat,
      required this.posLng,
      required this.uniId});
}
