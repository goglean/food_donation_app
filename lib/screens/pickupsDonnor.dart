import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class PickupsDonor extends StatefulWidget {
  const PickupsDonor({ Key? key }) : super(key: key);

  @override
  _PickupsDonorState createState() => _PickupsDonorState();
}

class _PickupsDonorState extends State<PickupsDonor> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          
          Container(
                    width: MediaQuery.of(context).size.width * 0.85,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
                ),
              child: Text("Add Another Donation",style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.width * 0.05,
                color: Colors.white
                )
              ,),
              onPressed: () {}),
          )
        ],
      ),
    );
  }
}