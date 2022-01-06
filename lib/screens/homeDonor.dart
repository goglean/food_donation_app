import 'package:flutter/material.dart';

class HomeDonor extends StatefulWidget {
  const HomeDonor({Key? key}) : super(key: key);

  @override
  _HomeDonorState createState() => _HomeDonorState();
}

class _HomeDonorState extends State<HomeDonor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Donor"),
      ),
    );
  }
}
