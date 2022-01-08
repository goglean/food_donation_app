import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DonateItemsForm extends StatefulWidget {
  const DonateItemsForm({ Key? key }) : super(key: key);

  @override
  _DonateItemsFormState createState() => _DonateItemsFormState();
}

class _DonateItemsFormState extends State<DonateItemsForm> {
final _formkey = GlobalKey<FormState>();
  var _email = "";
  var _password = "";
  bool _loginPageState = true;
  var _userType = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();







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