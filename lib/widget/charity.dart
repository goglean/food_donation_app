class Charity {
  final String name, uniId;
  final String posLat, posLng;
  final String openTime, closeTime;
  List donationType;

  Charity({
    required this.name,
    required this.posLat,
    required this.posLng,
    required this.uniId,
    required this.openTime,
    required this.closeTime,
    required this.donationType,
  });
}
