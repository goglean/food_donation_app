import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StartJourney extends StatefulWidget {
  const StartJourney({Key? key}) : super(key: key);

  @override
  _StartJourneyState createState() => _StartJourneyState();
}

class _StartJourneyState extends State<StartJourney> {
  CameraPosition defaultCameraPos = CameraPosition(
    target: LatLng(13.5566036, 80.0251352),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              "Trader' joe",
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
                        'gdnfagjlbg gaksbgask gaskgaslg askf',
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
          // ListTile(
          //   leading: Icon(Icons.location_on_outlined),
          //   title: Text('hello'),
          //   subtitle: Text('hel'),
          // ),
          Container(
            height: 5,
            color: Theme.of(context).primaryColor,
          ),
          Expanded(
            child: GoogleMap(initialCameraPosition: defaultCameraPos),
          ),
          Container(
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: FlatButton(
              onPressed: () {},
              textColor: Colors.white,
              child: Text('ARRIVED AT PICKUP'),
            ),
          ),
        ],
      ),
    );
  }
}
