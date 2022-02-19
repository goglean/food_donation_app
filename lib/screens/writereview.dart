import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_donating_app/screens/home.dart';
import 'package:food_donating_app/widget/internet_service.dart';
import 'package:food_donating_app/widget/noInternetScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class WriteReview extends StatefulWidget {
  Map curChar, curRes;
  List<String> curPickupDocId;
  WriteReview(
      {required this.curChar,
      required this.curRes,
      required this.curPickupDocId});

  @override
  State<WriteReview> createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();
  String ratingStar = '3';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Write a Review",
          style: GoogleFonts.roboto(color: Theme.of(context).primaryColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                onChanged: (val) {
                  print(_nameController.text.toString());
                },
                decoration: new InputDecoration(
                  // focusedBorder: OutlineInputBorder(
                  //   borderSide: BorderSide(color: Colors.black54, width: 2),
                  //   borderRadius: BorderRadius.circular(15),
                  // ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: 'Full Name',
                ),
              ),
              SizedBox(height: 20),
              Text(
                'How was your volunteering experience?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 12),
              Center(
                child: RatingBar(
                  itemSize: MediaQuery.of(context).size.height * 0.07,
                  initialRating: 0,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  ratingWidget: RatingWidget(
                    empty: Icon(Icons.star_border_outlined),
                    full: Icon(
                      Icons.star,
                      color: Colors.orange[700],
                    ),
                    half: Icon(Icons.star_border_outlined),
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                    ratingStar = rating.toString();
                  },
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Go Glean values the time, effort, and energy of our doctros, charities, and volunteers.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'We strive to continuously improve, so please share your thoughts on your experience.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 24),
              TextField(
                controller: _reviewController,
                // onChanged: (val) {
                //   print(_nameController.text.toString());
                // },
                decoration: InputDecoration(
                  // focusedBorder: OutlineInputBorder(
                  //   borderSide: BorderSide(color: Colors.black54, width: 2),
                  //   borderRadius: BorderRadius.circular(15),
                  // ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54, width: 3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // labelText: 'Enter your review here',
                  hintText: 'Enter your review here',
                ),
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                // minLines: 10,
                textAlignVertical: TextAlignVertical.top,
                // expands: true,
                maxLines: 10,
              ),
              SizedBox(height: 15),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Theme.of(context).primaryColor,
                ),
                child: FlatButton(
                  onPressed: () async {
                    bool connected =
                        await InternetService().checkInternetConnection();
                    if (!connected) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoInternetScreen(),
                        ),
                      );
                      return;
                    }

                    final CollectionReference oldPickups =
                        FirebaseFirestore.instance.collection('old_pickups');
                    // oldPickups.doc(widget.curPickupDocId).update({
                    for (int i = 0; i < widget.curPickupDocId.length; i++) {
                      oldPickups.doc(widget.curPickupDocId[i]).update({
                        "Reviewer Name": _nameController.text.toString(),
                        "Review": _reviewController.text.toString(),
                        "Rating": ratingStar,
                      });
                    }

                    Navigator.pop(context);
                  },
                  textColor: Colors.white,
                  child: Text(
                    'NEXT',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
                textColor: Theme.of(context).primaryColor,
                child: Text('NO, THANK YOU'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
