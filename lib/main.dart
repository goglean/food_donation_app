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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _userType = "";
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
          if (usersnapshot.hasData) {
            try {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc((FirebaseAuth.instance.currentUser)?.uid)
                  .get()
                  .then((value) {
                setState(() {
                  _userType = value.data()!['User Type'].toString();
                });
              });
            } catch (e) {
              print("error" + e.toString());
            }
            print("hello $_userType");
            if (_userType == "volunteer") {
              return Home();
            } else
              return HomeDonor();
          } else
            return AuthScreen();
        },
      ),
    );
  }
}
