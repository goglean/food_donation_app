import 'package:flutter/material.dart';

class CharitySignature extends StatefulWidget {
  const CharitySignature({Key? key}) : super(key: key);

  @override
  _CharitySignatureState createState() => _CharitySignatureState();
}

class _CharitySignatureState extends State<CharitySignature> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step 4: Charity Signature'),
      ),
    );
  }
}
