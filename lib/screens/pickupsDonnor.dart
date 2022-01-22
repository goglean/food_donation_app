import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class PickupsDonor extends StatefulWidget {
  const PickupsDonor({ Key? key }) : super(key: key);

  @override
  _PickupsDonorState createState() => _PickupsDonorState();
}

class _PickupsDonorState extends State<PickupsDonor> {
  String _donationType = "volunteer";
  bool pressAttention = true;
  bool press = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height *0.05,
        ),
        Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        side: BorderSide(
                                            color: Theme.of(context).primaryColor)),
                                    color: pressAttention
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).scaffoldBackgroundColor,
                                    onPressed: () => setState(() {
                                          pressAttention = !pressAttention;
                                          press = !press;
                                          _donationType = "Upcoming";
                                        }),
                                    child: Text(
                                      "Upcoming",
                                      style: GoogleFonts.roboto(
                                          color: pressAttention
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize:
                                              MediaQuery.of(context).size.height *
                                                  0.02),
                                    )),
                              ),
                              SizedBox(
                                width : MediaQuery.of(context).size.width * 0.01
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        side: BorderSide(
                                            color: Theme.of(context).primaryColor)),
                                    color: press
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context).scaffoldBackgroundColor,
                                    onPressed: () => setState(() {
                                          press = !press;
                                          pressAttention = !pressAttention;
                                          _donationType = "History";
                                        }),
                                    child: Text(
                                      "History",
                                      style: GoogleFonts.roboto(
                                          color:
                                              press ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize:
                                              MediaQuery.of(context).size.height *
                                                  0.02),
                                    )),
                              ),
                            ],
                          ),
        SingleChildScrollView(
          child: Container(
                            width: MediaQuery.of(context).size.width * 0.90,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,4,0,4),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width *0.75,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10,10,10,10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Today 10:15AM-2:15PM",style: GoogleFonts.roboto(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline
                            ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("2 Boxes Baked Goods",style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor,
                            ),
                            ),
                            Text("1 Box Assorted Produce (estimated)",style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor,
                            ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Our pick-up details for the volunteer",style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline
                            ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8,8,0,0),
                              child: Text("Come to the backdoor. Call us when you are near",style: GoogleFonts.roboto(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                      ),
                    child: Text("Add Another Donation",style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      color: Colors.white
                      )
                    ,),
                    onPressed: () {}),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}