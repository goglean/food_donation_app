import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_donating_app/screens/journeyfinished.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class CharitySignature extends StatefulWidget {
  Map curChar, curRes;
  CharitySignature({required this.curChar, required this.curRes});

  @override
  _CharitySignatureState createState() => _CharitySignatureState();
}

class _CharitySignatureState extends State<CharitySignature> {
  final _controller = TextEditingController();
  String? fullName;
  File? _imageFile;
  bool imagePicked = false;
  // String? curPickupDocId;
  List<String>? curPickupDocId = [];
  bool? checked = false;

  final picker = ImagePicker();

  Future pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile == null) return;

      final imageTemp = File(pickedFile.path);
      setState(() {
        _imageFile = imageTemp;
        imagePicked = true;
      });
    } on PlatformException catch (e) {
      print('Failed to pickup images');
    }
  }

  Future uploadImageToFirebase(BuildContext context, bool? checked) async {
    bool found = false;
    if (checked!) {
      final CollectionReference pCollection =
          FirebaseFirestore.instance.collection('pickup_details');
      final CollectionReference oldPickups =
          FirebaseFirestore.instance.collection('old_pickups');

      QuerySnapshot snapshot = await pCollection.get();

      snapshot.docs.forEach((element) {
        Map dataMap = element.data() as Map;
        if (dataMap['Pickedby'] == FirebaseAuth.instance.currentUser!.email &&
            !found &&
            dataMap['PickedCharityUniId'] ==
                widget.curRes['PickedCharityUniId'] &&
            widget.curRes['Restaurant Name'] == dataMap['Restaurant Name']) {
          print(element.id);
          pCollection.doc(element.id).update({
            "Reciever's name": fullName,
          });

          curPickupDocId!.add(element.id);

          dataMap["Reciever's name"] = fullName;

          oldPickups.doc(element.id).set(dataMap);
          pCollection.doc(element.id).delete();
        }
      });

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JourneyFinished(
            curChar: widget.curChar,
            curRes: widget.curRes,
          ),
        ),
      );

      return;
    }

    if (_imageFile == null) return;

    String fileName = basename(_imageFile!.path);

    print(fileName);

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('signature')
        .child('/$fileName');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': fileName});
    firebase_storage.UploadTask uploadTask;
    uploadTask = ref.putFile(File(_imageFile!.path), metadata);

    firebase_storage.UploadTask task = await Future.value(uploadTask);
    Future.value(uploadTask)
        .then((value) => {print("Upload file path ${value.ref.fullPath}")})
        .onError((error, stackTrace) =>
            {print("Upload file path error ${error.toString()} ")});

    final CollectionReference pCollection =
        FirebaseFirestore.instance.collection('pickup_details');
    final CollectionReference oldPickups =
        FirebaseFirestore.instance.collection('old_pickups');

    QuerySnapshot snapshot = await pCollection.get();

    snapshot.docs.forEach((element) {
      Map dataMap = element.data() as Map;
      if (dataMap['Pickedby'] == FirebaseAuth.instance.currentUser!.email &&
          !found &&
          dataMap['PickedCharityUniId'] ==
              widget.curRes['PickedCharityUniId']) {
        print(element.id);
        pCollection.doc(element.id).update({
          "Reciever's name": fullName,
          "Reciever's Signature": fileName,
        });

        curPickupDocId!.add(element.id);

        dataMap["Reciever's name"] = fullName;
        dataMap["Reciever's Signature"] = fileName;

        oldPickups.doc(element.id).set(dataMap);
        pCollection.doc(element.id).delete();
      }
    });

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JourneyFinished(
          curChar: widget.curChar,
          curRes: widget.curRes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Step 4: Charity Signature'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Reciever's Name",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _controller,
                      onChanged: (val) {
                        fullName = _controller.text.toString();
                      },
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        hintText: 'Full Name',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 45),
                    Text(
                      "Reciever's Signature",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 25),
                    Center(
                      child: _imageFile == null
                          ? FlatButton(
                              child: Icon(
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
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  width: double.infinity,
                                  child: FlatButton(
                                    onPressed: pickImage,
                                    textColor: Colors.white,
                                    child: Text(
                                      'Click Again',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Transform.scale(
                          scale: 1.3,
                          child: Checkbox(
                            value: this.checked,
                            onChanged: (checked) {
                              print(checked);
                              setState(() {
                                this.checked = checked;
                              });
                            },
                          ),
                        ),
                        Text(
                          'No one is available to sign',
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: FlatButton(
              onPressed: () {
                if (!checked!) {
                  if (fullName == null || !imagePicked) {
                    Fluttertoast.showToast(
                        msg: "Please fill name and signature!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black45,
                        fontSize: 16.0);
                    return;
                  }
                }
                uploadImageToFirebase(context, checked);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JourneyFinished(
                      curChar: widget.curChar,
                      curRes: widget.curRes,
                      curPickupDocId: curPickupDocId,
                    ),
                  ),
                );
              },
              textColor: Colors.white,
              child: Text(
                'FINISH',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
