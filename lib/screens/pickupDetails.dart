import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:food_donating_app/screens/finishPickupdetails.dart';
import 'package:google_fonts/google_fonts.dart';

class PickupDetails extends StatefulWidget {
  List quanlist;
  List desclist;
  List Unilist;
  PickupDetails({
    required this.Unilist,
    required this.desclist,
    required this.quanlist
  });

  @override
  _PickupDetailsState createState() => _PickupDetailsState();
}

class _PickupDetailsState extends State<PickupDetails> {
  String _selecteddetails = "";
  String location = "";
  String startdate = DateTime.now().toString();
  String enddate = DateTime.now().toString();
  String starttime = DateTime.now().hour.toString() +
                              ":" +
                              DateTime.now().minute.toString();
  String endtime = DateTime.now().hour.toString() +
                              ":" +
                              DateTime.now().minute.toString();
  String pickup = "";
  String lat = "";
  String long = "";
  String resname = "";
  String address = "";
  String phoneno = "";
  String contactperson = "";
  String city = "";
  void fetchdetails() {
    FirebaseFirestore.instance
                  .collection('users')
                  .doc((FirebaseAuth.instance.currentUser)?.uid)
                  .get()
                  .then((value) {
                    if (value.data()!['email'] == FirebaseAuth.instance.currentUser!.email) {
                    resname = value.data()!['Name'].toString();
                    address = value.data()!['Address'].toString();
                    phoneno = value.data()!['Phone Number'].toString();
                    contactperson = value.data()!['Contact Person'].toString();
                    city = value.data()!['City'].toString(); 
                    }
                  });
  }
  final myController = TextEditingController();
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Location",
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                cursorColor: Theme.of(context).primaryColor,
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Pick-Up Details",
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            ListTile(
              leading: Radio<String>(
                activeColor: Theme.of(context).primaryColor,
                value: 'Single Date',
                groupValue: _selecteddetails,
                onChanged: (value) {
                  setState(() {
                    _selecteddetails = value!;
                  });
                },
              ),
              title: const Text('Single Date'),
            ),
            ListTile(
              leading: Radio<String>(
                activeColor: Theme.of(context).primaryColor,
                value: 'Date Range',
                groupValue: _selecteddetails,
                onChanged: (value) {
                  setState(() {
                    _selecteddetails = value!;
                  });
                },
              ),
              title: const Text('Date Range'),
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      "Start Date",
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                        width: 130,
                        child: DateTimePicker(
                          type: DateTimePickerType.date,
                          dateMask: 'd MMM, yyyy',
                          initialValue: DateTime.now().toString(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          icon: Icon(Icons.event),
                          dateLabelText: 'Date',
                          timeLabelText: "Time",
                          selectableDayPredicate: (date) {
                            if (date.weekday == 6 || date.weekday == 7) {
                              return false;
                            }

                            return true;
                          },
                          onChanged: (val) {
                            print(val);
                            startdate = val;
                          },
                          validator: (val) {
                            print(val);
                            return null;
                          },
                          onSaved: (val) => print(val),
                        )),
                  ],
                ),
                Padding(padding: EdgeInsets.all(20)),
                Column(
                  children: [
                    Text(
                      "End Date",
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                        width: 130,
                        child: DateTimePicker(
                          type: DateTimePickerType.date,
                          dateMask: 'd MMM, yyyy',
                          initialValue: DateTime.now().toString(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          icon: Icon(Icons.event),
                          dateLabelText: 'Date',
                          timeLabelText: "Time",
                          selectableDayPredicate: (date) {
                            if (date.weekday == 6 || date.weekday == 7) {
                              return false;
                            }
                            return true;
                          },
                          onChanged: (val) {
                            print(val);
                            enddate = val;
                          },
                          validator: (val) {
                            print(val);
                            return null;
                          },
                          onSaved: (val) => print(val),
                        )),
                  ],
                )
              ],
            ),
            Padding(padding: EdgeInsets.all(20)),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      "Start Time",
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                        width: 130,
                        child: DateTimePicker(
                          initialValue: DateTime.now().hour.toString() +
                              ":" +
                              DateTime.now().minute.toString(),
                          type: DateTimePickerType.time,
                          icon: Icon(Icons.timer),
                          onChanged: (val) {
                            print(val);
                            starttime = val;
                          },
                          validator: (val) {
                            print(val);
                            return null;
                          },
                          onSaved: (val) => print(val),
                        )),
                  ],
                ),
                Padding(padding: EdgeInsets.all(20)),
                Column(
                  children: [
                    Text(
                      "End Time",
                      style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                        width: 130,
                        child: DateTimePicker(
                          initialValue: DateTime.now().hour.toString() +
                              ":" +
                              DateTime.now().minute.toString(),
                          type: DateTimePickerType.time,
                          icon: Icon(Icons.timer),
                          onChanged: (val) {
                            print(val);
                            endtime = val;
                          },
                          validator: (val) {
                            print(val);
                            return null;
                          },
                          onSaved: (val) => print(val),
                        )),
                  ],
                )
              ],
            ),
            Padding(padding: EdgeInsets.all(10)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Pick-Up(Optional)",
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Include clear details that will help you and the volunteers have a successful pick-up",
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    color: Colors.black),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                  cursorColor: Theme.of(context).primaryColor,
                  controller: myController,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                  keyboardType: TextInputType.multiline,
                  minLines: 7,
                  maxLines: 10),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Organization",
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "This Donation will be sent to any registered non-profit in the area.",
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    color: Colors.black),
              ),
            ),
          ],
        )),
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.06,
        child: MaterialButton(
          height: 40.0,
          minWidth: double.infinity,
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          child: new Text(
            "Finish",
            style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.width * 0.07,
                color: Colors.white),
          ),
          onPressed: () async {
            fetchdetails();
            Timer(Duration(seconds: 3), () {
         FirebaseFirestore.instance
                .collection("pickup_details")
                .doc(DateTime.now().toString())
                .set({
              "days": _selecteddetails,
              "details": myController.text,
              "enddate": enddate,
              "endtime": endtime,
              "startdate": startdate,
              "starttime": starttime,
              "quantitylist" : widget.quanlist.toList(),
              "descriptionlist" : widget.desclist.toList(),
              "unitlist" : widget.Unilist.toList(),
              "Restaurant Name" : resname,
              "Address" : address,
              "Phone Number" : phoneno,
              "Contact Person" : contactperson,
              "City" : city,
              "Status" : "donated"
            });
            //print(_selecteddetails + " " + startdate + " " + enddate + " " + starttime + " " + endtime + " " + lat + " " + long + myController.text);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FinishPickupDetails()));
            widget.quanlist.clear();
            widget.desclist.clear();
            widget.Unilist.clear();
});
          },
          splashColor: Colors.redAccent,
        ),
      ),
    );
  }
}
