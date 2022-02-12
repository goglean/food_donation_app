import 'package:flutter/material.dart';

class NearbyRestaurantInfo extends StatelessWidget {
  String dialogueText;
  NearbyRestaurantInfo({this.dialogueText = 'Sorry, no nearby Restaurants'});
  double padding = 3;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 30,
            ),
          ),
          Expanded(
            child: Container(
              child: Text(
                dialogueText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
