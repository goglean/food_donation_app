import 'dart:async';
import 'package:food_donating_app/shared/nearby_res_info.dart';
import 'package:food_donating_app/widget/directionfiles/directions_model.dart';
import 'package:food_donating_app/widget/directionfiles/directions_repository.dart';
import 'package:food_donating_app/widget/location_service.dart';
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

  Future<Position> _determinePosition() async {
    //   bool serviceEnabled;
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    } else {
      print('Location not available');
    }

    //   if (permission == LocationPermission.deniedForever) {
    //     // Permissions are denied forever, handle appropriately.
    //     return Future.error(
    //         'Location permissions are permanently denied, we cannot request permissions.');
    //   }

    //   // When we reach here, permissions are granted and we can
    //   // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final Marker _kGooglePlexMarker = Marker(
    markerId: MarkerId('_kGooglePlex'),
    infoWindow: InfoWindow(title: 'Google Plex'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(37.42796133580664, -122.085749655962),
  );

  static final Marker _kLakeMarker = Marker(
    markerId: MarkerId('_kLakeMarker'),
    infoWindow: InfoWindow(title: 'Lake'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    position: LatLng(37.43296265331129, -122.08832357078792),
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  static final Polyline _kPolyline = Polyline(
    polylineId: PolylineId('_kPolyline'),
    points: [
      LatLng(37.42796133580664, -122.085749655962),
      LatLng(37.43296265331129, -122.08832357078792),
      LatLng(37.418, -122.092),
      LatLng(37.435, -122.092),
    ],
    width: 5,
  );

  static final Polygon _kPolygon = Polygon(
    polygonId: PolygonId('_kPolygon'),
    points: [
      LatLng(37.42796133580664, -122.085749655962),
      LatLng(37.43296265331129, -122.08832357078792),
      LatLng(37.418, -122.092),
      LatLng(37.435, -122.092),
    ],
    strokeWidth: 5,
    fillColor: Colors.transparent,
  );

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

    // print(position.longitude);
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

  // void putCustomIcon() {
  //   BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(100, 100)),
  //           'assets/Donor_Map_Marker_Orange.png')
  //       .then((onValue) {
  //     resIcon = onValue;
  //   });
  // }

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(128, 128)),
            'assets/Donor_Map_Marker_Orange.png')
        .then((onValue) {
      resIcon = onValue;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Restaurent2>? restaurent = Provider.of<List<Restaurent2>?>(context);
    // if (resIcon != null) setState(() => putCustomIcon);
    // print(restaurent!.length);
    Restaurent2? curRestaurent = null;
    restaurentMarker.clear();
    if (locationMarker != null) restaurentMarker.add(locationMarker!);

    CameraPosition? curCameraPos = null;

    if (locationMarker == null) initializeWithCurrentLocation();

    Future<void> _goToTheLake() async {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    }

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

      // Restaurent restaurentData =
      //     await MapService().getRestaurentDataFromFirebase(restaurentId);
      setState(() {
        curRestaurent = restaurentData;
      });
    }

    Future<int> curLocation() async {
      Position curPos = await _determinePosition();
      bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (isLocationServiceEnabled) {
        // print('${curPos.longitude} - ${curPos.latitude}');
        // print('\n\n\n\n\n\n\n\n\n\n');
        // setState(() {
        //   curCameraPos = CameraPosition(
        //     target: LatLng(curPos.latitude, curPos.longitude),
        //     zoom: 14.4746,
        //   );
        // });
      }
      return 0;
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

    for (int i = 0; i < restaurent!.length; i++) {
      if (locationMarker != null) {
        if (LocationService().calculateDistanceBetweenTwoLatLongsInKm(
                  locationMarker!.position.latitude,
                  locationMarker!.position.longitude,
                  double.parse(restaurent[i].lat),
                  double.parse(restaurent[i].lng),
                ) >
                20 &&
            !TimeCheck().getOpenStatus(
                restaurent[i].startTime, restaurent[i].startTime)) {
          continue;
        }

        isMarkerWithinRange = true;

        restaurentMarker.add(Marker(
          markerId: MarkerId(restaurent[i].email),
          infoWindow: InfoWindow(title: restaurent[i].name),
          // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          icon: resIcon,
          position: LatLng(
            double.parse(restaurent[i].lat),
            double.parse(restaurent[i].lng),
          ),
          // onTap: () => _showRestaurentPanel,

          onTap: () async {
            directionLineMarker[1] = LatLng(double.parse(restaurent[i].lat),
                double.parse(restaurent[i].lng));
            _showRestaurentPanel(restaurent[i].email);
            // print(_origin!.position.latitude);
            // print(_destination!.position.longitude);

            // Get directions
            // final directions = await DirectionsRepository().getDirections(
            //     origin: _origin!.position, destination: _destination!.position);
            // print(directions.totalDistance);

            // setState(() => _info = directions);
            // await curLocation();
          },
        ));
      }
    }

    // for (var item in restaurentMarker) {
    //   print(item.toString());
    //   print('\n\n');
    // }

    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          // markers: {
          //   _kGooglePlexMarker,
          //   // _kLakeMarker,
          // },
          markers: restaurentMarker,
          // initialCameraPosition: curCameraPos ?? defaultCameraPos,

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
          // myLocationEnabled: true,
          // myLocationButtonEnabled: true,
          // polygons: {
          //   _kPolygon,
          // },
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

                // print(position.longitude);
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
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Container(
        //         color: Colors.red[400],
        //         child: Padding(
        //           padding: const EdgeInsets.fromLTRB(8, 4, 2, 4),
        //           child: Icon(
        //             Icons.error_outline,
        //             color: Colors.white,
        //           ),
        //         ),
        //       ),
        //       Container(
        //         color: Colors.red[400],
        //         child: Padding(
        //           padding: const EdgeInsets.fromLTRB(2, 4, 16, 4),
        //           child: Text(
        //             'Sorry, no nearby Restaurants',
        //             style: TextStyle(
        //               fontSize: 18,
        //               color: Colors.white,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Future<void> _goToPlace(Map<String, dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 12),
    ));
  }
}
