import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DonateItemsForm extends StatefulWidget {
  const DonateItemsForm({Key? key}) : super(key: key);

  @override
  _DonateItemsFormState createState() => _DonateItemsFormState();
}

class _DonateItemsFormState extends State<DonateItemsForm> {
  List<int> items = [];

  @override
  void initState() {
    items = List.generate(2, (i) {
      return i;
    });
    super.initState();
  }

  Widget listViewItem() {
    // widget layout for listview items
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.1,
          height: MediaQuery.of(context).size.height * 0.08,
          color: Colors.black,
          margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.08,
          color: Colors.black,
          margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.08,
          color: Colors.black,
          margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column();
  }
}
