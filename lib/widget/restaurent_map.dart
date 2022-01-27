import 'dart:async';
import 'package:food_donating_app/widget/directionfiles/directions_model.dart';
import 'package:food_donating_app/widget/directionfiles/directions_repository.dart';
import 'package:food_donating_app/widget/locations.dart';
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
  TextEditingController _searchController = TextEditingController();
  Set<Marker> restaurentMarker = {};
  Marker? locationMarker = null;

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
      print('Location not avaiable');
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
    target: LatLng(13.5566036, 80.0251352),
    zoom: 14.4746,
  );

  Marker? _origin = null, _destination = null;
  Directions? _info = null;

  @override
  Widget build(BuildContext context) {
    final restaurent = Provider.of<List<Restaurent>?>(context);
    Restaurent? curRestaurent = null;

    CameraPosition? curCameraPos = null;

    Future<void> _goToCurrentLocation(CameraPosition curLocation) async {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(curLocation));
    }

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

    void getRestaurentInfo(String restaurentId) async {
      Restaurent restaurentData =
          await MapService().getRestaurentDataFromFirebase(restaurentId);
      setState(() {
        curRestaurent = restaurentData;
      });
      // print(restaurentData.name);
      // print(restaurentData.posLat);
      // print(restaurentData.posLng);
      // print(restaurentData.uniId);
      // print(restaurentData.isClaimed);
    }

    Future<int> curLocation() async {
      Position curPos = await _determinePosition();
      bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (isLocationServiceEnabled) {
        print('${curPos.longitude} - ${curPos.latitude}');
        print('\n\n\n\n\n\n\n\n\n\n');
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

    void _showRestaurentPanel(String restaurentId) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          getRestaurentInfo(restaurentId);
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
      restaurentMarker.add(Marker(
        markerId: MarkerId(restaurent[i].uniId),
        infoWindow: InfoWindow(title: restaurent[i].name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        position: LatLng(
          double.parse(restaurent[i].posLat),
          double.parse(restaurent[i].posLng),
        ),
        // onTap: () => _showRestaurentPanel,
        onTap: () async {
          directionLineMarker[1] = LatLng(double.parse(restaurent[i].posLat),
              double.parse(restaurent[i].posLng));
          _showRestaurentPanel(restaurent[i].uniId);
          // print(_origin!.position.latitude);
          // print(_destination!.position.longitude);
          // Get directions
          final directions = await DirectionsRepository().getDirections(
              origin: _origin!.position, destination: _destination!.position);
          print(directions.totalDistance);
          // setState(() => _info = directions);
          // await curLocation();
        },
      ));
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
                Position position = await Location().getGeoLocationPosition();

                CameraPosition? cameraPosition = CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 14,
                );

                print(position.longitude);
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
