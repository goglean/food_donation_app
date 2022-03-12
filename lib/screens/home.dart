import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_donating_app/screens/contactUsVolunteer.dart';
import 'package:food_donating_app/screens/impacts.dart';
import 'package:food_donating_app/screens/myPickups.dart';
import 'package:food_donating_app/screens/profileVolunteer.dart';
import 'package:food_donating_app/widget/map.dart';
import 'package:food_donating_app/widget/restaurent_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _userName = "";
  TextEditingController _controller = TextEditingController();

  Future<void> _getUserName() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc((FirebaseAuth.instance.currentUser)?.email)
        .get()
        .then((value) {
      setState(() {
        _userName = value.data()!['Name'].toString();
        _userName = _userName.toUpperCase();
        print('${_userName[0]}');
      });
    });
  }

  void initState() {
    super.initState();
    _getUserName();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Home"),
        centerTitle: true,
      ),
      body: MapSample(),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                          MediaQuery.of(context).size.width * 0.1),
                      bottomRight: Radius.circular(
                          MediaQuery.of(context).size.width * 0.1))),
              child: Container(
                //color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      radius: 50,
                      child: Text(
                        '${_userName[0]}',
                        style: GoogleFonts.roboto(
                            fontSize: MediaQuery.of(context).size.width * 0.1,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                            wordSpacing: 5),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "$_userName ",
                          style: GoogleFonts.roboto(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                              wordSpacing: 5),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: Text(
                'Profile',
                style: GoogleFonts.roboto(
                    fontSize: 18, letterSpacing: 1, wordSpacing: 5),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileVolunteer()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.add_circle_outline,
              ),
              title: Text(
                'My Pickups',
                style: GoogleFonts.roboto(
                    fontSize: 18, letterSpacing: 1, wordSpacing: 5),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPickups()),
                );
                Provider.of<DirectionLines>(context, listen: false).resPos =
                    null;
              },
            ),
            ListTile(
              leading: Icon(Icons.auto_graph),
              title: Text(
                'Impacts',
                style: GoogleFonts.roboto(
                    fontSize: 18, letterSpacing: 1, wordSpacing: 5),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Imapcts()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.help_center,
              ),
              title: Text(
                'Contact Us',
                style: GoogleFonts.roboto(
                    fontSize: 18, letterSpacing: 1, wordSpacing: 5),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactUsVolunteer()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'Logout',
                style: GoogleFonts.roboto(
                    fontSize: 18, letterSpacing: 1, wordSpacing: 5),
              ),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          content: Text("Are you sure to logout?"),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      //Navigator.pop(context);
                                    },
                                    child: Text(
                                      "NO",
                                      style: GoogleFonts.roboto(
                                          color:
                                              Theme.of(context).primaryColor),
                                    )),
                                TextButton(
                                    onPressed: () async {
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.pop(context);
                                      //Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Yes",
                                      style: GoogleFonts.roboto(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ))
                              ],
                            )
                          ],
                        ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
