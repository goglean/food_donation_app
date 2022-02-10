import 'package:flutter/material.dart';

class Imapcts extends StatefulWidget {
  const Imapcts({Key? key}) : super(key: key);

  @override
  _ImapctsState createState() => _ImapctsState();
}

class _ImapctsState extends State<Imapcts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Our Imapct"),
        ),
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
        ));
  }
}
