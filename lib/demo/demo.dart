import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapDemo extends StatefulWidget {
  @override
  _GoogleMapDemoState createState() => _GoogleMapDemoState();
}

class _GoogleMapDemoState extends State<GoogleMapDemo> {
  List<LatLng> la_lo_list = [
    LatLng(21.228323616196022, 72.90470903023018),
    LatLng(21.23015111489002, 72.90212199808546),
    LatLng(21.230020580020497, 72.90109013349253),
    LatLng(21.230058366441988, 72.90089850149668),
    LatLng(21.2309532844579, 72.90081406264702),
    LatLng(21.23046307706666, 72.89874552144066),
  ];

  BitmapDescriptor? sourceIcon;
  BitmapDescriptor? destinationIcon;
  PolylinePoints? polylinePoints;
  GoogleMapController? _controller;
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];

  LatLng? latLng;
  int index = 0;

  Marker? marker;
  Circle? circle;
  late Timer timer;
  late CameraPosition initialLocation;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        polylinePoints = PolylinePoints();
        latLng = la_lo_list[0];
        print("latLang :${latLng}");
        initialLocation = CameraPosition(
          target: latLng!,
          zoom: 15,
        );
      });
      _polylines.add(Polyline(
        polylineId: PolylineId(LatLng(21.23046307706666, 72.89874552144066).toString()),
        visible: true,
        points: la_lo_list,
        color: Colors.blue,
      ));
      startTimer();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Map'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        polylines: _polylines,
        markers: Set.of((marker != null) ? [marker!] : []),
        circles: Set.of((circle != null) ? [circle!] : []),
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _controller = controller;
            updateMarkerAndCirlcle(latLng);
          });
        },
      ),
    );
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/car_icon.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCirlcle(LatLng? newLatLng) async {
    Uint8List imageData = await getMarker();
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latLng!,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
        circleId: CircleId("car"),
        zIndex: 1,
        strokeColor: Colors.redAccent,
        center: latLng!,
        fillColor: Colors.redAccent.withAlpha(50),
      );
    });
  }

  startTimer() {
    timer = Timer(Duration(seconds: 5), () {
      trackDriver();
      startTimer();
    });
  }

  trackDriver() {
    if (la_lo_list.length != 0) {
      setState(() {
        index = index + 1;
        latLng = la_lo_list[index];
        if (_controller != null) {
          _controller!.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
            target: latLng!,
            zoom: 17,
            bearing: 192.8334901395799,
            tilt: 0,
          )));
        }
        updateMarkerAndCirlcle(latLng);
      });
    }
  }
}
