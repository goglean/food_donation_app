import 'package:cloud_firestore/cloud_firestore.dart';
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
  donationtypes() {
    if (_donationType == "Upcoming") {
      return upcomingdonations();
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
            child: Column(
              children: [
                  donationtypes(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  }

class upcomingdonations extends StatefulWidget {
  const upcomingdonations({ Key? key }) : super(key: key);

  @override
  _upcomingdonationsState createState() => _upcomingdonationsState();
}

class _upcomingdonationsState extends State<upcomingdonations> {
  final Stream<QuerySnapshot> _upcomingstream =
      FirebaseFirestore.instance.collection('pickup_details').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _upcomingstream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
        return Padding(
          padding: const EdgeInsets.fromLTRB(4,20,4,20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child : Container(
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
            )
          ),
        );
      }
    );
  }
}

class historydonations extends StatefulWidget {
  const historydonations({ Key? key }) : super(key: key);

  @override
  _historydonationsState createState() => _historydonationsState();
}

class _historydonationsState extends State<historydonations> {
   final Stream<QuerySnapshot> _upcomingstream =
      FirebaseFirestore.instance.collection('pickup_details').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _upcomingstream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
        
        return Padding(
          padding: const EdgeInsets.fromLTRB(4,20,4,20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child : Container(
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
            )
          ),
        );
      }
    );
  }
}