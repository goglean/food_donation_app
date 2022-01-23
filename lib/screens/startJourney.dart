import 'package:flutter/material.dart';

class StartJourney extends StatefulWidget {
  const StartJourney({Key? key}) : super(key: key);

  @override
  _StartJourneyState createState() => _StartJourneyState();
}

class _StartJourneyState extends State<StartJourney> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('travel to donor'),
      ),
      body: Container(),
    );
  }
}
