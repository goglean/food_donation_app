import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_donating_app/screens/donor_confirmation.dart';
import 'package:food_donating_app/screens/journeyfinished.dart';
import 'package:food_donating_app/screens/writereview.dart';
import 'package:food_donating_app/widget/internet_service.dart';
import 'package:food_donating_app/widget/location_service.dart';
import 'package:food_donating_app/widget/noInternetScreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StartJourney extends StatefulWidget {
  Map curChar, curRes;
  StartJourney({required this.curChar, required this.curRes});

  @override
  _StartJourneyState createState() => _StartJourneyState();
}

class _StartJourneyState extends State<StartJourney> {
  Completer<GoogleMapController> _controller = Completer();
  List<LatLng?> directionLineMarker = new List.filled(2, null, growable: false);
  Set<Marker> markersSet = {};

  void setCurrentDirectionMarker() async {
    if (directionLineMarker[0] == null) {
      Position position = await LocationService().getGeoLocationPosition();

      setState(() {
        directionLineMarker[0] = LatLng(position.latitude, position.longitude);

        markersSet.add(Marker(
          markerId: MarkerId('CurrentLocation'),
          infoWindow: InfoWindow(title: 'You'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          position: LatLng(
            position.latitude,
            position.longitude,
          ),
          // onTap: () => _showRestaurentPanel,
        ));
      });
    }
  }

  BitmapDescriptor? resIcon;

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(128, 128)),
            'assets/Pickup_Orange_Marker.png')
        .then((onValue) {
      resIcon = onValue;
    });
    final CollectionReference col =
        FirebaseFirestore.instance.collection('pickup_details');
    col.snapshots().listen((event) {
      print(event);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setCurrentDirectionMarker();

    CameraPosition defaultCameraPos = CameraPosition(
      target: LatLng(double.parse(widget.curRes['Lat']),
          double.parse(widget.curRes['Lng'])),
      zoom: 14.4746,
    );

    markersSet.add(Marker(
      markerId: MarkerId('Res'),
      infoWindow: InfoWindow(title: widget.curRes['Restaurant Name']),
      // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      icon: resIcon ??
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      position: LatLng(
        double.parse(widget.curRes['Lat']),
        double.parse(widget.curRes['Lng']),
      ),
      // onTap: () => _showRestaurentPanel,
    ));

    if (directionLineMarker[1] == null) {
      directionLineMarker[1] = LatLng(double.parse(widget.curRes['Lat']),
          double.parse(widget.curRes['Lng']));
    }

    Future<void> _goToCurrentLocation(CameraPosition curLocation) async {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(curLocation));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Step 1: Travel to Donor'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Column(
              //   children: [
              //   ],
              // ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.curRes['Restaurant Name'],
                  style: TextStyle(
                    fontSize: 26,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),

              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on_outlined),
                      SizedBox(width: 3),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.curRes['Address'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Click for direction'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.call),
                      SizedBox(width: 3),
                      Column(
                        children: [
                          Text('Bussines number: 1234567890'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
              Container(
                height: 5,
                color: Theme.of(context).primaryColor,
              ),
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: defaultCameraPos,
                  markers: markersSet,
                  polylines: {
                    if (directionLineMarker[0] != null &&
                        directionLineMarker[1] != null)
                      Polyline(
                        polylineId: const PolylineId('overview_polyline'),
                        color: Colors.blue,
                        width: 5,
                        points: [
                          directionLineMarker[0]!,
                          directionLineMarker[1]!
                        ],
                      ),
                  },
                ),
              ),
              Container(
                width: double.infinity,
                color: Theme.of(context).primaryColor,
                child: FlatButton(
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
                    final CollectionReference pCollection =
                        FirebaseFirestore.instance.collection('pickup_details');

                    QuerySnapshot snapshot = await pCollection.get();
                    bool found = false;

                    snapshot.docs.forEach((element) {
                      Map dataMap = element.data() as Map;
                      if (dataMap['Pickedby'] ==
                              FirebaseAuth.instance.currentUser!.email &&
                          !found &&
                          dataMap['PickedCharityUniId'] ==
                              widget.curRes['PickedCharityUniId'] &&
                          widget.curRes['Restaurant Name'] ==
                              dataMap['Restaurant Name']) {
                        print(element.id);
                        pCollection.doc(element.id).update({
                          "Status": "picked",
                        });
                      }
                    });

                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DonorConfirmation(
                          curChar: widget.curChar,
                          curRes: widget.curRes,
                        ),
                      ),
                    );
                  },
                  textColor: Colors.white,
                  child: Text('ARRIVED AT PICKUP'),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 11, bottom: 81),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                onPressed: () async {
                  Position position =
                      await LocationService().getGeoLocationPosition();

                  CameraPosition? cameraPosition = CameraPosition(
                    target: LatLng(position.latitude, position.longitude),
                    zoom: 14,
                  );

                  // print(position.longitude);
                  _goToCurrentLocation(cameraPosition);

                  setState(() {
                    markersSet.add(
                      Marker(
                        markerId: MarkerId('CurrentLocation'),
                        infoWindow: InfoWindow(title: 'You'),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueViolet),
                        position: LatLng(
                          position.latitude,
                          position.longitude,
                        ),
                      ),
                    );

                    directionLineMarker[0] =
                        LatLng(position.latitude, position.longitude);
                  });
                },
                child: const Icon(Icons.pin_drop),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
