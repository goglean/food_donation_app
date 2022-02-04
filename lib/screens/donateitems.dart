import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donating_app/screens/pickupDetails.dart';
import 'package:google_fonts/google_fonts.dart';

class listfordonateitems extends StatefulWidget {
  int index;
  listfordonateitems({required this.index});
  @override
  _listfordonateitemsState createState() => _listfordonateitemsState();
}

class _listfordonateitemsState extends State<listfordonateitems> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.15,
              height: MediaQuery.of(context).size.height * 0.04,
              child: Center(
                  child:
                      Text(_donateitemsState.qtylist[widget.index].toString())),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.04,
              child: Center(
                  child: Text(
                      _donateitemsState.disclist[widget.index].toString())),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: MediaQuery.of(context).size.height * 0.04,
              child: Center(
                  child: Text(
                      _donateitemsState.unitslist[widget.index].toString())),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.height * 0.04,
              margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
              child: Center(
                child: IconButton(
                    onPressed: () {
                      _donateitemsState.unitslist.removeAt(widget.index);
                      _donateitemsState.qtylist.removeAt(widget.index);
                      _donateitemsState.disclist.removeAt(widget.index);
                    },
                    icon: Icon(Icons.delete)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class donateitems extends StatefulWidget {
  const donateitems({Key? key}) : super(key: key);

  @override
  _donateitemsState createState() => _donateitemsState();
}

class _donateitemsState extends State<donateitems> {
  static List qtylist = [];
  static List disclist = [];
  static List unitslist = [];
  bool changed = false;
  TextEditingController qtycontroller = TextEditingController();
  TextEditingController disccontroller = TextEditingController();
  String dropdownValue = 'Small Bag';

  List<String> units = [];

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
    super.initState();
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
        title: Text(
          'Step 1:Donation Items',
          style: GoogleFonts.roboto(
            color: Theme.of(context).primaryColor,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
        child: Column(
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
                  width: MediaQuery.of(context).size.width * 0.35,
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
                  width: MediaQuery.of(context).size.width * 0.25,
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
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: MediaQuery.of(context).size.height * 0.04,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Center(
                      child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  )),
                  margin:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 2, 0, 5),
                child: ListView.builder(
                    itemCount: qtylist.length,
                    itemBuilder: (context, index) {
                      return listfordonateitems(
                        index: index,
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.add),
          onPressed: () {
            showDialog<String>(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Add Item'),
                content: Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: qtycontroller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Qty",
                        hintStyle: GoogleFonts.roboto(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 4,
                      maxLines: 5,
                      controller: disccontroller,
                      decoration: InputDecoration(
                        hintMaxLines: 7,
                        border: OutlineInputBorder(),
                        hintText: "Description",
                        hintStyle: GoogleFonts.roboto(color: Colors.black),
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.08,
                        margin: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.01),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(20.0)
                            //)
                            ),
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: dropdownValue,
                                icon: const Icon(Icons.arrow_drop_down),
                                elevation: 16,
                                style:
                                    const TextStyle(color: Color(0xFFFF6E40)),
                                underline: Container(
                                  height: 2,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                    changed = true;
                                  });
                                },
                                items: units.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            )))
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      qtycontroller.clear();
                      disccontroller.clear();
                      dropdownValue = 'Small Bag';
                      Navigator.pop(context, 'Cancel');
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      qtylist.add(qtycontroller.text);
                      disclist.add(disccontroller.text);
                      unitslist.add(dropdownValue.toString());
                      qtycontroller.clear();
                      disccontroller.clear();
                      dropdownValue = 'Small Bag';
                      Navigator.pop(context, 'Add Item');
                      print(disclist.toString() +
                          qtylist.toString() +
                          unitslist.toString());
                    },
                    child: const Text('Add Item'),
                  ),
                ],
              ),
            );
          }),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.06,
        child: MaterialButton(
            color: Theme.of(context).primaryColor,
            height: 40.0,
            minWidth: double.infinity,
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('utils')
                  .doc('stats')
                  .get()
                  .then((value) {
                print(value.data()!['Box']);
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PickupDetails(
                            Unilist: unitslist,
                            quanlist: qtylist,
                            desclist: disclist,
                          )));
            },
            child: Container(
              child: Text("Next",
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                      color: Colors.white)),
            )),
      ),
    );
  }
}
