import 'dart:async';
import 'dart:math' as Math;
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart' as Math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPageController extends GetxController with SingleGetTickerProviderMixin {
  GoogleMapController googleMapController;
  Set<Marker> markers = Set<Marker>();

  Set<Polyline> polyLineSet = Set<Polyline>();

  LatLng latLng;

  Uint8List imageData;
  var count = 0;

  AnimationController animationController;

  List<LatLng> latLngPointsList = [
    LatLng(21.22190131006155, 72.83836695702882),
    LatLng(21.22275016134548, 72.83780087268407),
    LatLng(21.222942855938225, 72.83780778089437),
    LatLng(21.223051688840314, 72.83771013449831),
    LatLng(21.223154585328437, 72.83761673359771),
    LatLng(21.22346129560173, 72.83772923923357),
    LatLng(21.223793729228035, 72.83785872684575),
    LatLng(21.22395598822599, 72.83785448135028),
    LatLng(21.224442553401833, 72.83779948925763),
    LatLng(21.225902565827887, 72.8378033257401),
    LatLng(21.22657318965393, 72.83785909565901),
    LatLng(21.226676358306417, 72.83794447543742),
    LatLng(21.22680900361071, 72.83792866436735),
    LatLng(21.226940700379455, 72.83805443800792),
    LatLng(21.227480009653796, 72.83812742213411),
    LatLng(21.22987575266803, 72.83847276610086),
    LatLng(21.231061794718176, 72.83890537768949),
    LatLng(21.2317751090895, 72.83972439114508),
    LatLng(21.233179803226673, 72.841648089604),
    LatLng(21.233971216896546, 72.84281020331613),
    LatLng(21.236689966708035, 72.84640937410185),
    LatLng(21.237440097100574, 72.84736594387553),
    LatLng(21.238928205903132, 72.84911721344803),
    LatLng(21.240222713612063, 72.85078297590961),
    LatLng(21.24077614256277, 72.8514498642168),
    LatLng(21.24160512898975, 72.85255547094089),
    LatLng(21.244017892598965, 72.85539719089262),
    LatLng(21.24411772306675, 72.85545011906983),
    LatLng(21.2441932408191, 72.85546092223395),
    LatLng(21.24424694230834, 72.85554014543732),
    LatLng(21.24647542443129, 72.85626053670735),
    LatLng(21.246497233553047, 72.85653840682517),
    LatLng(21.24629277291057, 72.85732814302338),
    LatLng(21.24554602748139, 72.8611712685309),
    LatLng(21.24636932479441, 72.86147253826978),
    LatLng(21.24645383518409, 72.86130874114771),
    LatLng(21.246633578572983, 72.86126981118731),
  ];

  @override
  void onInit() {
    getMarker().then(
      (value) => imageData = value,
    );
    latLng = latLngPointsList[0];
    polyLineSet.add(
      Polyline(
        polylineId: PolylineId(
          LatLng(21.22190131006155, 72.83836695702882).toString(),
        ),
        points: latLngPointsList,
        color: Colors.red,
        width: 10,
        visible: true,
      ),
    );
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      lowerBound: 0.0,
      upperBound: 1.0,
      value: 0.0,
    );
    animationController.addListener(animationListener);
    carAnimation();
    update();
    super.onInit();
  }

  @override
  void onClose() {
    googleMapController.dispose();
    super.onClose();
  }

  animationListener() {
    if (count >= latLngPointsList.length - 2) {
      return;
    }
    var sourceLatlng = this.latLng;
    var targetLatlng = latLngPointsList[count + 1];

    var latDifference = sourceLatlng.latitude - targetLatlng.latitude;
    var lngDifference = sourceLatlng.longitude - targetLatlng.longitude;

    var currentLatlng = LatLng(
      sourceLatlng.latitude - (latDifference * animationController.value),
      sourceLatlng.longitude - (lngDifference * animationController.value),
    );

    print("sourceLatlng ->$sourceLatlng");
    print("targetLatlng -> $targetLatlng");
    print("difference -> $latDifference  -> $lngDifference");
    print("currentLatlng -> $currentLatlng");

    double angle = bearingBetweenLocations(currentLatlng, targetLatlng);
    print("angle : $angle");
    updateMarkerAndCircle(currentLatlng, angle: angle);
    moveCarCameraPosition(currentLatlng);
  }

  carAnimation() async {
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (latLngPointsList.length != 0 && latLngPointsList.length > count + 1) {
          LatLng newLatlng = latLngPointsList[++count];
          double angle = bearingBetweenLocations(latLng, newLatlng);
          print("CarAngles : $angle");
          latLng = newLatlng;
          updateMarkerAndCircle(latLng, angle: angle);
          if (googleMapController != null) {
            moveCarCameraPosition(latLng);
            update();
          }
          animationController.forward(from: 0.0);
        }
      }
    });
  }

  void onMapCreate(GoogleMapController mapController) {
    googleMapController = mapController;
    updateMarkerAndCircle(latLng);
    animationController.forward(from: 0.0);
    update();
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData = await rootBundle.load("assets/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LatLng newLatLng, {double angle}) async {
    markers.clear();

    print("update : $angle");
    markers.add(
      Marker(
        markerId: MarkerId('$newLatLng'),
        infoWindow: InfoWindow(
          title: '${newLatLng.toString()}',
        ),
        position: newLatLng,
        draggable: true,
        visible: true,
        zIndex: 2,
        anchor: Offset(1.0, 1.0),
        rotation: angle,
        icon: imageData != null ? BitmapDescriptor.fromBytes(imageData) : BitmapDescriptor.defaultMarker,
      ),
    );
    update();
  }

  // void latLngPositionChange() async {
  //   if (latLngPointsList.length != 0 && latLngPointsList.length > count + 1) {
  //     latLng = latLngPointsList[++count];
  //     updateMarkerAndCircle(latLng);
  //     if (googleMapController != null) {
  //       googleMapController.animateCamera(
  //         CameraUpdate.newCameraPosition(
  //           CameraPosition(
  //             target: latLng,
  //             zoom: 15,
  //           ),
  //         ),
  //       );
  //       update();
  //     }
  //   }
  //   update();
  // }

  moveCarCameraPosition(LatLng latLng) {
    googleMapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: 16,
        ),
      ),
    );
  }

  double bearingBetweenLocations(LatLng latLng1, LatLng latLng2) {
    double PI = 3.14159;
    double lat1 = latLng1.latitude * PI / 180;
    double long1 = latLng1.longitude * PI / 180;
    double lat2 = latLng2.latitude * PI / 180;
    double long2 = latLng2.longitude * PI / 180;

    double dLon = (long2 - long1);

    double y = Math.sin(dLon) * Math.cos(lat2);
    double x = Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(dLon);

    double brng = Math.atan2(y, x);
    brng = Math.degrees(brng);

    // brng = brng / 180;
    // brng = (brng + 360) % 360;

    print("bearingBetweenLocations : ${brng.toString()}");

    return brng;
  }
}
