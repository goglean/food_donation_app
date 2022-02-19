import 'package:google_maps_flutter/google_maps_flutter.dart';

class Restaurent2 {
  String address, city, contactPerson, lat, lng, phoneNo;
  String name, status, days, details, email, endDate, endTime;
  String startDate, startTime;
  List desList, quantityList, unitList;
  String donationType;

  Restaurent2({
    required this.address,
    required this.city,
    required this.contactPerson,
    required this.lat,
    required this.lng,
    required this.phoneNo,
    required this.name,
    required this.status,
    required this.days,
    required this.details,
    required this.email,
    required this.endDate,
    required this.endTime,
    required this.startDate,
    required this.startTime,
    required this.desList,
    required this.quantityList,
    required this.unitList,
    required this.donationType,
  });
}

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
