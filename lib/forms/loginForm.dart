import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_donating_app/screens/home.dart';
import 'package:food_donating_app/screens/homeDonor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formkey = GlobalKey<FormState>();
  var _email = "";
  var _password = "";
  bool _loginPageState = true;
  var _userType = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  startAuthentication() async {
    //var _userType = "";
    final validity = _formkey.currentState?..validate();
    FocusScope.of(context).unfocus();

    if (validity.toString().isNotEmpty) {
      _formkey.currentState?.save();

      await submitForm(_email, _password).then((userType) {
        _userType = userType;
        // print('auth $_userType');
      });
      //print('auth $_userType');
    }
    // return _userType;
  }

  Future<String> submitForm(String email, String password) async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    String userType = "";

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseFirestore.instance
          .collection('users')
          .doc((FirebaseAuth.instance.currentUser)?.uid)
          .get()
          .then((value) {
        userType = value.data()!['User Type'].toString();

        // print('au $userType');
      });

      //Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } catch (err) {
      //Navigator.push(
      //   context, MaterialPageRoute(builder: (context) => HomeDonor()));
      // print("error           " + err.toString());
    }
    return userType;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   startAuthentication();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return "Incorrect email";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value.toString();
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      border: OutlineInputBorder(
                        //borderRadius: new BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                        borderRadius: new BorderRadius.circular(20),
                      ),
                      labelText: "Enter Email",
                      labelStyle: GoogleFonts.roboto(
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value == null || value.length < 8) {
                        return "password is too short";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value.toString();
                    },
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      border: OutlineInputBorder(
                        //borderRadius: new BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                        borderRadius: new BorderRadius.circular(20),
                      ),
                      labelText: "Enter Password",
                      labelStyle: GoogleFonts.roboto(
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  Container(
                    height: 70,
                    width: 150,
                    padding: EdgeInsets.all(20),
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          startAuthentication();
                          // print('hi $_userType');
                          // if (_userType == "volunteer") {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => Home()));
                          // } else {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => HomeDonor()));
                          // }
                          Navigator.of(context).pop();
                          emailController.clear();
                          passwordController.clear();
                        },
                        child: Text(
                          "SignIn",
                          style: GoogleFonts.roboto(
                              fontSize: 20, color: Colors.white),
                        )),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
