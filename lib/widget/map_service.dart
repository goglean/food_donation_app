import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_donating_app/widget/charity.dart';
import 'package:food_donating_app/widget/restaurents.dart';

class MapService {
  final String? uniqueId;
  MapService({this.uniqueId});

  final CollectionReference restaurentCollection =
      FirebaseFirestore.instance.collection('restaurent');

  final CollectionReference charityCollection =
      FirebaseFirestore.instance.collection('charity');

  Restaurent _restaurentDataFromSnapshot(DocumentSnapshot snapshot) {
    return Restaurent(
      name: snapshot.get('name'),
      posLat: snapshot.get('posLat'),
      posLng: snapshot.get('posLng'),
      uniId: snapshot.get('uniId'),
      isClaimed: snapshot.get('isClaimed'),
      openTime: snapshot.get('openTime'),
      closeTime: snapshot.get('closeTime'),
    );
  }

  Stream<Restaurent> get restaurentData => restaurentCollection
      .doc(uniqueId)
      .snapshots()
      .map(_restaurentDataFromSnapshot);

  Future<Charity> getCharityDataFromFirebase(String uniqueId) async {
    DocumentSnapshot snapshot = await charityCollection.doc(uniqueId).get();
    var data = snapshot.data() as Map;
    return Charity(
      name: data['name'],
      posLat: data['posLat'],
      posLng: data['posLng'],
      uniId: data['uniId'],
      openTime: data['openTime'],
      closeTime: data['closeTime'],
    );
  }

  Future<Restaurent> getRestaurentDataFromFirebase(String uniqueId) async {
    DocumentSnapshot snapshot = await restaurentCollection.doc(uniqueId).get();
    var data = snapshot.data() as Map;
    return Restaurent(
      name: data['name'],
      posLat: data['posLat'],
      posLng: data['posLng'],
      uniId: data['uniId'],
      isClaimed: data['isClaimed'],
      openTime: data['openTime'],
      closeTime: data['closeTime'],
    );
  }

  bool? convertStringToBool(String str) {
    str = str.toLowerCase();
    print(str);
    if (str == 'true')
      return true;
    else
      false;
  }

  List<Charity> _charityListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Charity(
        name: doc['name'] ?? '',
        posLat: doc['posLat'] ?? '',
        posLng: doc['posLng'] ?? '',
        uniId: doc['uniId'] ?? '',
        openTime: doc['openTime'] ?? '',
        closeTime: doc['closeTime'] ?? '',
      );
    }).toList();
  }

  Stream<List<Charity>> get charities {
    return charityCollection.snapshots().map(_charityListFromSnapshot);
  }

  List<Restaurent> _restaurentListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Restaurent(
        name: doc['name'] ?? '',
        posLat: doc['posLat'] ?? '',
        posLng: doc['posLng'] ?? '',
        uniId: doc['uniId'] ?? '',
        isClaimed: doc['isClaimed'] ?? false,
        openTime: doc['openTime'] ?? '',
        closeTime: doc['closeTime'] ?? '',
      );
    }).toList();
  }

  Stream<List<Restaurent>> get restaurents {
    return restaurentCollection.snapshots().map(_restaurentListFromSnapshot);
  }
}
