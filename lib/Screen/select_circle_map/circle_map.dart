import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_map_elaunch/Screen/select_circle_map/circle_map_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CircleMap extends StatelessWidget {
  CircleMap({Key? key}) : super(key: key);

  final CircleMapController circleMapController =
      Get.put(CircleMapController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Circle Select Map"),
      ),
      body: GetBuilder<CircleMapController>(
        init: circleMapController,
        builder: (controller) => GoogleMap(
          markers: controller.allMarkers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomGesturesEnabled: true,
          compassEnabled: true,
          scrollGesturesEnabled: true,
          rotateGesturesEnabled: true,
          tiltGesturesEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(21.213658042830602, 72.84388298826511),
            zoom: 12,
          ),
          onMapCreated: (GoogleMapController mapController) async {
            controller.googleMapController = mapController;
            var style = await rootBundle.loadString("assets/map_style.json");
            print(" style => $style");
            mapController.setMapStyle(style);
          },
          onTap: (latLng) {
            controller.centerLat = latLng.latitude;
            controller.centerLng = latLng.longitude;

            controller.centerLatLngPoint = latLng;
            print(
                "controller.centerLatLngPoint => ${controller.centerLatLngPoint}");
            controller.setCircleFun();
          },
          circles: controller.circles,
        ),
      ),
    );
  }
}
