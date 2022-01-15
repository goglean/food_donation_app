import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_donating_app/widget/restaurents.dart';

class MapService {
  final String? restaurentId;
  MapService({this.restaurentId});

  final CollectionReference restaurentCollection =
      FirebaseFirestore.instance.collection('restaurent');

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
      .doc(restaurentId)
      .snapshots()
      .map(_restaurentDataFromSnapshot);

  Future<Restaurent> getRestaurentDataFromFirebase(String restaurentId) async {
    DocumentSnapshot snapshot =
        await restaurentCollection.doc(restaurentId).get();
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
