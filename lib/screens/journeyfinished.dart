import 'package:flutter/material.dart';
import 'package:food_donating_app/screens/writereview.dart';

class JourneyFinished extends StatelessWidget {
  Map curChar, curRes;
  JourneyFinished({required this.curChar, required this.curRes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finished'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text(
            curChar['name'],
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WriteReview(),
                ),
              );
            },
            child: Text('next'),
          )
        ],
      ),
    );
  }
}
