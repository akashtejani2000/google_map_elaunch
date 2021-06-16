import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Screen/cluster_map/cluster_map.dart';
import 'Screen/polygon_map/polygon_map.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: PolyGonMap(),
      debugShowCheckedModeBanner: false,
    );
  }
}
