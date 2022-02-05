import 'package:flutter/material.dart';

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
        ],
      ),
    );
  }
}
