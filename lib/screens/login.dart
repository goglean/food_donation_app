import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donating_app/screens/home.dart';
import 'package:food_donating_app/screens/homeDonor.dart';
import 'package:google_fonts/google_fonts.dart';

class signinpage extends StatefulWidget {
  @override
  State<signinpage> createState() => _loginpageState();
}

class _loginpageState extends State<signinpage> {
  bool _isObscure = true;
  var _userType;
  usertype(){
    FirebaseFirestore.instance
                  .collection('users')
                  .doc((FirebaseAuth.instance.currentUser)?.uid)
                  .get()
                  .then((value) {
                setState(() {
                  _userType = value.data()!['User Type'].toString();
                });
              });
        if (_userType == "volunteer") {
          return Home();
        } else {
          return HomeDonor();
        }
  }
  final usernamecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Authentication',
          style: GoogleFonts.roboto(
              color: Theme.of(context).scaffoldBackgroundColor),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'SignIn',
                    style: GoogleFonts.roboto(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  )),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: TextField(
                  cursorColor: Theme.of(context).primaryColor,
                  style: GoogleFonts.roboto(color: Colors.black),
                  controller: usernamecontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    hintStyle: GoogleFonts.roboto(color: Colors.black),
                    hintText: 'Email ID',
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: TextField(
                  cursorColor: Theme.of(context).primaryColor,
                  obscureText: _isObscure,
                  style: GoogleFonts.roboto(color: Colors.black),
                  controller: passwordcontroller,
                  keyboardType: TextInputType.streetAddress,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    hintStyle: GoogleFonts.roboto(color: Colors.black),
                    hintText: 'Enter Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {},
                  child: Text('Forgot Password',
                      style: GoogleFonts.roboto(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15))),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: 20,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                      onPressed: () {
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: usernamecontroller.text,
                                password: passwordcontroller.text)
                            .then((value) async {
                          if (FirebaseAuth
                                  .instance.currentUser?.emailVerified ==
                              true) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => usertype(),
                                ));
                          } else {
                            return Fluttertoast.showToast(
                                msg: 'User not verified',
                                gravity: ToastGravity.BOTTOM,
                                fontSize: 18,
                                backgroundColor: Theme.of(context).primaryColor,
                                textColor: Colors.white);
                          }
                        });
                      },
                      child: Text(
                        'Signin',
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: MediaQuery.of(context).size.height * 0.03,
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
