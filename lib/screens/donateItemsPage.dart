import 'package:flutter/material.dart';
import 'package:food_donating_app/forms/donateItemsForm.dart';
import 'package:google_fonts/google_fonts.dart';

class DonateItemPage extends StatefulWidget {
  const DonateItemPage({Key? key}) : super(key: key);

  @override
  _DonateItemPageState createState() => _DonateItemPageState();
}

class _DonateItemPageState extends State<DonateItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Step 1: Donation Items",
          style: GoogleFonts.roboto(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: DonateItemsForm(),
    );
  }
}
