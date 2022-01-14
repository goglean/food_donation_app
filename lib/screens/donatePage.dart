import 'package:flutter/material.dart';
import 'package:food_donating_app/screens/donateItemsPage.dart';

import 'package:google_fonts/google_fonts.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({Key? key}) : super(key: key);

  @override
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: MediaQuery.of(context).size.width * 0.1),
              Container(
                //color: Colors.black,
                height: MediaQuery.of(context).size.height * 0.06,
                child: Text(
                  "Welcome!",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w800,
                    fontSize: MediaQuery.of(context).size.height * 0.05,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.45,
                color: Colors.grey[400],
              )
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.25,
              //color: Colors.red,
              child: Text(
                "By donating food, we are not feeding people, not landfills, supporting local communities, and saving all the resourcess that went into producing that food from going to waste. \n\n To make donation you will need to list specific details of what you have available to be rescued.",
                textAlign: TextAlign.left,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                  color: Colors.black,
                ),
              )),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.06,
            //color: Colors.red,
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Theme.of(context).primaryColor)),
                color: Theme.of(context).primaryColor,
                onPressed: () => setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DonateItemPage()));
                    }),
                child: Text(
                  "Get Started",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.height * 0.04),
                )),
          )
        ],
      ),
    );
  }
}
