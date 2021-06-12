import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map_elaunch/Screen/google_map_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatelessWidget {
  final MapPageController mapController = Get.put(MapPageController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapPageController>(
      init: mapController,
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text("Google Map"),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GoogleMap(
            onMapCreated: controller.onMapCreate,
            mapType: MapType.hybrid,
            initialCameraPosition: CameraPosition(target: controller.latLng, zoom: 15, tilt: 0.0, bearing: 0.0),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: controller.markers,
            polylines: controller.polyLineSet,
          ),
        ),
      ),
    );
  }
}
