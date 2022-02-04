import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileDonor extends StatefulWidget {
  const ProfileDonor({Key? key}) : super(key: key);

  @override
  _ProfileDonorState createState() => _ProfileDonorState();
}

class _ProfileDonorState extends State<ProfileDonor> {
  FirebaseAuth auth = FirebaseAuth.instance;

  String _name = "";
  String _PhoneNo = "";
  String _email = "";
  String _address = "";
  String _restaurant = "";
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _restaurantController = TextEditingController();

  void _updateDetails() async {
    FirebaseFirestore.instance
        .collection("donors")
        .doc((FirebaseAuth.instance.currentUser)?.uid)
        .update({
      "Name": _restaurant,
      "Phone Number": _PhoneNo,
      "email": _email,
      "Address": _address,
      "Contact Person": _name,
    });

    FirebaseFirestore.instance
        .collection("users")
        .doc((FirebaseAuth.instance.currentUser)?.uid)
        .update({
      "Name": _restaurant,
      "Phone Number": _PhoneNo,
      "email": _email,
      "Address": _address,
      "Contact Person": _name,
    });

    final snackBar = SnackBar(content: Text('Details changed successfully!'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _getUserName() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc((FirebaseAuth.instance.currentUser)?.uid)
        .get()
        .then((value) {
      setState(() {
        _name = value.data()!['Contact Person'].toString();
        _PhoneNo = value.data()!['Phone Number'];
        _email = value.data()!['email'];
        _address = value.data()!['Address'];
        _restaurant = value.data()!['Name'];
        print('${_name[0]}');
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
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.06,
            child: Text(
              "Business details",
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
                  top: BorderSide(width: 1),
                )),
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
                      "$_restaurant",
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
                                        "Do you want to change the name of your restaurant?"),
                                    actions: [
                                      Column(
                                        children: [
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: TextField(
                                                cursorColor: Theme.of(context)
                                                    .primaryColor,
                                                controller:
                                                    _restaurantController,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    //borderRadius: new BorderRadius.circular(8),
                                                    borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(20),
                                                  ),
                                                  labelText:
                                                      "Enter new name here",
                                                  labelStyle:
                                                      GoogleFonts.roboto(
                                                          color:
                                                              Colors.black87),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    _restaurantController
                                                        .clear();
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    style: GoogleFonts.roboto(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  )),
                                              TextButton(
                                                  onPressed: () {
                                                    if (_restaurantController
                                                        .text.isNotEmpty) {
                                                      setState(() {
                                                        _restaurant =
                                                            _restaurantController
                                                                .text;
                                                        print(
                                                            _restaurantController
                                                                .toString());
                                                      });
                                                      Navigator.pop(context);
                                                      _restaurantController
                                                          .clear();
                                                    }
                                                  },
                                                  child: Text(
                                                    "OK",
                                                    style: GoogleFonts.roboto(
                                                        color: Theme.of(context)
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
                    bottom: BorderSide(width: 1), top: BorderSide(width: 1))),
            padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.06,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Contact person's name",
                  style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "$_name",
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
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: TextField(
                                                cursorColor: Theme.of(context)
                                                    .primaryColor,
                                                controller: _nameController,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    //borderRadius: new BorderRadius.circular(8),
                                                    borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(20),
                                                  ),
                                                  labelText:
                                                      "Enter new name here",
                                                  labelStyle:
                                                      GoogleFonts.roboto(
                                                          color:
                                                              Colors.black87),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    _nameController.clear();
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    style: GoogleFonts.roboto(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  )),
                                              TextButton(
                                                  onPressed: () {
                                                    if (_nameController
                                                        .text.isNotEmpty) {
                                                      setState(() {
                                                        _name = _nameController
                                                            .text;
                                                        print(_nameController
                                                            .toString());
                                                      });
                                                      Navigator.pop(context);
                                                      _nameController.clear();
                                                    }
                                                  },
                                                  child: Text(
                                                    "OK",
                                                    style: GoogleFonts.roboto(
                                                        color: Theme.of(context)
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
                                        "Do you want to change your Email?"),
                                    actions: [
                                      Column(
                                        children: [
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: TextField(
                                                cursorColor: Theme.of(context)
                                                    .primaryColor,
                                                controller: _emailController,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    //borderRadius: new BorderRadius.circular(8),
                                                    borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(20),
                                                  ),
                                                  labelText:
                                                      "Enter new email here",
                                                  labelStyle:
                                                      GoogleFonts.roboto(
                                                          color:
                                                              Colors.black87),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    _emailController.clear();
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    style: GoogleFonts.roboto(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  )),
                                              TextButton(
                                                  onPressed: () {
                                                    if (_emailController
                                                        .text.isNotEmpty) {
                                                      setState(() {
                                                        _email =
                                                            _emailController
                                                                .text;
                                                        print(_emailController
                                                            .toString());
                                                      });
                                                      Navigator.pop(context);
                                                      _emailController.clear();
                                                    }
                                                  },
                                                  child: Text(
                                                    "OK",
                                                    style: GoogleFonts.roboto(
                                                        color: Theme.of(context)
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
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: TextField(
                                                cursorColor: Theme.of(context)
                                                    .primaryColor,
                                                controller: _phoneNoController,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    //borderRadius: new BorderRadius.circular(8),
                                                    borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(20),
                                                  ),
                                                  labelText:
                                                      "Enter new Phone Number here",
                                                  labelStyle:
                                                      GoogleFonts.roboto(
                                                          color:
                                                              Colors.black87),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    _phoneNoController.clear();
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    style: GoogleFonts.roboto(
                                                        color: Theme.of(context)
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
                                                        print(_phoneNoController
                                                            .toString());
                                                      });
                                                      Navigator.pop(context);
                                                      _phoneNoController
                                                          .clear();
                                                    }
                                                  },
                                                  child: Text(
                                                    "OK",
                                                    style: GoogleFonts.roboto(
                                                        color: Theme.of(context)
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
                  "Location",
                  style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "$_address",
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
                                        "Do you want to change your Location?"),
                                    actions: [
                                      Column(
                                        children: [
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: TextField(
                                                cursorColor: Theme.of(context)
                                                    .primaryColor,
                                                controller: _addressController,
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                decoration: InputDecoration(
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    //borderRadius: new BorderRadius.circular(8),
                                                    borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(20),
                                                  ),
                                                  labelText:
                                                      "Enter new address here",
                                                  labelStyle:
                                                      GoogleFonts.roboto(
                                                          color:
                                                              Colors.black87),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    _addressController.clear();
                                                    //Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "Cancel",
                                                    style: GoogleFonts.roboto(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  )),
                                              TextButton(
                                                  onPressed: () {
                                                    if (_addressController
                                                        .text.isNotEmpty) {
                                                      setState(() {
                                                        _address =
                                                            _addressController
                                                                .text;
                                                        print(_addressController
                                                            .toString());
                                                      });
                                                      Navigator.pop(context);
                                                      _addressController
                                                          .clear();
                                                    }
                                                  },
                                                  child: Text(
                                                    "OK",
                                                    style: GoogleFonts.roboto(
                                                        color: Theme.of(context)
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
            padding: EdgeInsets.fromLTRB(20, 5, 15, 5),
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
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.5,
                child: MaterialButton(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                            width: 3, color: Theme.of(context).primaryColor)),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    onPressed: () {
                      _updateDetails();
                    },
                    child: Text(
                      "Update details",
                      style: GoogleFonts.roboto(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: MediaQuery.of(context).size.height * 0.025),
                    )),
              ),
            ),
          ),
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
                    bottom: BorderSide(width: 1), top: BorderSide(width: 1))),
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
                    onPressed: () {},
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
                    onPressed: () {},
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
                                          await FirebaseAuth.instance.signOut();
                                          Navigator.pop(context);
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
    );
  }
}
