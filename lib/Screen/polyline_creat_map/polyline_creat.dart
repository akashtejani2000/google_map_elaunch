import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map_elaunch/Screen/polyline_creat_map/polyline_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolyLineCreate extends StatelessWidget {
  const PolyLineCreate({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetBuilder<PolyLineController>(
      init: PolyLineController(),
      builder: (controller)=>
       Scaffold(
        appBar: AppBar(),
        body: GoogleMap(
          onMapCreated: controller.onMapCreate,
          mapType: MapType.hybrid,
          initialCameraPosition: CameraPosition(target: controller.SOURCE_LOCATION, zoom: 15),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          markers:Set<Marker>.of(controller.markers.values),
          polylines: Set<Polyline>.of(controller.polylines.values),
          mapToolbarEnabled: true,
          compassEnabled: true,
          buildingsEnabled: false,
        ),
      ),
    );
  }
}
