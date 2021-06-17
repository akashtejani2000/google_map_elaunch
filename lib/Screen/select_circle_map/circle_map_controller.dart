import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_utils/google_maps_utils.dart';

class CircleMapController extends GetxController {

  Set<Marker> allMarkers = Set();
  Set<Circle> circles = Set();

  GoogleMapController? googleMapController;
  late var insideArea;

  var lat, lng;

  late List place;
  double circleRadius = 6000.0;
  var centerLatLngPoint=LatLng(21.193912310336838, 72.83437005862646);

  var centerLat;
  var centerLng;

  List<Point<double>> latLngList = [
    Point(21.203812200554875, 72.83914826310561),
    Point(21.179530955782614, 72.86033523645071),
    Point(21.193912310336000, 72.83437005862646),
    Point(21.19170912056616, 72.78575974202593),
    Point(21.194227049051115, 72.88433066179923),
    Point(21.200206957236087, 72.78913545845654),
    Point(21.224753516668137, 72.86238850500038),
    Point(21.253700619829946, 72.87757922893805),
    Point(21.15081767909394, 72.843569445249),
    Point(21.165545890002747, 72.8882014015835),
    Point(21.253700619829946, 72.87757922893805),
    Point(21.21356247793684, 72.84013621783865),
    Point(21.149536895860773, 72.7694117331855),
    Point(21.08612429304789, 72.73027294070755),
    Point(21.07459181827238, 72.77696483348826),
    Point(21.077154667768426, 72.8724085554959),
    Point(21.250684601063092, 72.92390696665109),
    Point(21.27756030176452, 72.94999949496973),
    Point(21.171308704027343, 72.92116038472282),
    Point(21.16618621375599, 72.71859996751239),
    Point(21.116873182570632, 72.68770092081927),
    Point(21.11297791827105, 72.68076893296782),
    Point(21.104575981685375, 72.85233990313188),
    Point(21.081789981941146, 72.65069864472798),
    Point(21.068934799514167, 72.89805360457126),
    Point(21.237132675251274, 72.81852428836848),
    Point(21.160649691853113, 72.83918938627944),
    Point(21.159481705981694, 72.83230102030912),
    Point(21.131447281261583, 72.83292723539732),
    Point(21.15889770959002, 72.85296611822008),
    Point(21.126774361454583, 72.82916994486806),
    Point(21.15889770959002, 72.87112635577819),

  ];

  @override
  void onInit() {
    super.onInit();

  }

  setCircleFun() {
    circles = Set.from([
      Circle(
        circleId: CircleId("id"),
        center: centerLatLngPoint,
        fillColor: Colors.blue.withOpacity(0.2),
        strokeColor: Colors.blue,
        strokeWidth: 3,
        radius: circleRadius,
        onTap: (){},
      )
    ]);
    print("circleCreate => $circles");
    initMarker();
    update();
  }

  initMarker() {

    print("centerLat => ${centerLat.toString()}");
    print("centerLng => ${centerLng.toString()}");

    allMarkers.clear();

    place = latLngList.map((element) {
      var insidePoint = SphericalUtils.computeDistanceBetween(
          Point(centerLat, centerLng), Point(element.x, element.y));
      print("insidePoint => ${insidePoint.toString()}");
      print("circleRadius => ${insidePoint<=circleRadius}");

      if(insidePoint<=circleRadius)
        {
          allMarkers.add(
            Marker(
              markerId: MarkerId('${element.x}'),
              visible: true,
              icon: BitmapDescriptor.defaultMarker,
              position: LatLng(element.x, element.y),
              infoWindow: InfoWindow(
                title: "${element.x},${element.y}",
                anchor: Offset(0.5,0.5)
              )
            ),
          );
        }
    }).toList();
    update();
  }

  //   LatLng createCenter() {
  //   return createLatLng(lat , lng);
  // }
  //
  // LatLng createLatLng(double lat, double lng) {
  //   return LatLng(lat, lng);
  // }

  // LatLng _createCenter() {
  //   return _createLatLng(lat , lng);
  // }
  //
  // LatLng _createLatLng(double lat, double lng) {
  //   return LatLng(lat, lng);
  // }

}
