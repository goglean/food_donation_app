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
    );
  }

  Stream<Restaurent> get restaurentData => restaurentCollection
      .doc(restaurentId)
      .snapshots()
      .map(_restaurentDataFromSnapshot);

  List<Restaurent> _restaurentListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Restaurent(
        name: doc['name'] ?? '',
        posLat: doc['posLat'] ?? '',
        posLng: doc['posLng'] ?? '',
        uniId: doc['uniId'] ?? '',
      );
    }).toList();
  }

  Stream<List<Restaurent>> get restaurents {
    return restaurentCollection.snapshots().map(_restaurentListFromSnapshot);
  }
}
