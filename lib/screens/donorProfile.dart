import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileDonor extends StatefulWidget {
  const ProfileDonor({Key? key}) : super(key: key);

  @override
  _ProfileDonorState createState() => _ProfileDonorState();
}

class _ProfileDonorState extends State<ProfileDonor> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        child: Text("logout"),
        onPressed: () async {
          await auth.signOut();
           Navigator.pop(context);
        },
      ),
    );
  }
}
