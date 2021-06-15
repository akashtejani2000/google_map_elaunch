import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map_elaunch/Screen/polyline_animated_car_map_custom/google_map_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatelessWidget {
  final MapPageController mapController = Get.put(MapPageController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapPageController>(
      init: mapController,
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text("Car Animation Google Map"),
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                onMapCreated: controller.onMapCreate,
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(target: controller.latLng, zoom: 19),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: true,
                markers: controller.markers,
                polylines: controller.polyLineSet,
                mapToolbarEnabled: true,
                compassEnabled: true,
                buildingsEnabled: false,
              ),
            ),
            Container(
              color: Colors.red,
              child: Text(
                "DISTANCE: ${controller.placeDistance} meter",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
