import 'package:flutter/material.dart';
import 'package:food_donating_app/screens/charitysignature.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TravelToCharity extends StatefulWidget {
  Map curChar, curRes;
  TravelToCharity({required this.curChar, required this.curRes});

  @override
  _TravelToCharityState createState() => _TravelToCharityState();
}

class _TravelToCharityState extends State<TravelToCharity> {
  BitmapDescriptor? resIcon, charIcon;

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(128, 128)),
            'assets/Pickup_Orange_Marker.png')
        .then((onValue) {
      resIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(128, 128)),
            'assets/Drop-off_Orange_Marker.png')
        .then((onValue) {
      charIcon = onValue;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition defaultCameraPos = CameraPosition(
      target: LatLng(double.parse(widget.curRes['Lat']),
          double.parse(widget.curRes['Lng'])),
      zoom: 14.4746,
    );

    Marker resMarker = Marker(
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
    );

    Marker charMarker = Marker(
      markerId: MarkerId('Char'),
      infoWindow: InfoWindow(title: widget.curChar['name']),
      // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      icon: charIcon ??
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      position: LatLng(
        double.parse(widget.curChar['posLat']),
        double.parse(widget.curChar['posLng']),
      ),
      // onTap: () => _showRestaurentPanel,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Step 3: Travel to Charity'),
      ),
      body: Column(
        children: [
          // Column(
          //   children: [
          //   ],
          // ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.curChar['name'],
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
                        'charity address',
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
                      Text('Bussines number: Phone'),
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
            child: GoogleMap(initialCameraPosition: defaultCameraPos, markers: {
              resMarker,
              charMarker
            }, polylines: {
              Polyline(
                polylineId: const PolylineId('overview_polyline'),
                color: Colors.blue,
                width: 5,
                points: [
                  LatLng(double.parse(widget.curChar['posLat']),
                      double.parse(widget.curChar['posLng'])),
                  LatLng(double.parse(widget.curRes['Lat']),
                      double.parse(widget.curRes['Lng'])),
                ],
              ),
            }),
          ),
          Container(
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CharitySignature(
                      curChar: widget.curChar,
                      curRes: widget.curRes,
                    ),
                  ),
                );
              },
              textColor: Colors.white,
              child: Text('ARRIVED AT DROP OFF'),
            ),
          ),
        ],
      ),
    );
  }
}
