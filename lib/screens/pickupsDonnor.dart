import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_donating_app/screens/donateItemsPage.dart';
import 'package:google_fonts/google_fonts.dart';
class PickupsDonor extends StatefulWidget {
  const PickupsDonor({ Key? key }) : super(key: key);

  @override
  _PickupsDonorState createState() => _PickupsDonorState();
}

class _PickupsDonorState extends State<PickupsDonor> {
  String _donationType = "Upcoming";
  bool pressAttention = true;
  bool press = false;
  void refresh() {
    setState(() {});
  }
  donationtypes() {
    if (_donationType == "Upcoming") {
      return upcomingdonations(
        callback: refresh,
      );
    } else {
      return historydonations();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height *0.05,
        ),
        Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                                          _donationType = "Upcoming";
                                        }),
                                    child: Text(
                                      "Upcoming",
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
                              SizedBox(
                                width : MediaQuery.of(context).size.width * 0.01
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
                                          _donationType = "History";
                                        }),
                                    child: Text(
                                      "History",
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
        SingleChildScrollView(
          child: Container(
                            width: MediaQuery.of(context).size.width * 0.90,
            child: donationtypes()
          ),
        ),
      ],
    );
  }

  }

class upcomingdonations extends StatefulWidget {
  VoidCallback callback;
  upcomingdonations({
    required this.callback
  });
  @override
  _upcomingdonationsState createState() => _upcomingdonationsState();
}

class _upcomingdonationsState extends State<upcomingdonations> {
  List upcominglist = [];
  List starttimeslist = [];
  List endtimeslist = [];
  List startdateslist = [];
  List enddateslist = [];
  List detailslist = [];
  
  void upcomlist() {
  FirebaseFirestore.instance.collection("pickup_details").get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      if (result['email'] == FirebaseAuth.instance.currentUser?.email && result['Status'] == "upcoming") {
        upcominglist.add(result.data());
        starttimeslist.add(result.data()['starttime'].toString());
        startdateslist.add(result.data()['startdate'].toString());
        endtimeslist.add(result.data()['endtime'].toString());
        enddateslist.add(result.data()['enddate'].toString());
        detailslist.add(result.data()['details'].toString());
      }
    });
  });
}
  @override
  void initState() {
    super.initState();
    upcomlist();
  }
  
  @override
  Widget build(BuildContext context) {
    if (upcominglist.length == 0) {
      return Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          children: [
                            Text("There are no added donations to be picked up.", 
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w400
                            ),),
                            Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,10,0,0),
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
                        onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DonateItemPage()))),
                    ),
                  )
                          ],
                        ),
                      ),
            );
    }
    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: upcominglist.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            startdateslist[index] + " " + starttimeslist[index] + " - " + enddateslist[index] + " " + endtimeslist[index],
                                            style: GoogleFonts.roboto(
                                              decoration: TextDecoration.underline,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700
                                            )
                                          ),
                                          SizedBox(height: 24),
                                          Text(
                                            "Our pick-up details for the volunteer",
                                            style: GoogleFonts.roboto(
                                              decoration: TextDecoration.underline,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600
                                            )
                                          ),
                                          SizedBox(height: 8,),
                                          Text(
                                            detailslist[index],
                                            style: GoogleFonts.roboto(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400
                                            )
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16)
                          ],
                        );
                      },
                    );
      }
}

class historydonations extends StatefulWidget {
  const historydonations({ Key? key }) : super(key: key);

  @override
  _historydonationsState createState() => _historydonationsState();
}

class _historydonationsState extends State<historydonations> {
  List historylist = [];
  List starttimeslist = [];
  List endtimeslist = [];
  List startdateslist = [];
  List enddateslist = [];
  List detailslist = [];
  
  void upcomlist() {
  FirebaseFirestore.instance.collection("pickup_details").get().then((querySnapshot) {
    querySnapshot.docs.forEach((result) {
      if (result['email'] == FirebaseAuth.instance.currentUser?.email && result['Status'] == "claimed") {
        historylist.add(result.data());
        starttimeslist.add(result.data()['starttime'].toString());
        startdateslist.add(result.data()['startdate'].toString());
        endtimeslist.add(result.data()['endtime'].toString());
        enddateslist.add(result.data()['enddate'].toString());
        detailslist.add(result.data()['details'].toString());
      }
    });
  });
}
  @override
  void initState() {
    super.initState();
    upcomlist();
  }
  
  @override
  Widget build(BuildContext context) {
    if (historylist.length == 0) {
      return Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          children: [
                            Text("There are no added donations to be picked up.", 
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w400
                            ),),
                            Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,10,0,0),
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
                        onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DonateItemPage()))),
                    ),
                  )
                          ],
                        ),
                      ),
            );
    }
    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: historylist.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            startdateslist[index] + " " + starttimeslist[index] + " - " + enddateslist[index] + " " + endtimeslist[index],
                                            style: GoogleFonts.roboto(
                                              decoration: TextDecoration.underline,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700
                                            )
                                          ),
                                          SizedBox(height: 24),
                                          Text(
                                            "Our pick-up details for the volunteer",
                                            style: GoogleFonts.roboto(
                                              decoration: TextDecoration.underline,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600
                                            )
                                          ),
                                          SizedBox(height: 8,),
                                          Text(
                                            detailslist[index],
                                            style: GoogleFonts.roboto(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400
                                            )
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16)
                          ],
                        );
                      },
                    );
      }
}