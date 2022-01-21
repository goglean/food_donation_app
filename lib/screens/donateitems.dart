import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donating_app/screens/pickupDetails.dart';
import 'package:google_fonts/google_fonts.dart';
class listfordonateitems extends StatefulWidget {
  int index;
  listfordonateitems({
    required this.index
  });
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
              child: Text(_donateitemsState.qtylist[widget.index].toString()),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.40,
              child: Text(_donateitemsState.disclist[widget.index].toString()),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Text(_donateitemsState.unitslist[widget.index].toString()),
            ),
            IconButton(onPressed: () {
              _donateitemsState.unitslist.removeAt(widget.index);
              _donateitemsState.qtylist.removeAt(widget.index);
              _donateitemsState.disclist.removeAt(widget.index);
            }, icon: Icon(Icons.delete))
          ],
        ),
      ),
    );
  }
}
class donateitems extends StatefulWidget {
  const donateitems({ Key? key }) : super(key: key);

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
        title: Text('Step 1:Donation Items',
          style: GoogleFonts.roboto(
            color: Theme.of(context).primaryColor,),),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.13,
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
                  width: MediaQuery.of(context).size.width * 0.40,
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
                    child: Icon(Icons.delete,color: Colors.white,)
                  ),
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
              SizedBox(height: 20,),
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
              DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
          changed = true;
        });
      },
      items: <String>["Small Bag","Large Bag","Box","Tray","Case","Crate"]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ),
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
                print(disclist.toString() + qtylist.toString() + unitslist.toString());
              },
              child: const Text('Add Item'),
            ),
          ],
        ),
      );
          }),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        child:MaterialButton(
          color: Theme.of(context).primaryColor,
          height: 40.0,
          minWidth: double.infinity,
          onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PickupDetails(
                      Unilist: unitslist,
                      quanlist: qtylist,
                      desclist: disclist,
                    )));
          }, 
        child: Container(
          child: Text("Next",style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                fontSize: MediaQuery.of(context).size.width * 0.07,
                color: Colors.white)),
        ))
      ),
    );
  }
}