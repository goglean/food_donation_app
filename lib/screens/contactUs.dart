import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _formkey = GlobalKey<FormState>();
  String _query = "";
  String _name = "";
  TextEditingController _queryController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  bool isHTML = false;

  submitQuery() async {
    final Email email = Email(
      body: _queryController.text + "\n\n" + _nameController.text,
      subject: "Suggesting a store",
      recipients: ['goglean.info@gmail.com'],
      isHTML: isHTML,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'Query sent successfully';
    } catch (error) {
      platformResponse = error.toString();
      print(platformResponse);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text("Contact Us"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formkey,
                child: ListView(
                  children: [
                    Flexible(
                        child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 120,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text("Suggest a store.",
                                  // softWrap: false,
                                  //maxLines: 4,
                                  // overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.roboto(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.06,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 2),
                          child: Text(
                              "Know a store you'd like to see on Go Glean. Let us know about it below.",
                              softWrap: false,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white)),
                        ),
                      ]),
                    )),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.04,
                      padding: EdgeInsets.all(5.0),
                      child: Text("Message",
                          style: GoogleFonts.roboto(
                              fontSize: MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 5, 15, 20),
                      child: TextFormField(
                        //expands: true,
                        controller: _queryController,
                        cursorColor: Theme.of(context).primaryColor,
                        keyboardType: TextInputType.multiline,
                        minLines: 5,
                        maxLines: 7,
                        key: ValueKey('query'),
                        validator: (value) {
                          if (value == null) {
                            return "This cannot be empty";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _query = value.toString();
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.grey[100],
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Theme.of(context).primaryColor),
                            borderRadius: new BorderRadius.circular(20),
                          ),
                          labelText: "Enter Your Message here",
                          labelStyle: GoogleFonts.roboto(
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.04,
                      padding: EdgeInsets.all(5.0),
                      child: Text("Your contacts details",
                          style: GoogleFonts.roboto(
                              fontSize: MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 5, 15, 20),
                      child: TextFormField(
                        //expands: true,
                        controller: _nameController,
                        cursorColor: Theme.of(context).primaryColor,
                        keyboardType: TextInputType.emailAddress,
        
                        key: ValueKey('name'),
                        validator: (value) {
                          if (value == null) {
                            return "This cannot be empty";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _name = value.toString();
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.grey[100],
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Theme.of(context).primaryColor),
                            borderRadius: new BorderRadius.circular(10),
                          ),
                          labelText: "Enter Your Full name here",
                          labelStyle: GoogleFonts.roboto(
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          0,
                          MediaQuery.of(context).size.height * 0.01,
                          0,
                          MediaQuery.of(context).size.height * 0.01),
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: TextButton(
                        onPressed: () {
                          submitQuery();
                          _queryController.clear();
                          _nameController.clear();
                        },
                        child: Text("Submit",
                            style: GoogleFonts.roboto(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }
}
