import 'package:flutter/material.dart';
import 'package:food_donating_app/widget/available_pickup_page.dart';
import 'package:food_donating_app/widget/charity.dart';
import 'package:food_donating_app/widget/map_service.dart';
import 'package:food_donating_app/widget/restaurents.dart';
import 'package:food_donating_app/widget/transition_screen.dart';
import 'package:provider/provider.dart';

class RestaurentInfo extends StatefulWidget {
  final Restaurent? curRestaurent;

  const RestaurentInfo(this.curRestaurent);

  @override
  _RestaurentInfoState createState() => _RestaurentInfoState();
}

class _RestaurentInfoState extends State<RestaurentInfo> {
  @override
  Widget build(BuildContext context) {
    Widget makeDismissible({required Widget child}) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).pop(),
          child: GestureDetector(onTap: () {}, child: child),
        );

    return makeDismissible(
      child: DraggableScrollableSheet(
        initialChildSize: 0.2,
        maxChildSize: 1,
        minChildSize: 0.1,
        builder: (_, controller) => InkWell(
          onTap: () {
            if (widget.curRestaurent!.isClaimed) return;
            Navigator.of(context).pop();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransitionScreen(),
                  settings: RouteSettings(
                    arguments: {'res': widget.curRestaurent},
                  ),
                ));
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
                      color: widget.curRestaurent!.isClaimed
                          ? Colors.red[400]
                          : Colors.green[400],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 0, 8),
                      child: Text(
                        widget.curRestaurent!.isClaimed
                            ? 'CLAIMED'
                            : 'UNCLAIMED',
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
                    '${widget.curRestaurent!.openTime} - ${widget.curRestaurent!.closeTime}\ndistance',
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
