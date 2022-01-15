import 'package:google_maps_flutter/google_maps_flutter.dart';

class Restaurent {
  final String name, uniId;
  final String posLat, posLng;
  final bool isClaimed;
  final String openTime, closeTime;

  Restaurent({
    required this.name,
    required this.posLat,
    required this.posLng,
    required this.uniId,
    required this.isClaimed,
    required this.openTime,
    required this.closeTime,
  });
}
