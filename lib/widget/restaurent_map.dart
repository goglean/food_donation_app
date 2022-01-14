import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  List<LatLng> polygonLatLng = <LatLng>[];

  int _polygonCounter = 1;

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

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('marker'),
          position: point,
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();

    _setMarker(LatLng(37.43296265331129, -122.08832357078792));
  }

  @override
  Widget build(BuildContext context) {
    final restaurent = Provider.of<List<Restaurent>?>(context);

    void _showRestaurentPanel() {
      print('22222222222222222');
      showModalBottomSheet(
        context: context,
        builder: (context) {
          print('object');
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
            child: RestaurentInfo(),
          );
        },
        elevation: 2,
      );
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
          _showRestaurentPanel();
        },
      ));
    }

    return GoogleMap(
      mapType: MapType.hybrid,
      // markers: {
      //   _kGooglePlexMarker,
      //   // _kLakeMarker,
      // },
      markers: restaurentMarker,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },

      onTap: (point) {},
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
