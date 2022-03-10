import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_donating_app/screens/myPickups.dart';
import 'package:food_donating_app/shared/loading.dart';
import 'package:food_donating_app/widget/charity.dart';
import 'package:food_donating_app/widget/internet_service.dart';
import 'package:food_donating_app/widget/location_service.dart';
import 'package:food_donating_app/widget/map_service.dart';
import 'package:food_donating_app/widget/noInternetScreen.dart';
import 'package:food_donating_app/widget/restaurents.dart';
import 'package:food_donating_app/widget/timecheck.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AvaiablePickups extends StatefulWidget {
  final Map dataFromScreen;
  final Marker? location;
  const AvaiablePickups({required this.dataFromScreen, this.location});

  @override
  State<AvaiablePickups> createState() => _AvaiablePickupsState();
}

class _AvaiablePickupsState extends State<AvaiablePickups> {
  Completer<GoogleMapController> _controller = Completer();

  bool charityClicked = false;
  bool recievedCharityData = false;
  Charity? curCharity = null;
  String distanceBetweenMarker = '0';
  String? charityAddress, resAddress;

  // 0th position show LatLng of current location 1st shows LatLng of tepped restaurent
  List<LatLng?> directionLineMarker = new List.filled(2, null, growable: false);

  BitmapDescriptor? resIcon, charIcon;

  String? dis = '10';

  void getDistanceFromFirebase() async {
    final CollectionReference utils =
        FirebaseFirestore.instance.collection('utils');
    await utils.doc('Distance').get().then((DocumentSnapshot snap) {
      Map dataMap = snap.data() as Map;
      dis = dataMap['Distance'];
    });
  }

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(128, 128)),
            'assets/Pickup_Orange_Marker.png')
        .then((onValue) {
      resIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(128, 128)),
            'assets/Drop-off_Orange_Marker.png')
        .then((onValue) {
      charIcon = onValue;
    });

    getDistanceFromFirebase();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final charity = Provider.of<List<Charity>?>(context);
    final dataFromScreen = ModalRoute.of(context)!.settings.arguments as Map;
    Restaurent2 curRes = dataFromScreen['res'];
    Marker? location = dataFromScreen['location'];

    CameraPosition initialRestaurentPosition = CameraPosition(
      zoom: 12,
      target: LatLng(double.parse(curRes.lat), double.parse(curRes.lng)),
    );

    Set<Marker> pickupMarkers = {
      // Current restaurent marker
      Marker(
        markerId: MarkerId(curRes.email),
        infoWindow: InfoWindow(title: curRes.name),
        // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        icon: resIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        position: LatLng(
          double.parse(curRes.lat),
          double.parse(curRes.lng),
        ),
      ),
      if (location != null) location,
    };

    directionLineMarker[0] = LatLng(
      double.parse(curRes.lat),
      double.parse(curRes.lng),
    );
    for (int i = 0; i < charity!.length; i++) {
      // making all the values of donationType list to lowercase
      for (var j = 0; j < charity[i].donationType.length; j++) {
        charity[i].donationType[j] =
            charity[i].donationType[j].toString().toLowerCase();
      }
      DateTime now = DateTime.now();
      if (LocationService().calculateDistanceBetweenTwoLatLongsInKm(
                  double.parse(curRes.lat),
                  double.parse(curRes.lng),
                  double.parse(charity[i].posLat),
                  double.parse(charity[i].posLng)) >
              double.parse(dis!) ||
          !TimeCheck().getOpenStatus("2022-3-6", charity[i].openTime,
              "2022-6-12", charity[i].closeTime) ||
          !charity[i]
              .donationType
              .contains(curRes.donationType.toLowerCase())) {
        continue;
      }
      // if (charity[i].name == 'charity 2') {
      //   print('\n\n\n\n\n');
      // }
      // print(curRes.donationType);

      pickupMarkers.add(Marker(
        markerId: MarkerId(charity[i].uniId),
        infoWindow: InfoWindow(title: charity[i].name),
        // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        icon: charIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        position: LatLng(
          double.parse(charity[i].posLat),
          double.parse(charity[i].posLng),
        ),
        onTap: () async {
          bool connected = await InternetService().checkInternetConnection();
          if (!connected) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoInternetScreen(),
              ),
            );
            return;
          }

          directionLineMarker[1] = LatLng(
              double.parse(charity[i].posLat), double.parse(charity[i].posLng));

          if (!charityClicked) {
            setState(() {
              charityClicked = true;
            });
          }

          Charity charityData =
              await MapService().getCharityDataFromFirebase(charity[i].uniId);
          distanceBetweenMarker = (Geolocator.distanceBetween(
                      double.parse(charityData.posLat),
                      double.parse(charityData.posLng),
                      double.parse(curRes.lat),
                      double.parse(curRes.lng)) *
                  0.000621371)
              .toStringAsFixed(3);

          String firebaseCharAdd = await LocationService()
              .GetAddressFromLatLong(charityData.posLat, charityData.posLng);
          String firebaseResAdd = await LocationService()
              .GetAddressFromLatLong(curRes.lat, curRes.lng);

          // print(charityData.uniId);
          setState(() {
            curCharity = charityData;
            recievedCharityData = true;
            charityAddress = firebaseCharAdd;
            resAddress = firebaseResAdd;
            // print(curCharity!.closeTime);
            // print('\n\n\n\n\n\n\n\n\n\n');
          });
        },
      ));
    }

    void openDialogue() {
      // print('object');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  'https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                  height: 150.0,
                  width: 150.0,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Thank you for claiming this pickup!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.orange[700],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'You can start your pickup anytime between start and endtime for the pickup',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              RaisedButton(
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                child: Text(
                  'OKAY',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                onPressed: () async {
                  bool connected =
                      await InternetService().checkInternetConnection();
                  if (!connected) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoInternetScreen(),
                      ),
                    );
                    return;
                  }

                  // print('object');
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyPickups()));
                },
              ),
            ],
          ),
        ),
      );
    }

    // print(curRes.desList.length);

    return Column(
      children: [
        Expanded(
          flex: 40,
          child: GoogleMap(
            mapToolbarEnabled: false,
            polylines: {
              if (directionLineMarker[0] != null &&
                  directionLineMarker[1] != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.blue,
                  width: 5,
                  points: [directionLineMarker[0]!, directionLineMarker[1]!],
                ),
            },
            markers: pickupMarkers,
            mapType: MapType.normal,
            initialCameraPosition: initialRestaurentPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
        charityClicked
            ? (recievedCharityData
                ? Expanded(
                    flex: 60,
                    child: Scrollbar(
                      thickness: 0.0,
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 8,
                            child: const DecoratedBox(
                              decoration:
                                  const BoxDecoration(color: Colors.black),
                            ),
                          ),

                          // location details
                          ListTile(
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -4),
                            horizontalTitleGap: 0,
                            leading: Icon(
                              Icons.access_time,
                              size: 20,
                            ),
                            title: Text(
                              '${curCharity?.openTime} - ${curCharity?.closeTime}',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          ListTile(
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -4),
                            horizontalTitleGap: 0,
                            leading: Icon(
                              Icons.location_on,
                              size: 20,
                            ),
                            title: RichText(
                              text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(
                                      text:
                                          '${distanceBetweenMarker} miles from ',
                                    ),
                                    TextSpan(
                                      text: curRes.name,
                                      style:
                                          TextStyle(color: Colors.orange[800]),
                                    ),
                                    TextSpan(
                                      text: ' to ',
                                    ),
                                    TextSpan(
                                      text: curCharity!.name,
                                      style: TextStyle(
                                        color: Colors.orange[300],
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: 2,
                            child: const DecoratedBox(
                              decoration:
                                  const BoxDecoration(color: Colors.grey),
                            ),
                          ),

                          // pickup and dropoff details
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.orange[800],
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://images.pexels.com/photos/674010/pexels-photo-674010.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                                  radius: 25,
                                ),
                              ),
                              title: Text(
                                'Pickup from ${curRes.name} at ${resAddress}',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.orange[300],
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://images.pexels.com/photos/326055/pexels-photo-326055.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                                  radius: 25,
                                ),
                              ),
                              title: Text(
                                'Drop off to ${curCharity!.name} at ${charityAddress}',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2,
                            child: const DecoratedBox(
                              decoration:
                                  const BoxDecoration(color: Colors.grey),
                            ),
                          ),

                          // What food will i pick
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 8, 0, 0),
                            child: Text(
                              'What food will I pick',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 8, 0, 8),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: curRes.desList.length,
                              itemBuilder: (context, index) {
                                return Text(curRes.quantityList[index] +
                                    "  " +
                                    curRes.desList[index] +
                                    " (" +
                                    curRes.unitList[index] +
                                    ")");
                              },
                            ),
                            // child: Text('he;;p'),
                          ),
                          SizedBox(
                            height: 2,
                            child: const DecoratedBox(
                              decoration:
                                  const BoxDecoration(color: Colors.grey),
                            ),
                          ),

                          // What you need to know
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 8, 0, 0),
                            child: Text(
                              'What you need to know before you go for pickup',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 8, 0, 8),
                            child: Text(curRes.details),
                          ),
                          SizedBox(
                            height: 2,
                            child: const DecoratedBox(
                              decoration:
                                  const BoxDecoration(color: Colors.grey),
                            ),
                          ),

                          //Food donor pickup details
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 8, 0, 0),
                            child: Text(
                              "Food Donor's Pick-Up Details",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 8, 0, 8),
                            child: Text(
                                'Come to the back door. Call us when you are near'),
                          ),
                          SizedBox(
                            height: 2,
                            child: const DecoratedBox(
                              decoration:
                                  const BoxDecoration(color: Colors.grey),
                            ),
                          ),

                          // CLaim Button
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                            child: RaisedButton(
                              textColor: Colors.white,
                              color: Theme.of(context).primaryColor,
                              child: Text(
                                'CLAIM',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              onPressed: () async {
                                bool connected = await InternetService()
                                    .checkInternetConnection();
                                if (!connected) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NoInternetScreen(),
                                    ),
                                  );
                                  return;
                                }

                                final userRef = FirebaseFirestore.instance
                                    .collection('pickup_details');

                                await userRef.get().then((snapshot) {
                                  snapshot.docs.forEach((element) async {
                                    if (element.data()['email'] ==
                                        curRes.email) {
                                      // print(curCharity!.uniId);
                                      await userRef.doc(element.id).update({
                                        'Status': 'claimed',
                                        'Pickedby': FirebaseAuth
                                            .instance.currentUser!.email,
                                        'PickedCharityUniId': curCharity!.uniId
                                      });
                                      return;
                                    }
                                    // print(element.id);
                                    // print(element.data()['email']);
                                  });
                                });

                                // await MapService(uniqueId: curRes.uniId)
                                //     .updateResClaimedCondition(curRes);

                                openDialogue();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Loading())
            : SizedBox(height: 0),
      ],
    );
  }
}
