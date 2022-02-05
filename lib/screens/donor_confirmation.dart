import 'package:flutter/material.dart';
import 'package:food_donating_app/screens/traveltocharity.dart';

class DonorConfirmation extends StatelessWidget {
  Map curChar, curRes;
  DonorConfirmation({required this.curChar, required this.curRes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Step 2: Donor Confirmation'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Confirm Food Quatities',
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: curRes['descriptionlist'].length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  // margin: const EdgeInsets.all(30.0),
                                  // padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.black54,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ), //  POINT: BoxDecoration
                                  child: Center(
                                    child: Text(
                                      curRes['quantitylist'][index],
                                      style: TextStyle(
                                        fontSize: 30.0,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      // textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  curRes['unitlist'][index] +
                                      " " +
                                      curRes['descriptionlist'][index],
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 16),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: Theme.of(context).primaryColor,
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TravelToCharity(
                      curChar: curChar,
                      curRes: curRes,
                    ),
                  ),
                );
              },
              textColor: Colors.white,
              child: Text(
                'CONFIRM',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
