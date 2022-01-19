import 'package:flutter/material.dart';
import 'package:food_donating_app/screens/login.dart';
import 'package:food_donating_app/screens/signupDonor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:food_donating_app/screens/signupVolunteer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:food_donating_app/resources/string.dart' as Resources;
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'loginpage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String _userType = "volunteer";
  bool pressAttention = true;
  bool press = false;
    void mailLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print('Could not launch $command');
    }
  }
  final Uri params = Uri(
  scheme: 'mailto',
  path: 'prajeeth347@gmail.com',
);
void test() async{
var url = params.toString();
if (await canLaunch(url)) {
  await launch(url);
} else {
  throw 'Could not launch $url';
}}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  //color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: Colors.black),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: Text(
                                "Go Glean",
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.05,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                "Diverting excess food to hungry people",
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w500,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.02),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.01,
                // ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Text(
                    "Go Glean is a registered nonprofit that provides a web based \" marketplace \" allowing excess food to be donated from the food to be donated from the food service industry to qualified charities that work with the needy.",
                    style: GoogleFonts.roboto(
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.005,
                // ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        // color: Colors.blue,
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.03,
                        child: Text(
                          "know more about Go Glean >>",
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w800,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.03,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.email),
                              onPressed: () {
                                
                                test();
                               // setState(() {});
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.facebook),
                              onPressed: () async{
                                var url = "https://www.instagram.com/p/CTjjmI3j91k1Ke-ahvLOQWjdMYzoO0mpDEaIHw0/?utm_medium=copy_link";

if (await canLaunch(url)) {
  await launch(
    url,
    universalLinksOnly: true,
  );
} else {
  throw 'There was a problem to open the url: $url';
}
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.brightness_1),
                              onPressed: () async {
                                const url = Resources.WEBSITE_NAME;
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            //color: Colors.red,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.4,
              //color: Colors.black,
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Center(
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(
                                        color: Theme.of(context).primaryColor)),
                                color: pressAttention
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).scaffoldBackgroundColor,
                                onPressed: () => setState(() {
                                      pressAttention = !pressAttention;
                                      press = !press;
                                      _userType = "volunteer";
                                    }),
                                child: Text(
                                  "Volunteer",
                                  style: GoogleFonts.roboto(
                                      color: pressAttention
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                )),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(
                                        color: Theme.of(context).primaryColor)),
                                color: press
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).scaffoldBackgroundColor,
                                onPressed: () => setState(() {
                                      press = !press;
                                      pressAttention = !pressAttention;
                                      _userType = "donor";
                                    }),
                                child: Text(
                                  "Donor",
                                  style: GoogleFonts.roboto(
                                      color:
                                          press ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          color: Theme.of(context).primaryColor,
                          onPressed: () => setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => signinpage()));
                              }),
                          child: Text(
                            "LOGIN",
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor)),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          onPressed: () => setState(() {
                                if (_userType == "volunteer") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SignupVolunteer()));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignupDonor()));
                                }
                              }),
                          child: Text(
                            "SIGN UP",
                            style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02),
                          )),
                    ),
                  )
                ],
              )),
        ],
      )),
    );
  }
}
