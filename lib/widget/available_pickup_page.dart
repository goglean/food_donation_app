import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_donating_app/shared/loading.dart';
import 'package:food_donating_app/widget/charity.dart';
import 'package:food_donating_app/widget/map_service.dart';
import 'package:food_donating_app/widget/restaurents.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AvaiablePickups extends StatefulWidget {
  final Map dataFromScreen;
  const AvaiablePickups({required this.dataFromScreen});

  @override
  State<AvaiablePickups> createState() => _AvaiablePickupsState();
}

class _AvaiablePickupsState extends State<AvaiablePickups> {
  Completer<GoogleMapController> _controller = Completer();

  bool charityClicked = false;
  bool recievedCharityData = false;
  Charity? curCharity = null;
  double distanceBetweenMarker = 0;

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
        onTap: () async {
          if (!charityClicked) {
            setState(() {
              charityClicked = true;
            });
          }

          Charity charityData =
              await MapService().getCharityDataFromFirebase(charity[i].uniId);
          distanceBetweenMarker = Geolocator.distanceBetween(
              double.parse(charityData.posLat),
              double.parse(charityData.posLng),
              double.parse(curRes.posLat),
              double.parse(curRes.posLng));

          print(charityData.uniId);
          setState(() {
            curCharity = charityData;
            recievedCharityData = true;
            print(curCharity!.closeTime);
            print('\n\n\n\n\n\n\n\n\n\n');
          });
        },
      ));
    }

    return Column(
      children: [
        Expanded(
          flex: 40,
          child: GoogleMap(
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
                          ListTile(
                            leading: Icon(Icons.access_time),
                            title: Text(
                                '${curCharity?.openTime} - ${curCharity?.closeTime}'),
                          ),
                          ListTile(
                            leading: Icon(Icons.location_on),
                            title: Text(distanceBetweenMarker.toString()),
                          ),
                          // Row(
                          //   children: [
                          //     Container(
                          //       child: Icon(Icons.access_alarm),
                          //     ),
                          //     // Text(
                          //     //     '${curCharity?.openTime} - ${curCharity?.closeTime}')
                          //   ],
                          // ),
                          Container(
                            height: double.infinity,
                            color: Colors.orange[50],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                            child: RaisedButton(
                              textColor: Colors.white,
                              color: Colors.orange[600],
                              child: Text(
                                'CLAIM',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                              onPressed: () {},
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
