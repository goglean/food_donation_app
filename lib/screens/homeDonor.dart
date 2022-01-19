import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_donating_app/screens/donatePage.dart';
import 'package:food_donating_app/screens/donorProfile.dart';
import 'package:food_donating_app/screens/helpDonor.dart';
import 'package:food_donating_app/screens/pickupsDonnor.dart';

class HomeDonor extends StatefulWidget {
  const HomeDonor({Key? key}) : super(key: key);

  @override
  _HomeDonorState createState() => _HomeDonorState();
}

class _HomeDonorState extends State<HomeDonor> {
  FirebaseAuth auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  String heading = "Donate Food";
  List<Widget> _widgetOptions = <Widget>[
    DonatePage(),
    PickupsDonor(),
    HelpPageDonor(),
    ProfileDonor(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0)
        heading = "Donate Food";
      else if (index == 1)
        heading = "My Donations";
      else if (index == 2)
        heading = "Help Center";
      else if (index == 3) heading = "Profile";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: Icon(Icons.home),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(heading),
        centerTitle: true,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Color(0xFFFF6E40)),
            BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Donations',
                backgroundColor: Color(0xFFFF6E40)),
            BottomNavigationBarItem(
                icon: Icon(Icons.help_center),
                label: 'Help',
                backgroundColor: Color(0xFFFF6E40)),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Color(0xFFFF6E40)),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          iconSize: MediaQuery.of(context).size.height * 0.03,
          onTap: _onItemTapped,
          elevation: 5),
    );
  }
}
