import 'package:flutter/material.dart';

class SignupDonor extends StatefulWidget {
  const SignupDonor({Key? key}) : super(key: key);

  @override
  _SignupDonorState createState() => _SignupDonorState();
}

class _SignupDonorState extends State<SignupDonor> {
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
        title: Text("Authentication"),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
