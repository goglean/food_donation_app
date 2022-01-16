import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_donating_app/widget/charity.dart';
import 'package:food_donating_app/widget/restaurents.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AvaiablePickups extends StatefulWidget {
  const AvaiablePickups({Key? key}) : super(key: key);

  @override
  State<AvaiablePickups> createState() => _AvaiablePickupsState();
}

class _AvaiablePickupsState extends State<AvaiablePickups> {
  Completer<GoogleMapController> _controller = Completer();
  @override
  Widget build(BuildContext context) {
    final charity = Provider.of<List<Charity>?>(context);
    final dataFromScreen = ModalRoute.of(context)!.settings.arguments as Map;

    Restaurent curRes = dataFromScreen['res'];

    CameraPosition initialRestaurentPosition = CameraPosition(
      zoom: 12,
      target: LatLng(double.parse(curRes.posLat), double.parse(curRes.posLng)),
    );

    Set<Marker> pickupMarkers = {
      // Current restaurent marker
      Marker(
        markerId: MarkerId(curRes.uniId),
        infoWindow: InfoWindow(title: curRes.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        position: LatLng(
          double.parse(curRes.posLat),
          double.parse(curRes.posLng),
        ),
      )
    };

    for (int i = 0; i < charity!.length; i++) {
      pickupMarkers.add(Marker(
        markerId: MarkerId(charity[i].uniId),
        infoWindow: InfoWindow(title: charity[i].name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        position: LatLng(
          double.parse(charity[i].posLat),
          double.parse(charity[i].posLng),
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Avaiable Pickups'),
        backgroundColor: Colors.orange[800],
        centerTitle: true,
      ),
      body: GoogleMap(
        markers: pickupMarkers,
        mapType: MapType.normal,
        initialCameraPosition: initialRestaurentPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
