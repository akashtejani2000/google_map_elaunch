import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'cluster_map_controller.dart';

class ClusterMap extends StatefulWidget {
  @override
  _ClusterMapState createState() => _ClusterMapState();
}

class _ClusterMapState extends State<ClusterMap> {
  final ClusterMapController controller = Get.put(ClusterMapController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cluster Map"),
        centerTitle: true,
      ),
      body: GetBuilder<ClusterMapController>(
        init: controller,
        builder: (controller) => Stack(
          fit: StackFit.expand,
          children: [
            GoogleMap(
              onMapCreated: (GoogleMapController mapController) {
                controller.googleMapController.complete(mapController);
                controller.clusterManager.setMapController(mapController);
              },
              initialCameraPosition: controller.initialPosition,
              onCameraMove: controller.clusterManager.onCameraMove,
              onCameraIdle: controller.clusterManager.updateMap,
              mapType: MapType.normal,
              markers: controller.marker,
            ),
            /* DraggableScrollableSheet(
              initialChildSize: 0.30,
              minChildSize: 0.15,
              builder: (BuildContext context, ScrollController scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    height: 100.0,
                  ),
                );
              },
            ),*/
          ],
        ),
      ),
    );
  }
}

class PlaceList {
  final String placeName;

  PlaceList({required this.placeName});
}
