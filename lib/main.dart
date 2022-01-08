import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_donating_app/screens/authscreen.dart';
import 'package:food_donating_app/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_donating_app/screens/homeDonor.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color(0xFFFF6E40),
          scaffoldBackgroundColor: Color(0xFFFCF8F0)),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, usersnapshot) {
          Widget pageState = Home();
          if (usersnapshot.hasData) {
            var _userType = "";
            try {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc((FirebaseAuth.instance.currentUser)?.uid)
                  .get()
                  .then((value) {
                _userType = value.data()!['User Type'].toString();
                print("hello $_userType");
                if (_userType == "volunteer") {
                  pageState = Home();
                } else {
                  pageState = HomeDonor();
                }
              });
            } catch (e) {
              print("error" + e.toString());
            }

            return pageState;
          } else
            return AuthScreen();
        },
      ),
    );
  }
}
