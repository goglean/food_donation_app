import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_donating_app/shared/nearby_res_info.dart';
import 'package:food_donating_app/widget/directionfiles/directions_model.dart';
import 'package:food_donating_app/widget/directionfiles/directions_repository.dart';
import 'package:food_donating_app/widget/internet_service.dart';
import 'package:food_donating_app/widget/location_service.dart';
import 'package:food_donating_app/widget/noInternetScreen.dart';
import 'package:food_donating_app/widget/timecheck.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:food_donating_app/shared/loading.dart';
import 'package:food_donating_app/widget/map_service.dart';
import 'package:food_donating_app/widget/restaurent_info.dart';
import 'package:food_donating_app/widget/restaurents.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class RestaurentMap extends StatefulWidget {
  @override
  _RestaurentMapState createState() => _RestaurentMapState();
}

class _RestaurentMapState extends State<RestaurentMap> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> restaurentMarker = {};
  Marker? locationMarker = null;
  bool isMarkerWithinRange = false;

  // 0th position show LatLng of current location 1st shows LatLng of tepped restaurent
  List<LatLng?> directionLineMarker = new List.filled(2, null, growable: false);

  CameraPosition defaultCameraPos = CameraPosition(
    // target: LatLng(13.5566036, 80.0251352),
    target: LatLng(113.5566036, 180.0251352),
    zoom: 14.4746,
  );

  Marker? _origin = null, _destination = null;
  Directions? _info = null;

  Future<void> _goToCurrentLocation(CameraPosition curLocation) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(curLocation));
  }

  void initializeWithCurrentLocation() async {
    Position position = await LocationService().getGeoLocationPosition();

    directionLineMarker[0] = LatLng(position.latitude, position.longitude);

    CameraPosition? cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14,
    );

    _goToCurrentLocation(cameraPosition);

    locationMarker = Marker(
      markerId: MarkerId('userLocation'),
      infoWindow: InfoWindow(title: 'You'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: LatLng(
        position.latitude,
        position.longitude,
      ),
    );

    setState(() {
      restaurentMarker.add(locationMarker!);
    });
  }

  late BitmapDescriptor resIcon;

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(128, 128)),
            'assets/Donor_Map_Marker_Orange.png')
        .then((onValue) {
      resIcon = onValue;
    });

    final CollectionReference pickupDetailsCollection =
        FirebaseFirestore.instance.collection('pickup_details');

    pickupDetailsCollection.snapshots().listen((event) {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Restaurent2>? restaurent = Provider.of<List<Restaurent2>?>(context);
    Restaurent2? curRestaurent = null;
    isMarkerWithinRange = false;
    restaurentMarker.clear();
    if (locationMarker != null) restaurentMarker.add(locationMarker!);

    CameraPosition? curCameraPos = null;

    if (locationMarker == null) initializeWithCurrentLocation();

    _destination = Marker(
      markerId: MarkerId('_kGooglePlex'),
      infoWindow: InfoWindow(title: 'Google Plex'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(37.42796133580664, -122.085749655962),
    );

    _origin = Marker(
      markerId: MarkerId('_kLakeMarker'),
      infoWindow: InfoWindow(title: 'Lake'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      position: LatLng(37.43296265331129, -122.08832357078792),
    );

    void getRestaurentInfo(String email) async {
      Restaurent2? restaurentData =
          await MapService().getRestaurent2DataFromFirebase(email);

      setState(() {
        curRestaurent = restaurentData;
      });
    }

    // curLocation();

    void _showRestaurentPanel(String email) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          getRestaurentInfo(email);
          if (curRestaurent != null) {
            return RestaurentInfo(curRestaurent, locationMarker);
          } else {
            return Loading();
          }
        },
      ).whenComplete(() {
        curRestaurent = null;
      });
    }

    // print(locationMarker!.position.longitude);

    for (int i = 0; i < restaurent!.length; i++) {
      if (locationMarker != null) {
        if (LocationService().calculateDistanceBetweenTwoLatLongsInKm(
                  locationMarker!.position.latitude,
                  locationMarker!.position.longitude,
                  double.parse(restaurent[i].lat),
                  double.parse(restaurent[i].lng),
                ) >
                80.4672 ||
            !TimeCheck().getOpenStatus(
                restaurent[i].startDate,
                restaurent[i].startTime,
                restaurent[i].endDate,
                restaurent[i].endTime)) {
          // print(!TimeCheck().getOpenStatus(
          //     restaurent[i].startTime, restaurent[i].endTime));
          continue;
        }
        print(restaurentMarker);
        isMarkerWithinRange = true;

        restaurentMarker.add(Marker(
          markerId: MarkerId(restaurent[i].email),
          infoWindow: InfoWindow(title: restaurent[i].name),
          icon: resIcon,
          position: LatLng(
            double.parse(restaurent[i].lat),
            double.parse(restaurent[i].lng),
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

            directionLineMarker[1] = LatLng(double.parse(restaurent[i].lat),
                double.parse(restaurent[i].lng));
            _showRestaurentPanel(restaurent[i].email);
          },
        ));
      }
    }

    return Stack(
      children: [
        GoogleMap(
          mapToolbarEnabled: false,
          mapType: MapType.normal,
          markers: restaurentMarker,
          initialCameraPosition: defaultCameraPos,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
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
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 36),
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

                locationMarker = Marker(
                  markerId: MarkerId('userLocation'),
                  infoWindow: InfoWindow(title: 'You'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                  position: LatLng(
                    position.latitude,
                    position.longitude,
                  ),
                );

                setState(() {
                  restaurentMarker.add(locationMarker!);
                  directionLineMarker[0] = LatLng(
                      locationMarker!.position.latitude,
                      locationMarker!.position.longitude);
                });
              },
              child: const Icon(Icons.pin_drop),
            ),
          ),
        ),
        (locationMarker != null)
            ? isMarkerWithinRange
                ? Container()
                : NearbyRestaurantInfo()
            : NearbyRestaurantInfo(
                dialogueText:
                    'Please, turn on your location and press location button',
              ),
      ],
    );
  }
}

class Value2 {
  static String? value;
  static void setString(String? newValue) {
    value = newValue;
  }

  static String? getString() {
    return value;
  }
}
