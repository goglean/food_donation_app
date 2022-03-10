import 'package:flutter/material.dart';
import 'package:food_donating_app/screens/contactUs.dart';
import 'package:food_donating_app/screens/faq.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpPageDonor extends StatefulWidget {
  const HelpPageDonor({Key? key}) : super(key: key);

  @override
  _HelpPageDonorState createState() => _HelpPageDonorState();
}

class _HelpPageDonorState extends State<HelpPageDonor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          // SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Image.asset(
              'assets/GG_Logo_without_bg.png',
              width: MediaQuery.of(context).size.height * 0.2,
              height: MediaQuery.of(context).size.width * 0.45,
              fit: BoxFit.cover,
            )
              ],
            ),
          ),
          //SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.08,
                //color: Colors.red,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "How can we help you?",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    "Please choose an option below",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      color: Colors.black,
                    ),
                  ),
                ])),
          ),
          //SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.1,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                  //elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.white)),
                  color: Colors.white,
                  onPressed: () => setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContactUs()));
                      }),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.call,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Contact Us",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                  ])),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.1,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                  // elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.white)),
                  color: Colors.white,
                  onPressed: () => setState(() {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => FaqPage()));
                      }),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.help,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "FAQ",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                  ])),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              //height: MediaQuery.of(context).size.height * 0.1,
              child: Text(
                "Do you want to...",
                textAlign: TextAlign.left,
                style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.1,
            padding: EdgeInsets.all(10),
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Theme.of(context).primaryColor)),
                color: Theme.of(context).primaryColor,
                onPressed: () => setState(() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ContactUs()));
                    }),
                child: Row(children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Icon(
                        Icons.lightbulb_outline,
                        color: Colors.white,
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Center(
                      child: Text(
                        "Recomend a store to us you think should join Go Glean",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: MediaQuery.of(context).size.width * 0.04),
                      ),
                    ),
                  ),
                ])),
          )
        ],
      ),
    );
  }
}
