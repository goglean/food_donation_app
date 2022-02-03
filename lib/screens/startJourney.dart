import 'package:flutter/material.dart';
import 'package:food_donating_app/screens/donor_confirmation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StartJourney extends StatefulWidget {
  Map curChar, curRes;
  StartJourney({required this.curChar, required this.curRes});

  @override
  _StartJourneyState createState() => _StartJourneyState();
}

class _StartJourneyState extends State<StartJourney> {
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
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      position: LatLng(
        double.parse(widget.curRes['Lat']),
        double.parse(widget.curRes['Lng']),
      ),
      // onTap: () => _showRestaurentPanel,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Step 1: Travel to Donor'),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.curRes['Address'],
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
                      Text('Bussines number: 1234567890'),
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
            child: GoogleMap(
              initialCameraPosition: defaultCameraPos,
              markers: {resMarker},
            ),
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
    );
  }
}
