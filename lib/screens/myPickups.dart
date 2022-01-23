import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_donating_app/screens/startJourney.dart';
import 'package:food_donating_app/shared/loading.dart';
import 'package:food_donating_app/shared/no_pickups.dart';

class MyPickups extends StatefulWidget {
  const MyPickups({Key? key}) : super(key: key);

  @override
  _MyPickupsState createState() => _MyPickupsState();
}

class _MyPickupsState extends State<MyPickups> {
  bool _pressAttention = true, _dataLoaded = false, _pickUpAvailable = false;
  List pickUpList = [];
  void getPickUps() async {
    CollectionReference volunteerCollection =
        FirebaseFirestore.instance.collection('volunteers');
    String curUserUid = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot pickUpSnapshot =
        await volunteerCollection.doc(curUserUid).get();

    pickUpList = (pickUpSnapshot.data() as Map)['PickUps'];
    for (var i = 0; i < pickUpList.length; i++) {
      print(pickUpList[i]);
    }

    if (!_dataLoaded)
      setState(() {
        _dataLoaded = true;
        if (pickUpList.length != 0) _pickUpAvailable = true;
      });
  }

  @override
  void initState() {
    super.initState();
    getPickUps();
  }

  @override
  Widget build(BuildContext context) {
    void openUnclaimConfirmation(int index) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Column(
            children: [
              Text(
                "We're sorry to see you unclaim your pickup",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ButtonTheme(
                minWidth: 36,
                child: RaisedButton(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  child: Text(
                    'CONFIRM',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(28.0),
                  ),
                  onPressed: () async {
                    final CollectionReference resCollection =
                        FirebaseFirestore.instance.collection('restaurent');
                    await resCollection
                        .doc(pickUpList[index]['resUid'])
                        .update({'isClaimed': false});

                    print(pickUpList[index]['resUid']);

                    pickUpList.removeAt(index);
                    print('\n\n\n\n\n\n\n\n\n');

                    final CollectionReference volunteerCollection =
                        FirebaseFirestore.instance.collection('volunteers');
                    String curUser = FirebaseAuth.instance.currentUser!.uid;
                    await volunteerCollection
                        .doc(curUser)
                        .update({'PickUps': pickUpList});

                    _dataLoaded = false;
                    _pickUpAvailable = false;
                    Navigator.pop(context);
                    getPickUps();
                  },
                ),
              ),
              FlatButton(
                child: Text('CANCEL'),
                color: Colors.transparent,
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ),
      );
    }

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
        title: Text("My Pickups"),
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Row(
            children: [
              SizedBox(width: MediaQuery.of(context).size.width * 0.1),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  // color: Colors.orange,
                  color: _pressAttention
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).scaffoldBackgroundColor,
                  onPressed: () {
                    setState(() {
                      _pressAttention = true;
                    });
                    print('upcoming');
                  },
                  child: Text(
                    'Upcoming',
                    style: TextStyle(
                      color: !_pressAttention
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  // color: Colors.orange,
                  color: !_pressAttention
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).scaffoldBackgroundColor,
                  onPressed: () {
                    setState(() {
                      _pressAttention = false;
                    });
                    print('upcoming');
                  },
                  child: Text(
                    'History',
                    style: TextStyle(
                      color: !_pressAttention
                          ? Theme.of(context).scaffoldBackgroundColor
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.width * 0.05),
          _dataLoaded
              ? _pickUpAvailable
                  // ? Text('data')
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: pickUpList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Today ${pickUpList[index]['charityOpenTime']} - ${pickUpList[index]['charityCloseTime']}",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Text(
                                                'Pickup from',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                pickUpList[index]['from'],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Text(
                                                'Drop off to',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                pickUpList[index]['to'],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ButtonTheme(
                                                minWidth: 36,
                                                child: RaisedButton(
                                                  textColor: Colors.white,
                                                  color: Color.fromRGBO(
                                                      118, 210, 83, 1),
                                                  child: Text(
                                                    'START',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  shape:
                                                      new RoundedRectangleBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(10.0),
                                                  ),
                                                  onPressed: () {
                                                    // print(FirebaseAuth.instance.currentUser!.uid);
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              StartJourney(),
                                                        ));
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ButtonTheme(
                                                minWidth: 36,
                                                child: RaisedButton(
                                                  textColor: Colors.white,
                                                  color: Color.fromRGBO(
                                                      248, 95, 99, 1),
                                                  child: Text(
                                                    'UNCLAIM',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  shape:
                                                      new RoundedRectangleBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(10.0),
                                                  ),
                                                  onPressed: () {
                                                    openUnclaimConfirmation(
                                                        index);
                                                    // print(FirebaseAuth.instance.currentUser!.uid);
                                                    // Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16)
                          ],
                        );
                      },
                    )
                  : NoPickUpsAvailable()
              : Loading()
        ],
      ),
    );
  }
}
