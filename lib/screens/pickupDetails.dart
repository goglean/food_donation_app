import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PickupDetails extends StatefulWidget {
  const PickupDetails({Key? key}) : super(key: key);

  @override
  _PickupDetailsState createState() => _PickupDetailsState();
}

class _PickupDetailsState extends State<PickupDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Step 2: Pickup details",
          style: GoogleFonts.roboto(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
