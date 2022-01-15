import 'dart:async';
// import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_donating_app/shared/loading.dart';
import 'package:food_donating_app/widget/map_service.dart';
import 'package:food_donating_app/widget/restaurent_info.dart';
import 'package:food_donating_app/widget/restaurents.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class RestaurentMap extends StatefulWidget {
  const RestaurentMap({Key? key}) : super(key: key);

  @override
  _RestaurentMapState createState() => _RestaurentMapState();
}

class _RestaurentMapState extends State<RestaurentMap> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _searchController = TextEditingController();

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }

  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   return await Geolocator.getCurrentPosition();
  // }

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
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    final restaurent = Provider.of<List<Restaurent>?>(context);
    Restaurent? curRestaurent = null;

    CameraPosition? curCameraPos = null;

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

    // void curLocation() async {
    //   Position curPos = await _determinePosition();
    //   bool isLocationServiceEnabled =
    //       await Geolocator.isLocationServiceEnabled();
    //   if (isLocationServiceEnabled) {
    //     setState(() {
    //       curCameraPos = CameraPosition(
    //         target: LatLng(curPos.latitude, curPos.longitude),
    //         zoom: 14.4746,
    //       );
    //     });
    //   }
    // }

    // curLocation();

    void _showRestaurentPanel(String restaurentId) {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        builder: (context) {
          getRestaurentInfo(restaurentId);
          if (curRestaurent != null) {
            return RestaurentInfo(curRestaurent);
          } else {
            return Loading();
          }
        },
      ).whenComplete(() {
        curRestaurent = null;
      });
    }

    Set<Marker> restaurentMarker = {};
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
        onTap: () {
          _showRestaurentPanel(restaurent[i].uniId);
        },
      ));
    }

    return GoogleMap(
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

      // polylines: {
      //   _kPolyline,
      // },
      // polygons: {
      //   _kPolygon,
      // },
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

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
