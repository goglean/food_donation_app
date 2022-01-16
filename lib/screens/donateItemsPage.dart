import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_donating_app/screens/pickupDetails.dart';

import 'package:google_fonts/google_fonts.dart';

class CartItem {
  String unitType = "";
  String description = "";
  String quantity = "";
  CartItem(
      {required this.unitType,
      required this.description,
      required this.quantity});
}

class listViewItem extends StatefulWidget {
  List<CartItem> cart;
  int index;
  VoidCallback callback;
  List<String> units = [];

  listViewItem(
      {required this.cart,
      required this.index,
      required this.callback,
      required this.units});

  @override
  _listViewItemState createState() => _listViewItemState();
}

class _listViewItemState extends State<listViewItem> {
  String _value = "";
  List<String> unit = [];

  @override
  void initState() {
    super.initState();
    _value = widget.cart[widget.index].unitType;
    //unit = widget.units;
  }

  @override
  void didUpdateWidget(listViewItem oldWidget) {
    if (oldWidget.cart[widget.index].unitType !=
        widget.cart[widget.index].unitType) {
      _value = widget.cart[widget.index].unitType;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: MediaQuery.of(context).size.width * 0.15,
            height: MediaQuery.of(context).size.height * 0.08,
            //color: Colors.black,
            margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
            child: TextField(
              cursorColor: Theme.of(context).primaryColor,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: new BorderRadius.circular(20),
                  ),
                  labelText: "Qty",
                  labelStyle: GoogleFonts.roboto(
                      color: Theme.of(context).primaryColor)),
            )),
        Container(
          width: MediaQuery.of(context).size.width * 0.48,
          height: MediaQuery.of(context).size.height * 0.08,
          //color: Colors.black,
          margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
          child: TextField(
            cursorColor: Theme.of(context).primaryColor,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  borderRadius: new BorderRadius.circular(20),
                ),
                labelText: "Enter Description",
                labelStyle:
                    GoogleFonts.roboto(color: Theme.of(context).primaryColor)),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.08,
          margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(20.0)
              //)
              ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _value,
                hint: Container(
                  child: Text(
                    "Enter unit",
                    style: GoogleFonts.roboto(
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                style: const TextStyle(color: Color(0xff022229)),
                onChanged: (value) {
                  setState(() {
                    // print(indexUnit);
                    _value = value.toString();
                    widget.cart[widget.index].unitType = value.toString();
                  });
                },
                items:
                    widget.units.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DonateItemPage extends StatefulWidget {
  const DonateItemPage({Key? key}) : super(key: key);

  @override
  _DonateItemPageState createState() => _DonateItemPageState();
}

class _DonateItemPageState extends State<DonateItemPage> {
  List<int> items = [];
  List<String> units = [];

  int indexUnit = 0;
  List<CartItem> cart = [];

  void refresh() {
    setState(() {});
  }

  Future<void> _getUnitType() async {
    try {
      FirebaseFirestore.instance
          .collection('utils')
          .doc('Type of unit')
          .get()
          .then((value) {
        print("units");
        for (int i = 1; i <= value.data()!.length; i++) {
          units.add(value.data()![i.toString()].toString());
        }
        print(units);
      });
    } catch (err) {
      print("error      " + err.toString());
    }
  }

  @override
  void initState() {
    _getUnitType();

    items = List.generate(1, (i) {
      return i;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
          "1: Donation Items",
          style: GoogleFonts.roboto(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.height * 0.04,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    "Qty",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: MediaQuery.of(context).size.height * 0.02),
                  ),
                ),
                margin:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.48,
                height: MediaQuery.of(context).size.height * 0.04,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    "Description",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: MediaQuery.of(context).size.height * 0.02),
                  ),
                ),
                margin:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.27,
                height: MediaQuery.of(context).size.height * 0.04,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Text(
                    "Type of units",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: MediaQuery.of(context).size.height * 0.02),
                  ),
                ),
                margin:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  return listViewItem(
                    cart: cart,
                    index: index,
                    callback: refresh,
                    units: units,
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add),
          onPressed: () {
            cart.add(CartItem(
                unitType: "Small Bag", description: "", quantity: "1"));
            setState(() {
              items.add(items.length);
            });
            // setState(() {
            //   // add another item to the list
            //   // items.add(items.length);
            //   // indexUnit++;
            //   // _unit.add("Small Bag");
            // });
          }),
      bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.06,
          child: RaisedButton(
              shape: RoundedRectangleBorder(
                  // borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Theme.of(context).primaryColor)),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PickupDetails()));
              },
              child: Text(
                "Next",
                textAlign: TextAlign.left,
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: MediaQuery.of(context).size.height * 0.04),
              ))),
    );
  }
}
