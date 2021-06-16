import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'polygon_map_controller.dart';

class PolyGonMap extends StatelessWidget {
  PolyGonMap({Key? key}) : super(key: key);

  final PolyGonController polyGonController = Get.put(PolyGonController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("PolyGon Map"),
      ),
      body: GetBuilder<PolyGonController>(
        init: polyGonController,
        builder: (controller) => GoogleMap(
          markers: controller.marker,
          myLocationEnabled: true,
          mapType: MapType.hybrid,
          initialCameraPosition: CameraPosition(
            target: LatLng(21.222290569123086, 72.83940025309943),
            zoom: 17,
          ),
          onMapCreated: (GoogleMapController mapController) {
            controller.googleMapController = mapController;
          },
          polygons: controller.myPolygon(),
        ),
      ),
    );
  }
}
