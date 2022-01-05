import 'package:flutter/material.dart';

class ProfileVolunteer extends StatefulWidget {
  const ProfileVolunteer({Key? key}) : super(key: key);

  @override
  _ProfileVolunteerState createState() => _ProfileVolunteerState();
}

class _ProfileVolunteerState extends State<ProfileVolunteer> {
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
          title: Text("Volunteer\'s Profile"),
        ),
        body: Container());
  }
}
