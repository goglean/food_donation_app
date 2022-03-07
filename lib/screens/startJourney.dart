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
import 'package:url_launcher/url_launcher.dart';

class StartJourney extends StatefulWidget {
  Map curChar, curRes;
  StartJourney({required this.curChar, required this.curRes});

  @override
  _StartJourneyState createState() => _StartJourneyState();
}

class _StartJourneyState extends State<StartJourney> {
  String dis = "";
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

  void getCurAddress() async {
    dis = await LocationService()
        .GetAddressFromLatLong(widget.curRes['Lat'], widget.curRes['Lng']);
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

    getCurAddress();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setCurrentDirectionMarker();

    Future<void> _goToCurrentLocation(CameraPosition curLocation) async {
      print('object');
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(curLocation));
    }

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Step 1: Travel to Donor'),
        centerTitle: true,
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
                      Text(
                        dis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.call),
                      SizedBox(width: 3),
                      FlatButton(
                        onPressed: () =>
                            launch("tel://${widget.curRes['Phone Number']}"),
                        child: Text(
                            'Bussines number: ${widget.curRes['Phone Number']}'),
                      ),
                      // Text(
                      //     'Bussines number: ${widget.curRes['Phone Number']}'),
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
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
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

                    // Navigator.pop(context);
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
