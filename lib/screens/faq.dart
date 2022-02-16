import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final Stream<QuerySnapshot> _collegesstream =
      FirebaseFirestore.instance.collection('FAQ').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Help Center"),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _collegesstream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(18),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'FAQs',
                          style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                  Expanded(
                    child: ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: ListTile(
                              title: Text(
                                "Q.) " + data['Question'],
                                style: TextStyle(color: Colors.black),
                              ),
                              subtitle: Text(
                                "A.) " + data['Answer'],
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          )
                        ],
                      );
                    }).toList()),
                  ),
                ],
              );
            }));
  }
}
