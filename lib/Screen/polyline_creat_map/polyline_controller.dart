import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolyLineController extends GetxController {
  Completer<GoogleMapController> googleMapController = Completer();

  Map<MarkerId, Marker> markers = {};
  Set<Polyline> polyLineSet = Set<Polyline>();

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  LatLng SOURCE_LOCATION = LatLng(21.223049012377167, 72.83846883184574);
  LatLng DEST_LOCATION = LatLng(21.24665325248579, 72.8612935825404);

  @override
  void onInit() {
    print("aaa");
    super.onInit();
    addMarker(
      position: SOURCE_LOCATION,
      id: "start",
      descriptor: BitmapDescriptor.defaultMarker,
    );

    addMarker(
      position: DEST_LOCATION,
      id: "end",
      descriptor: BitmapDescriptor.defaultMarker,
    );
    getPolyline();
  }

  addMarker(
      {required LatLng position,
      required String id,
      required BitmapDescriptor descriptor}) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
    update();
  }

  void getPolyline() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCJSSoADH9PPf_zHollNGjS0CR0H4ZZb3E",
      PointLatLng(SOURCE_LOCATION.latitude, SOURCE_LOCATION.longitude),
      PointLatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude),
      travelMode: TravelMode.driving,
    );
    print("decodePoint => $result");
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
    update();
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    update();
  }

  void onMapCreate(GoogleMapController mapController) {
    googleMapController.complete(mapController);
    update();
  }
}
