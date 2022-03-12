class Charity {
  final String name, uniId;
  final String posLat, posLng;
  // final String openTime, closeTime;
  final String phoneNumber;
  List donationType;
  List openCloseTime;

  Charity({
    required this.name,
    required this.phoneNumber,
    required this.posLat,
    required this.posLng,
    required this.uniId,
    // required this.openTime,
    // required this.closeTime,
    required this.donationType,
    required this.openCloseTime,
  });
}
