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
  String distanceBetweenMarker = '0';

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
          distanceBetweenMarker = (Geolocator.distanceBetween(
                      double.parse(charityData.posLat),
                      double.parse(charityData.posLng),
                      double.parse(curRes.posLat),
                      double.parse(curRes.posLng)) *
                  0.000621371)
              .toStringAsFixed(3);

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
                'You can start your pickup upto one hour before time begins.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              RaisedButton(
                textColor: Colors.white,
                color: Colors.orange[600],
                child: Text(
                  'OKAY',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                onPressed: () {
                  print('object');
                },
              ),
            ],
          ),
        ),
      );
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
                                'Pickup from ${curRes.name} at address dfawf agafd gg aga g zsfgs g zdsf g zdf',
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
                                'Drop off to ${curCharity!.name} at address',
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
                            child: Text('food 1\nfood2'),
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
                              'What you need to know',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 8, 0, 8),
                            child: Text('food 1\nfood2'),
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
                              onPressed: () {
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
