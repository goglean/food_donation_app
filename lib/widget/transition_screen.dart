import 'package:flutter/material.dart';
import 'package:food_donating_app/widget/available_pickup_page.dart';
import 'package:food_donating_app/widget/charity.dart';
import 'package:food_donating_app/widget/map_service.dart';
import 'package:provider/provider.dart';

class TransitionScreen extends StatefulWidget {
  @override
  _TransitionScreenState createState() => _TransitionScreenState();
}

class _TransitionScreenState extends State<TransitionScreen> {
  @override
  Widget build(BuildContext context) {
    final dataFromScreen = ModalRoute.of(context)!.settings.arguments as Map;
    return StreamProvider<List<Charity>?>.value(
      value: MapService().charities,
      initialData: [],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Available Pickups'),
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
        ),
        body: AvaiablePickups(
          dataFromScreen: dataFromScreen,
        ),
      ),
    );
  }
}
