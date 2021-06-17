import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map_elaunch/demo/flutterMap.dart';
import 'Screen/cluster_map/cluster_map.dart';
import 'Screen/polygon_map_show_marker/polygon_map.dart';
import 'Screen/polyline_animated_car_map_custom/google_map_controller.dart';
import 'Screen/polyline_animated_car_map_custom/google_map_screen.dart';
import 'Screen/polyline_creat_map/polyline_creat.dart';
import 'Screen/select_circle_map/circle_map.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: CircleMap(),
      debugShowCheckedModeBanner: false,
    );
  }
}
