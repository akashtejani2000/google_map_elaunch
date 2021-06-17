import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClusterMapController extends GetxController with SingleGetTickerProviderMixin {
  late ClusterManager clusterManager;

  Completer<GoogleMapController> googleMapController = Completer();

  Set<Marker> marker = Set();

  CameraPosition initialPosition = CameraPosition(target: LatLng(21.2218913087904, 72.838238211187), zoom: 12);
  List<ClusterItem<Place>> placeList = [];

  List<LatLng> latLngPointsList = [
    LatLng(21.22190131006155, 72.83836695702882),
    LatLng(21.22275016134548, 72.83780087268407),
    LatLng(21.222942855938225, 72.83780778089437),
    LatLng(21.223051688840314, 72.83771013449831),
    LatLng(21.223154585328437, 72.83761673359771),
    LatLng(21.22346129560173, 72.83772923923357),
    LatLng(21.223793729228035, 72.83785872684575),
    LatLng(21.22395598822599, 72.83785448135028),
    LatLng(21.081789981941146, 72.65069864472798),
    LatLng(21.068934799514167, 72.89805360457126),
    LatLng(21.237132675251274, 72.81852428836848),
    LatLng(21.160649691853113, 72.83918938627944),
    LatLng(21.159481705981694, 72.83230102030912),
    LatLng(21.131447281261583, 72.83292723539732),
    LatLng(21.15889770959002, 72.85296611822008),
    LatLng(21.126774361454583, 72.82916994486806),
    LatLng(21.15889770959002, 72.87112635577819),
  ];

  @override
  void onInit() {
    placeList = latLngPointsList
        .map(
          (element) => ClusterItem(
            LatLng(element.latitude, element.longitude),
            item: Place(placeName: 'Place $element'),
          ),
        )
        .toList();

    print("placeList 2 => ${placeList.toString()}");

    clusterManager = initClusterManager();

    super.onInit();
  }

  ClusterManager initClusterManager() {
    return ClusterManager<Place>(
      placeList,
      updateMarker,
      markerBuilder: markerBuilder,
      initialZoom: initialPosition.zoom,
      stopClusteringZoom: 20,
    );
  }

  void updateMarker(Set<Marker> markers) {
    print("updatess  ${marker.length}");
    print("placeList 2 => ${placeList.length}");
    this.marker = markers;
    print("length  ${marker.length}");
    update();
  }

  Future<Marker> markerBuilder(Cluster<Place> cluster) async {
    debugPrint("==>${cluster.location}");
    return Marker(
      markerId: MarkerId(cluster.getId().toString()),
      icon: BitmapDescriptor.defaultMarker,
      position: cluster.location,
      anchor: Offset(0.5, 0.5),
      infoWindow: InfoWindow(
          title: "${cluster.location}",
          onTap: () {
            CameraUpdate.newCameraPosition(CameraPosition(target: cluster.location, zoom: 18));
            Get.bottomSheet(
              buildBottomNavigationMethod(
                locationData: "${cluster.location}",
                getId: cluster.getId(),
              ),
              backgroundColor: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                ),
              ),
            );
          }),
    );
  }

  Widget buildBottomNavigationMethod({required String locationData, required String getId}) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/download.jpeg"), fit: BoxFit.cover),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 70,
                  width: 70,
                  color: Colors.amber,
                ),
                Container(
                  height: 70,
                  width: 70,
                  color: Colors.amber,
                ),
                Container(
                  height: 70,
                  width: 70,
                  color: Colors.amber,
                )
              ],
            ),
          ),
          ListTile(
            title: Text(
              locationData,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            trailing: IconButton(
              onPressed: () {
                Clipboard.setData(
                  new ClipboardData(text: getId),
                );
              },
              icon: Icon(
                Icons.copy,
                size: 25.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Place {
  final String placeName;

  const Place({required this.placeName});
}
