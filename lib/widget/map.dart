import 'dart:async';
import 'package:food_donating_app/widget/restaurent_map.dart';
import 'package:food_donating_app/widget/map_service.dart';
import 'package:food_donating_app/widget/restaurents.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Restaurent>?>.value(
      value: MapService().restaurents,
      initialData: null,
      child: Scaffold(
        body: RestaurentMap(),
      ),
    );
  }
}
