import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class PickupDetails extends StatefulWidget {
  const PickupDetails({Key? key}) : super(key: key);

  @override
  _PickupDetailsState createState() => _PickupDetailsState();
}

class _PickupDetailsState extends State<PickupDetails> {
  String _selectedGender = 'Single Date';
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
          "Step 2: Pickup details",
          style: GoogleFonts.roboto(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Location",style: TextStyle(color: Theme.of(context).primaryColor),),
            Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)
                    ),
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            Text("Pick-Up Details",style: TextStyle(color: Theme.of(context).primaryColor),),
                    ListTile(
                leading: Radio<String>(
                  value: 'Single Date',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                title: const Text('Single Date'),
              ),
              ListTile(
                leading: Radio<String>(
                  value: 'Date Range',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                title: const Text('Date Range'),
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Text("Start Date",style: TextStyle(color: Theme.of(context).primaryColor),),
                      SizedBox(
                width: 130,
              child:DateTimePicker(
  type: DateTimePickerType.date,
  dateMask: 'd MMM, yyyy',
  initialValue: DateTime.now().toString(),
  firstDate: DateTime(2000),
  lastDate: DateTime(2100),
  icon: Icon(Icons.event),
  dateLabelText: 'Date',
  timeLabelText: "Time",
  selectableDayPredicate: (date) {
    if (date.weekday == 6 || date.weekday == 7) {
      return false;
    }

    return true;
  },
  onChanged: (val) => print(val),
  validator: (val) {
    print(val);
    return null;
  },
  onSaved: (val) => print(val),
)),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(20)),
                  Column(
                    children: [
                      Text("End Date",style: TextStyle(color: Theme.of(context).primaryColor),),
                      SizedBox(
                width: 130,
              child:DateTimePicker(
  type: DateTimePickerType.date,
  dateMask: 'd MMM, yyyy',
  initialValue: DateTime.now().toString(),
  firstDate: DateTime(2000),
  lastDate: DateTime(2100),
  icon: Icon(Icons.event),
  dateLabelText: 'Date',
  timeLabelText: "Time",
  selectableDayPredicate: (date) {
    if (date.weekday == 6 || date.weekday == 7) {
      return false;
    }
    return true;
  },
  onChanged: (val) => print(val),
  validator: (val) {
    print(val);
    return null;
  },
  onSaved: (val) => print(val),
)),
                    ],
                  )
                ],
              ),
              Padding(padding: EdgeInsets.all(20)),
              Row(
                children: [
                  Column(
                    children: [
                      Text("Start Time",style: TextStyle(color: Theme.of(context).primaryColor),),
                      SizedBox(
                width: 130,
              child:DateTimePicker(
  type: DateTimePickerType.date,
  dateMask: 'd MMM, yyyy',
  initialValue: DateTime.now().toString(),
  firstDate: DateTime(2000),
  lastDate: DateTime(2100),
  icon: Icon(Icons.event),
  dateLabelText: 'Date',
  timeLabelText: "Time",
  selectableDayPredicate: (date) {
    if (date.weekday == 6 || date.weekday == 7) {
      return false;
    }

    return true;
  },
  onChanged: (val) => print(val),
  validator: (val) {
    print(val);
    return null;
  },
  onSaved: (val) => print(val),
)),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(20)),
                  Column(
                    children: [
                      Text("End Time",style: TextStyle(color: Theme.of(context).primaryColor),),
                      SizedBox(
                width: 130,
              child:DateTimePicker(
  type: DateTimePickerType.date,
  dateMask: 'd MMM, yyyy',
  initialValue: DateTime.now().toString(),
  firstDate: DateTime(2000),
  lastDate: DateTime(2100),
  icon: Icon(Icons.event),
  dateLabelText: 'Date',
  timeLabelText: "Time",
  selectableDayPredicate: (date) {
    if (date.weekday == 6 || date.weekday == 7) {
      return false;
    }
    return true;
  },
  onChanged: (val) => print(val),
  validator: (val) {
    print(val);
    return null;
  },
  onSaved: (val) => print(val),
)),
                    ],
                  )
                ],
              ),
            Padding(padding: EdgeInsets.all(10)
            ),
              Text("Pick-Up(Optional)",style: TextStyle(color: Theme.of(context).primaryColor),),
              Padding(padding: EdgeInsets.all(10),
              child: 
              Text("Include clear details that will help you and the volunteers have a successful pick-up"),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child:
              TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                )
              ),
               keyboardType: TextInputType.multiline,
                minLines: 7,
               maxLines: 10
              ) ,),
              Text("Organization",style: TextStyle(color: Theme.of(context).primaryColor),),
              Padding(padding: EdgeInsets.all(8),
              child: Text("This Donation will be sent to any registered non-profit in the area"),),
              MaterialButton( 
 height: 40.0, 
 minWidth: double.infinity,
 color: Theme.of(context).primaryColor, 
 textColor: Colors.white, 
 child: new Text("push"), 
 onPressed: () => {}, 
 splashColor: Colors.redAccent,
),
          ],)
        ),
      ),
    );
  }
}
