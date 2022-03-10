import 'package:flutter/material.dart';
import 'package:food_donating_app/screens/donatePage.dart';
import 'package:food_donating_app/screens/home.dart';
import 'package:food_donating_app/screens/homeDonor.dart';
import 'package:food_donating_app/screens/journeyReview.dart';
import 'package:food_donating_app/screens/writereview.dart';
import 'package:google_fonts/google_fonts.dart';

class JourneyFinished extends StatefulWidget {
  Map? curChar, curRes;
  List<String>? curPickupDocId;
  JourneyFinished({this.curChar, this.curRes, this.curPickupDocId});

  @override
  _JourneyFinishedState createState() => _JourneyFinishedState();
}

class _JourneyFinishedState extends State<JourneyFinished> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //foregroundColor: Colors.white,
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: Colors.black,
        //   ),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        title: Text(
          "Finished!",
          style: GoogleFonts.roboto(color: Theme.of(context).primaryColor),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Text("CONGRATULATIONS!",
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.08,
                        color: Colors.white)),
              ),
              Container(
                child: Image.asset('assets/app_logo.png'),
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.2,
                // color: Colors.grey,
                margin: EdgeInsets.all(20),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Text(
                  "Thank you for coming together to fight hunger by eliminating waste.",
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w400,
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.06,
                //color: Colors.red,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Theme.of(context).primaryColor)),
                  color: Colors.white,
                  onPressed: () => setState(
                    () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WriteReview(
                            curChar: widget.curChar ?? Map(),
                            curRes: widget.curRes ?? Map(),
                            curPickupDocId: widget.curPickupDocId ?? [],
                          ),
                        ),
                      );
                    },
                  ),
                  child: Text(
                    "Close",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.roboto(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w400,
                        fontSize: MediaQuery.of(context).size.height * 0.03),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
