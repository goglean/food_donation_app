import 'package:flutter/material.dart';

class MyPickups extends StatefulWidget {
  const MyPickups({Key? key}) : super(key: key);

  @override
  _MyPickupsState createState() => _MyPickupsState();
}

class _MyPickupsState extends State<MyPickups> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("My Pickups"),
        ),
        body: Container());
  }
}
