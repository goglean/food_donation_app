import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class WriteReview extends StatefulWidget {
  const WriteReview({Key? key}) : super(key: key);

  @override
  State<WriteReview> createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write a Review'),
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
                  itemSize: 64,
                  initialRating: 3,
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
                  onPressed: () {},
                  textColor: Colors.white,
                  child: Text(
                    'NEXT',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {},
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
