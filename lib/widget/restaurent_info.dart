import 'package:flutter/material.dart';
import 'package:food_donating_app/widget/internet_service.dart';
import 'package:food_donating_app/widget/noInternetScreen.dart';
import 'package:food_donating_app/widget/restaurents.dart';
import 'package:food_donating_app/widget/transition_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurentInfo extends StatefulWidget {
  final Restaurent2? curRestaurent;
  final Marker? location;

  const RestaurentInfo(this.curRestaurent, this.location);

  @override
  _RestaurentInfoState createState() => _RestaurentInfoState();
}

class _RestaurentInfoState extends State<RestaurentInfo> {
  String distanceBetweenMarker = 'Please choose your current location';
  @override
  Widget build(BuildContext context) {
    Widget makeDismissible({required Widget child}) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).pop(),
          child: GestureDetector(onTap: () {}, child: child),
        );

    if (widget.location != null) {
      distanceBetweenMarker = (Geolocator.distanceBetween(
                      double.parse(widget.curRestaurent!.lat),
                      double.parse(widget.curRestaurent!.lng),
                      widget.location!.position.latitude,
                      widget.location!.position.longitude) *
                  0.000621371)
              .toStringAsFixed(2) +
          " miles";
    }

    return makeDismissible(
      child: DraggableScrollableSheet(
        initialChildSize: 0.2,
        maxChildSize: 1,
        minChildSize: 0.1,
        builder: (_, controller) => InkWell(
          onTap: () async {
            bool connected = await InternetService().checkInternetConnection();
            if (!connected) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoInternetScreen(),
                ),
              );
              return;
            }

            if (widget.curRestaurent!.status != 'upcoming') return;
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransitionScreen(),
                settings: RouteSettings(
                  arguments: {
                    'res': widget.curRestaurent,
                    'location': widget.location
                  },
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      color: widget.curRestaurent!.status == 'upcoming'
                          ? Colors.green[400]
                          : Colors.red[400],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 0, 8),
                      child: Text(
                        widget.curRestaurent!.status == 'upcoming'
                            ? 'UNCLAIMED'
                            : 'CLAIMED',
                        // style: TextStyle(
                        //   backgroundColor: widget.curRestaurent!.isClaimed
                        //       ? Colors.red[600]
                        //       : Colors.green[600],
                        // ),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.ac_unit),
                  title: Text(
                    widget.curRestaurent!.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  subtitle: Text(
                    '${widget.curRestaurent!.startDate}, ${widget.curRestaurent!.startTime} - ${widget.curRestaurent!.endTime}\n${distanceBetweenMarker}',
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
