import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donating_app/screens/donateitems.dart';
import 'package:google_fonts/google_fonts.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({Key? key}) : super(key: key);
  @override
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  var curemail = FirebaseAuth.instance.currentUser?.email.toString();
  final Stream<QuerySnapshot> _mydonationsstream =
      FirebaseFirestore.instance.collection('pickup_details').snapshots();
  var noofdon = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              Image.asset(
              'assets/GG_Logo_without_bg.png',
              width: MediaQuery.of(context).size.height * 0.2,
              height: MediaQuery.of(context).size.width * 0.45,
              fit: BoxFit.cover,
            )
              // Container(
              //   height: MediaQuery.of(context).size.height * 0.2,
              //   width: MediaQuery.of(context).size.width * 0.45,
              //   color: Colors.grey[400],
              // )
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.30,
              //color: Colors.red,
              child: SingleChildScrollView(
                child: Text(
                  "By donating food, we are not feeding people, not landfills, supporting local communities, and saving all the resourcess that went into producing that food from going to waste. \n\n To make donation you will need to list specific details of what you have available to be rescued.",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                    color: Colors.black,
                  ),
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
                      if(noofdon == 0){Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => donateitems()));}
                      else{
                        Fluttertoast.showToast(msg: 'You already have an existing donation');
                      }
                    }),
                child: Text(
                  "Get Started",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.height * 0.04),
                )),
          ),
          Container(
            height: 0,
            child: historystre(),
          )
        ],
      ),
    );
  }
  StreamBuilder<QuerySnapshot<Object?>> historystre() {
    return StreamBuilder<QuerySnapshot>(
        stream: _mydonationsstream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ));
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              noofdon = 0;
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              
              if (data['email'] == curemail) {
                noofdon++;
              }
              return Container();
            }).toList(),
          );
        });
  }
}