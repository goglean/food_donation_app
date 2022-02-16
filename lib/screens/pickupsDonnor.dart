import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_donating_app/screens/donateitems.dart';
import 'package:google_fonts/google_fonts.dart';

class PickupsDonor extends StatefulWidget {
  const PickupsDonor({Key? key}) : super(key: key);

  @override
  _PickupsDonorState createState() => _PickupsDonorState();
}

class _PickupsDonorState extends State<PickupsDonor> {
  var curemail = FirebaseAuth.instance.currentUser?.email.toString();
  String _donationtype = "Upcoming";
  bool pressAttention = true;
  bool press = false;
  int num = 0;
  var discriptlist = [];
  var quantilist = [];
  var unitslist = [];
  final Stream<QuerySnapshot> _mydonationsstream =
      FirebaseFirestore.instance.collection('pickup_details').snapshots();
  final Stream<QuerySnapshot> _donationhistorystream =
      FirebaseFirestore.instance.collection('old_pickups').snapshots();
  donationtypes() {
    if (_donationtype == "Upcoming") {
      return upcoming();
    } else {
      return historystre();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Theme.of(context).primaryColor)),
                  color: pressAttention
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).scaffoldBackgroundColor,
                  onPressed: () => setState(() {
                        pressAttention = !pressAttention;
                        press = !press;
                        _donationtype = "Upcoming";
                      }),
                  child: Text(
                    "Upcoming",
                    style: GoogleFonts.roboto(
                        color: pressAttention ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: MediaQuery.of(context).size.height * 0.02),
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Theme.of(context).primaryColor)),
                  color: press
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).scaffoldBackgroundColor,
                  onPressed: () => setState(() {
                        press = !press;
                        pressAttention = !pressAttention;
                        _donationtype = "History";
                      }),
                  child: Text(
                    "History",
                    style: GoogleFonts.roboto(
                        color: press ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: MediaQuery.of(context).size.height * 0.02),
                  )),
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Expanded(
          child: donationtypes(),
        ),
        RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(color: Theme.of(context).primaryColor)),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => donateitems()));
            },
            child: Text(
              "Add a donation",
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: MediaQuery.of(context).size.height * 0.03),
            )),
      ],
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> upcoming() {
    return StreamBuilder<QuerySnapshot>(
        stream: _mydonationsstream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // if (num == 0) {
          //         return Text('No Data');
          // }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              status() {
                if (data['Status'] == 'upcoming') {
                  return Text('Yet to be picked');
                } else
                  return data['Status'];
              }

              if (data['email'] == curemail) {
                discriptlist = data['descriptionlist'];
                quantilist = data['quantitylist'];
                unitslist = data['unitlist'];
                return Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.fromLTRB(3, 3, 1, 1),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 2)),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['startdate'] +
                              " " +
                              data['starttime'] +
                              " - " +
                              data['enddate'] +
                              " " +
                              data['endtime'],
                          style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        for (int i = 0; i < unitslist.length; i++)
                          Text(
                            quantilist[i] +
                                " " +
                                unitslist[i] +
                                " " +
                                discriptlist[i],
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColor),
                          ),
                        SizedBox(height: 16),
                        Text(
                          "Our pick-up details for the volunteer",
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                          child: Text(
                            data['details'],
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          showDialog<String>(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Delete donation'),
                              content: const Text(
                                  'Do you wish to cancel the donation?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('pickup_details')
                                        .doc(document.id)
                                        .delete();
                                    Navigator.pop(context, 'Yes');
                                  },
                                  child: const Text('Yes'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, 'No');
                                  },
                                  child: const Text('No'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).primaryColor,
                        )),
                  ),
                );
              }
              return Container();
            }).toList(),
          );
        });
  }

  StreamBuilder<QuerySnapshot<Object?>> historystre() {
    return StreamBuilder<QuerySnapshot>(
        stream: _donationhistorystream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              if (data['email'] == curemail) {
                return Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.fromLTRB(3, 3, 1, 1),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 2)),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['startdate'] +
                              " " +
                              data['starttime'] +
                              " - " +
                              data['enddate'] +
                              " " +
                              data['endtime'],
                          style: GoogleFonts.roboto(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        for (int i = 0; i < unitslist.length; i++)
                          Text(
                            quantilist[0] +
                                " " +
                                unitslist[0] +
                                " " +
                                discriptlist[0],
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).primaryColor),
                          ),
                        SizedBox(height: 16),
                        Text(
                          "Our pick-up details for the volunteer",
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                          child: Text(
                            data['details'],
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            }).toList(),
          );
        });
  }
}
