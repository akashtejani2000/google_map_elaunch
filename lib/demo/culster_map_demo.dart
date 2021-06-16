import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late ClusterManager _manager;

  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> markers = Set();

  final CameraPosition _parisCameraPosition = CameraPosition(target: LatLng(48.856613, 2.352222), zoom: 12.0);

  List<ClusterItem<Place>> items = [
    for (int i = 0; i < 10; i++)
      ClusterItem(LatLng(48.848200 + i * 0.001, 2.319124 + i * 0.001), item: Place(name: 'Place $i')),
  ];

  @override
  void initState() {
    _manager = _initClusterManager();
    print("managerss : ${_manager.toString()}");
    super.initState();
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<Place>(
      items,
      _updateMarkers,
      markerBuilder: _markerBuilder,
      initialZoom: _parisCameraPosition.zoom,
      stopClusteringZoom: 17.0,
    );
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length}');
    setState(() {
      this.markers = markers;
      print('length ${markers.length}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _parisCameraPosition,
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          _manager.setMapController(controller);
        },
        onCameraMove: _manager.onCameraMove,
        onCameraIdle: _manager.updateMap,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _manager.setItems(<ClusterItem<Place>>[
      //       for (int i = 0; i < 30; i++)
      //         ClusterItem<Place>(LatLng(48.858265 + i * 0.01, 2.350107),
      //             item: Place(name: 'New Place ${DateTime.now()}'))
      //     ]);
      //   },
      //   child: Icon(Icons.update),
      // ),
    );
  }

  Future<Marker> Function(Cluster<Place>) get _markerBuilder => (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            print('---- $cluster');
            cluster.items.forEach((p) => print(p));
          },
          icon: BitmapDescriptor.defaultMarker,
        );
      };

// Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
//   if (kIsWeb) size = (size / 2).floor();
//
//   final PictureRecorder pictureRecorder = PictureRecorder();
//   final Canvas canvas = Canvas(pictureRecorder);
//   final Paint paint1 = Paint()..color = Colors.orange;
//   final Paint paint2 = Paint()..color = Colors.white;
//
//   canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
//   canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
//   canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);
//
//   if (text != null) {
//     TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
//     painter.text = TextSpan(
//       text: text,
//       style: TextStyle(fontSize: size / 3, color: Colors.white, fontWeight: FontWeight.normal),
//     );
//     painter.layout();
//     painter.paint(
//       canvas,
//       Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
//     );
//   }
//
//   final img = await pictureRecorder.endRecording().toImage(size, size);
//   final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;
//
//   return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
// }
}

class Place {
  final String name;
  final bool isClosed;

  const Place({required this.name, this.isClosed = false});

  @override
  String toString() {
    return 'Place $name (closed : $isClosed)';
  }
}
