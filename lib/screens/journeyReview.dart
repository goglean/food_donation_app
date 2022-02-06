import 'package:flutter/material.dart';
import 'package:food_donating_app/screens/home.dart';
import 'package:google_fonts/google_fonts.dart';

class JourneyReview extends StatefulWidget {
  const JourneyReview({Key? key}) : super(key: key);

  @override
  _JourneyReviewState createState() => _JourneyReviewState();
}

class _JourneyReviewState extends State<JourneyReview> {
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home()));
          },
        ),
        title: Text(
          "Write a Review",
          style: GoogleFonts.roboto(color: Theme.of(context).primaryColor),
        ),
        centerTitle: true,
      ),
    );
  }
}
