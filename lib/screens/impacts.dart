import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Imapcts extends StatefulWidget {
  const Imapcts({Key? key}) : super(key: key);

  @override
  _ImapctsState createState() => _ImapctsState();
}

class _ImapctsState extends State<Imapcts> {
  int _pickups = 0;
  int _unit = 0;
  int _food = 0;
  int _meals = 0;
  int _co2 = 0;
  int _donors = 0;
  int _volunteers = 0;
  int _charity = 0;

  void _getPickups() async {
    FirebaseFirestore.instance
        .collection("pickup_details")
        .get()
        .then((QuerySnapshot querySnapshot) {
      _pickups = querySnapshot.docs.length;
      //print(_pickups);
    });

    FirebaseFirestore.instance
        .collection("old_pickups")
        .get()
        .then((QuerySnapshot querySnapshot) {
      _pickups = _pickups + querySnapshot.docs.length;
      //print(_pickups);
    });

    print(_pickups);
  }

  void _getVolunteers() async {
    FirebaseFirestore.instance
        .collection("volunteers")
        .get()
        .then((QuerySnapshot querySnapshot) {
      _volunteers = querySnapshot.docs.length;
      //print(_pickups);
    });

    print(_volunteers);
  }

  void _getdonors() async {
    FirebaseFirestore.instance
        .collection("donors")
        .get()
        .then((QuerySnapshot querySnapshot) {
      _donors = querySnapshot.docs.length;
      //print(_pickups);
    });

    print(_donors);
  }

  void _getcharity() async {
    FirebaseFirestore.instance
        .collection("charity")
        .get()
        .then((QuerySnapshot querySnapshot) {
      _charity = querySnapshot.docs.length;
      //print(_pickups);
    });

    print(_charity);
  }

  void _getunits() async {
    FirebaseFirestore.instance
        .collection('utils')
        .doc('stats')
        .get()
        .then((value) {
      _food = int.parse(value.data()!['Box'].toString()) * 25 +
          int.parse(value.data()!['Case'].toString()) * 15 +
          int.parse(value.data()!['Crate'].toString()) * 18 +
          int.parse(value.data()!['Large Bag'].toString()) * 16 +
          int.parse(value.data()!['Small Bag'].toString()) * 10 +
          int.parse(value.data()!['Tray'].toString()) * 9;

      _meals = (1.2 * _food).toInt();
      _co2 = (0.543 * _food).toInt();
    });
    print(_unit);
  }

  void initState() {
    super.initState();
    _getPickups();
    _getVolunteers();
    _getdonors();
    _getunits();
    _getcharity();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Our Imapct"),
        ),
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.red[400]),
                    child: ListTile(
                      leading: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.005,
                      ),
                      title: Text(
                        "$_pickups",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w700,
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                            color: Colors.white),
                      ),
                      subtitle: Text(
                        "Food pickups",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.orange[400]),
                    child: ListTile(
                      leading: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.005,
                      ),
                      title: Text(
                        "$_food",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w700,
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                            color: Colors.white),
                      ),
                      subtitle: Text(
                        "Pounds of Food",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.lime[300]),
                    child: ListTile(
                      leading: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.005,
                      ),
                      title: Text(
                        "$_meals",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w700,
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                            color: Colors.white),
                      ),
                      subtitle: Text(
                        "Meals",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.green[300]),
                    child: ListTile(
                      leading: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.005,
                      ),
                      title: Text(
                        "$_co2",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w700,
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                            color: Colors.white),
                      ),
                      subtitle: Text(
                        "Pounds of CO2 prevented",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue[400]),
                    child: ListTile(
                      leading: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.005,
                      ),
                      title: Text(
                        "$_volunteers",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w700,
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                            color: Colors.white),
                      ),
                      subtitle: Text(
                        "Number of Volunteer",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.purple[400]),
                    child: ListTile(
                      leading: SizedBox(
                        width: 10,
                      ),
                      title: Text(
                        "$_donors",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w700,
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                            color: Colors.white),
                      ),
                      subtitle: Text(
                        "Number of donors",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.pink[400]),
                    child: ListTile(
                      leading: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.005,
                      ),
                      title: Text(
                        "$_charity",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w700,
                            fontSize: MediaQuery.of(context).size.height * 0.04,
                            color: Colors.white),
                      ),
                      subtitle: Text(
                        "Number of charity",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
