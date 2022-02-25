import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:async';
import 'dart:io';

class ContactUsVolunteer extends StatefulWidget {
  const ContactUsVolunteer({Key? key}) : super(key: key);

  @override
  _ContactUsVolunteerState createState() => _ContactUsVolunteerState();
}

class _ContactUsVolunteerState extends State<ContactUsVolunteer> {
  final _formkey = GlobalKey<FormState>();
  String _query = "";
  String _name = "";
  String _issue = "Restaurant is not picking up the call";
  TextEditingController _queryController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  bool isHTML = false;
  List<String> issues = [];
  File? _imageFile;
  bool imagePicked = false;
  String? _uploadedFileURL;
  List<String> attachments = [];

  void _removeAttachment(int index) {
    setState(() {
      attachments.removeAt(index);
    });
  }

  void _openImagePicker() async {
    final picker = ImagePicker();
    PickedFile? pick = await picker.getImage(source: ImageSource.camera);

    if (pick != null) {
      setState(() {
        attachments.add(pick.path);
        _imageFile = File(pick.path);
        imagePicked = true;
      });
    }
  }

  submitQuery() async {
    final Email email = Email(
      body: _queryController.text + "\n\n" + _nameController.text,
      subject: "Problem regarding " + _issue,
      recipients: ['goglean.info@gmail.com'],
      attachmentPaths: attachments,
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
    ScaffoldMessenger.of(this.context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  Future<void> _getIssues() async {
    FirebaseFirestore.instance
        .collection('utils')
        .doc('Issues')
        .get()
        .then((value) {
      // print("hello");
      for (int i = 1; i <= value.data()!.length; i++) {
        issues.add(value.data()![i.toString()].toString());
      }
      // print(cuisine);
    });
  }

  final picker = ImagePicker();
  Future pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile == null) return;

      final imageTemp = File(pickedFile.path);
      setState(() {
        _imageFile = imageTemp;
        imagePicked = true;
        attachments.add(pickedFile.path);
      });
    } catch (e) {
      print('Failed to pickup images');
    }
  }

  void initState() {
    super.initState();
    _getIssues();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          //foregroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Contact Us",
            style: GoogleFonts.roboto(color: Theme.of(context).primaryColor),
          ),
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
                              child: Text("Question about a pickup?",
                                  // softWrap: false,
                                  //maxLines: 4,
                                  // overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.roboto(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 0, 2),
                          child: Text(
                              "If you need help regarding a specific order, pleasse fill the form and we'll get back to you as soon as possible.",
                              softWrap: false,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
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
                      child: Text("Choose your topic",
                          style: GoogleFonts.roboto(
                              fontSize: MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 5, 15, 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _issue,
                              hint: Container(
                                child: Text("Issues"),
                              ),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              style: const TextStyle(color: Color(0xff022229)),
                              onChanged: (newValue) {
                                setState(() {
                                  _issue = newValue.toString();
                                });
                              },
                              items: issues
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: GoogleFonts.roboto(
                                      fontSize: 15,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
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
                        // minLines: 7,
                        // maxLines: 10,
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
                            borderRadius: new BorderRadius.circular(10),
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
                      child: _imageFile == null
                          ? IconButton(
                              icon: Icon(
                                Icons.add_a_photo,
                                size: 50,
                              ),
                              onPressed: pickImage,
                            )
                          : Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    _imageFile!,
                                    width: 360,
                                    height: 360,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 25),
                                Container(
                                  decoration: BoxDecoration(
                                    //border: BoxBorder(),
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  width: double.infinity,
                                  child: MaterialButton(
                                    onPressed: pickImage,
                                    textColor: Colors.white,
                                    child: Text(
                                      'Click Again',
                                      style: TextStyle(
                                          fontSize:
                                              MediaQuery.of(context).size.width *
                                                  0.05),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: Container(
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
                            imagePicked = false;
                          },
                          child: Text("Submit",
                              style: GoogleFonts.roboto(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.06,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }
}
