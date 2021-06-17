import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolyGonController extends GetxController {
  GoogleMapController? googleMapController;

  late List<LatLng> polygonCoords = [
    LatLng(21.200402157613524, 72.79105569634568),
    LatLng(21.171126912319103, 72.83443350742971),
    LatLng(21.2046388836719, 72.86872263424188),
    LatLng(21.22659088069598, 72.83319414137446),
  ];

  List<LatLng> placeList = [
    LatLng(21.175749704759433, 72.82988916531876),
    LatLng(21.203098269447082, 72.85467648592395),
    LatLng(21.196165309405536, 72.89557556492245),
    LatLng(21.24276394588452, 72.81584301697583),
    LatLng(21.201172479852904, 72.81047243084471),
    LatLng(21.14916667591062, 72.8079936987842),
    LatLng(21.20926062739883, 72.83112853134901),
    LatLng(21.201172479852904, 72.81047243084471),
    LatLng(21.21311197051872, 72.84269594763144),
    LatLng(21.21773344962868, 72.82493170119774),
    LatLng(21.252389928379607, 73.02570899809959),
    LatLng(21.295506606351836, 72.89350995487203),
  ];

  late List place;

  Set<Marker> marker = Set();
  var polygonSet = Set<Polygon>();
  late bool insideArea;

  @override
  void onInit() {
    super.onInit();
    mapMarker();
  }

  mapMarker() {
    place = placeList.map((element) {

      insideArea = checkPolyGonAreaMarker(
          LatLng(element.latitude, element.longitude), polygonCoords);

      if (insideArea) {
        marker.add(
          Marker(
            markerId: MarkerId("${element.latitude},${element.longitude}"),
            anchor: Offset(0.5, 0.5),
            icon: BitmapDescriptor.defaultMarker,
            position: LatLng(element.latitude, element.longitude),
            infoWindow:
                InfoWindow(title: "${element.latitude},${element.longitude}"),
            visible: true,
          ),
        );
      }
    }).toList();

    update();
  }

  Set<Polygon> myPolygon() {
    polygonSet.add(
      Polygon(
        polygonId: PolygonId('1'),
        points: polygonCoords,
        strokeColor: Colors.red,
        strokeWidth: 2,
        fillColor: Colors.red.withOpacity(0.5),
      ),
    );
    return polygonSet;
  }

  bool checkPolyGonAreaMarker(LatLng latLang, List<LatLng> latLngList) {
    int intersectCount = 0;
    for (int i = 0; i < latLngList.length - 1; i++) {
      if (rayCastIntersect(latLang, latLngList[i], latLngList[i + 1])) {
        intersectCount++;
        debugPrint("intersectCount $intersectCount");
      }
    }
    return ((intersectCount % 2) == 1);
  }

  bool rayCastIntersect(LatLng latLng, LatLng vertA, LatLng vertB) {
    double aY = vertA.latitude;
    double bY = vertB.latitude;
    double aX = vertA.longitude;
    double bX = vertB.longitude;
    double pY = latLng.latitude;
    double pX = latLng.longitude;
    if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
      return false;
    }
    double m = (aY - bY) / (aX - bX); // Rise over run
    double bee = (-aX) * m + aY; // y = mx + b
    double x = (pY - bee) / m; // algebra is neat!

    debugPrint("point inside => $x");

    return x > pX;
  }
}
