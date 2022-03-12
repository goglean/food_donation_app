import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_donating_app/screens/authscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileVolunteer extends StatefulWidget {
  const ProfileVolunteer({Key? key}) : super(key: key);

  @override
  _ProfileVolunteerState createState() => _ProfileVolunteerState();
}

class _ProfileVolunteerState extends State<ProfileVolunteer> {
  String _userName = "";
  String _PhoneNo = "";
  String _email = "";
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  var tc =
      "https://docs.google.com/document/d/10l_RlmC1Uhao8pwf3lAMFjPs_LSnqV5WFmXrtYeCIGE/edit?usp=sharing";
  var pp =
      "https://docs.google.com/document/d/1Q7XrZCbveTAqc-aa9NcpYHNz-UK_zuYyiHMqmksog8k/edit?usp=sharing";

  void _updateDetails() async {
    FirebaseFirestore.instance
        .collection("volunteers")
        .doc((FirebaseAuth.instance.currentUser)?.email)
        .update({
      "Name": _userName,
      "Phone Number": _PhoneNo,
      "email": _email,
    });

    FirebaseFirestore.instance
        .collection("users")
        .doc((FirebaseAuth.instance.currentUser)?.email)
        .update({
      "Name": _userName,
      "Phone Number": _PhoneNo,
      "email": _email,
    });

    final snackBar = SnackBar(content: Text('Details changed successfully!'));
  }

  Future<void> _getUserName() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc((FirebaseAuth.instance.currentUser)?.email)
        .get()
        .then((value) {
      setState(() {
        _userName = value.data()!['Name'].toString();
        _PhoneNo = value.data()!['Phone Number'];
        _email = value.data()!['email'];
        print('${_userName[0]}');
      });
    });
  }

  void initState() {
    super.initState();
    _getUserName();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("My Profile"),
        ),
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.06,
                child: Text(
                  "Account details",
                  style: GoogleFonts.roboto(
                      color: Colors.grey[600],
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(width: 1),
                        top: BorderSide(width: 1))),
                padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Name",
                      style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "$_userName",
                          style: GoogleFonts.roboto(
                              color: Colors.grey[500],
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        content: Text(
                                            "Do you want to change your name?"),
                                        actions: [
                                          Column(
                                            children: [
                                              Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: TextField(
                                                    cursorColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    controller: _nameController,
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    decoration: InputDecoration(
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20)),
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        //borderRadius: new BorderRadius.circular(8),
                                                        borderSide: BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                        borderRadius:
                                                            new BorderRadius
                                                                .circular(20),
                                                      ),
                                                      labelText:
                                                          "Enter new name here",
                                                      labelStyle:
                                                          GoogleFonts.roboto(
                                                              color: Colors
                                                                  .black87),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        _nameController.clear();
                                                      },
                                                      child: Text(
                                                        "Cancel",
                                                        style: GoogleFonts.roboto(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      )),
                                                  TextButton(
                                                      onPressed: () {
                                                        if (_nameController
                                                            .text.isNotEmpty) {
                                                          setState(() {
                                                            _userName =
                                                                _nameController
                                                                    .text;
                                                            print(_nameController
                                                                .toString());
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                          _nameController
                                                              .clear();
                                                        }
                                                      },
                                                      child: Text(
                                                        "OK",
                                                        style: GoogleFonts.roboto(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ))
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ));
                            },
                            icon: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.grey[500],
                            ))
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(width: 1),
                    )),
                padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Email",
                      style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "$_email",
                          style: GoogleFonts.roboto(
                              color: Colors.grey[500],
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        content: Text(
                                            "You cannot change your Email."),
                                        actions: [
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "OK",
                                                        style: GoogleFonts.roboto(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      )),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ));
                            },
                            icon: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.grey[500],
                            ))
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(width: 1),
                    )),
                padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Phone Number",
                      style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "$_PhoneNo",
                          style: GoogleFonts.roboto(
                              color: Colors.grey[500],
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        content: Text(
                                            "Do you want to change your Phone Number?"),
                                        actions: [
                                          Column(
                                            children: [
                                              Container(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: TextField(
                                                    cursorColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    controller:
                                                        _phoneNoController,
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    decoration: InputDecoration(
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            width: 1),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20)),
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        //borderRadius: new BorderRadius.circular(8),
                                                        borderSide: BorderSide(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                        borderRadius:
                                                            new BorderRadius
                                                                .circular(20),
                                                      ),
                                                      labelText:
                                                          "Enter new Phone Number here",
                                                      labelStyle:
                                                          GoogleFonts.roboto(
                                                              color: Colors
                                                                  .black87),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        _phoneNoController
                                                            .clear();
                                                      },
                                                      child: Text(
                                                        "Cancel",
                                                        style: GoogleFonts.roboto(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      )),
                                                  TextButton(
                                                      onPressed: () {
                                                        if (_phoneNoController
                                                            .text.isNotEmpty) {
                                                          setState(() {
                                                            _PhoneNo =
                                                                _phoneNoController
                                                                    .text;
                                                            print(
                                                                _phoneNoController
                                                                    .toString());
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                          _phoneNoController
                                                              .clear();
                                                        }
                                                      },
                                                      child: Text(
                                                        "OK",
                                                        style: GoogleFonts.roboto(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ))
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ));
                            },
                            icon: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.grey[500],
                            ))
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                //color: Colors.red,
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(20, 20, 15, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.info_outline),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.07,
                    ),
                    Flexible(
                      child: Text(
                        "You maybe listed on Go Glean website and be included in Go Glean communications, celebrating your organization's engagement.",
                        style: GoogleFonts.roboto(
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[400]),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Container(
                    //
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: MaterialButton(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                                width: 3,
                                color: Theme.of(context).primaryColor)),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        onPressed: () {
                          _updateDetails();
                        },
                        child: Text(
                          "Update details",
                          style: GoogleFonts.roboto(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.03),
                        )),
                  ),
                ),
              ),
              //SizedBox(height: MediaQuery.of(context).size.width * 0.1),
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 5, 0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.06,
                child: Text(
                  "Settings",
                  style: GoogleFonts.roboto(
                      color: Colors.grey[600],
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(width: 1),
                        top: BorderSide(width: 1))),
                padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Privacy policy",
                      style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                        onPressed: () async {
                          if (await canLaunch(pp)) {
                            await launch(
                              pp,
                              universalLinksOnly: true,
                            );
                          } else {
                            throw 'There was a problem to open the url: $pp';
                          }
                        },
                        icon: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.grey[500],
                        ))
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(width: 1),
                    )),
                padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Terms and Conditions",
                      style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                        onPressed: () async {
                          //const url = Resources.WEBSITE_NAME;
                          if (await canLaunch(tc)) {
                            await launch(tc);
                          } else {
                            throw 'Could not launch $tc';
                          }
                        },
                        icon: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.grey[500],
                        ))
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(width: 1),
                    )),
                padding: EdgeInsets.fromLTRB(15, 0, 20, 0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Text("Are you sure to logout?"),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              //Navigator.pop(context);
                                            },
                                            child: Text(
                                              "NO",
                                              style: GoogleFonts.roboto(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            )),
                                        TextButton(
                                            onPressed: () async {
                                              await FirebaseAuth.instance
                                                  .signOut();
                                               Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => AuthScreen()));
                                              //Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Yes",
                                              style: GoogleFonts.roboto(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ))
                                      ],
                                    )
                                  ],
                                ));
                      },
                      child: Text(
                        "Logout",
                        style: GoogleFonts.roboto(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
