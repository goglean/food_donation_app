import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_donating_app/shared/loading.dart';
import 'package:google_fonts/google_fonts.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  bool dataLoaded = false;
  List faqQues = [];
  List faqAns = [];

  void loadFAQs() async {
    faqQues = [];
    faqAns = [];
    CollectionReference faqCol = FirebaseFirestore.instance.collection('utils');
    // DocumentSnapshot faqDoc = await faqCol.doc('Faq').get();
    // Map faqMap = faqDoc.data() as Map;
    await faqCol.doc('Faq').get().then((DocumentSnapshot snap) {
      // print(snap.data() as Map);
      Map dataMap = snap.data() as Map;

      dataMap['question'].forEach((key, value) {
        faqQues.add(value);
      });

      dataMap['answer'].forEach((key, value) {
        faqAns.add(value);
      });
    });

    setState(() {
      dataLoaded = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    loadFAQs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Help Center"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(18),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'FAQs',
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          dataLoaded
              ? Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: faqAns.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Q: ${faqQues[index]}',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'A: ${faqAns[index]}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Loading(),
        ],
      ),
    );
  }
}
