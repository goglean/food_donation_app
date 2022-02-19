import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donating_app/widget/internet_service.dart';
import 'package:google_fonts/google_fonts.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 100, 0, 30),
              child: Text(
                "Something went wrong!",
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: Colors.black),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Theme.of(context).primaryColor)),
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  bool connected =
                      await InternetService().checkInternetConnection();
                  if (connected) {
                    Navigator.of(context).pop();
                  } else {
                    Fluttertoast.showToast(
                        msg: "Please check your internet connection!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black45,
                        fontSize: 16.0);
                  }
                },
                child: Text("Try Again",
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
