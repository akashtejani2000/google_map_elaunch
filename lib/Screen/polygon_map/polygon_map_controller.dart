import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolyGonController extends GetxController {
  GoogleMapController? googleMapController;

  late List<LatLng> polygonCoords = [
    LatLng(21.22187130626281, 72.83825966867101),
    LatLng(21.220771162761974, 72.83957931547197),
    LatLng(21.222531388426038, 72.83999774006739),
    LatLng(21.222801421187153, 72.83828112634258),
  ];

  List<LatLng> placeList = [
    LatLng(21.221769726340767, 72.838282719623),
    LatLng(21.22166361140364, 72.83854697810983),
    LatLng(21.221659821583035, 72.83889254690033),
    LatLng(21.221898580090418, 72.83975443611897),
    LatLng(21.222160077059964, 72.83947391557138),
    LatLng(21.222300299881727, 72.83907549508353),
    LatLng(21.221792465245944, 72.83985200848333),
    LatLng(21.22262243288647, 72.83906736405315),
    LatLng(21.22251631856259, 72.8381200990157),
    LatLng(21.22183415322966, 72.83642071366954),
    LatLng(21.227371285543406, 72.83617535719961),
    LatLng(21.22612770602335, 72.83338829567785),
    LatLng(21.223431195608775, 72.83827555995772),
    LatLng(21.225167310670628, 72.83926622161624),
    LatLng(21.22190438243339, 72.8315126429887),
    LatLng(21.220574564569343, 72.8425155920296),
  ];

  Set<Marker> marker = Set();
  var polygonSet = Set<Polygon>();

  @override
  void onInit() {
    super.onInit();
    print(
      "polygonCoords => ${polygonCoords.length}",
    );
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
}
