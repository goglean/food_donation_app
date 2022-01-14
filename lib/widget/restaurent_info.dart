import 'package:flutter/material.dart';
import 'package:food_donating_app/shared/loading.dart';
import 'package:food_donating_app/widget/map_service.dart';
import 'package:food_donating_app/widget/restaurents.dart';
import 'package:provider/src/provider.dart';

class RestaurentInfo extends StatefulWidget {
  const RestaurentInfo({Key? key}) : super(key: key);

  @override
  _RestaurentInfoState createState() => _RestaurentInfoState();
}

class _RestaurentInfoState extends State<RestaurentInfo> {
  @override
  Widget build(BuildContext context) {
    final restaurentInfo = context.watch<Restaurent>();

    return StreamBuilder<Restaurent>(
      stream: MapService(restaurentId: restaurentInfo.uniId).restaurentData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('${snapshot.data!.name}');
          print('${snapshot.data!.posLat}');
          print('${snapshot.data!.posLng}');
          print('${snapshot.data!.uniId}');
          print('objectdnfsdflbfkgblgkabaiblefkubalgbakj00');
          print('\n\n\n\n\n\n\n\n\n\n\n\n');
          return Text('data');
        } else {
          return Loading();
        }
      },
    );
  }
}
