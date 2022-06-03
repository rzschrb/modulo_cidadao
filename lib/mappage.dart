import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:projetoint_all/main.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mapa Zona Azul',
      home: MapHome(title: 'Mapa Zona Azul'),
    );
  }
}

class MapHome extends StatefulWidget {
  const MapHome({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MapHome> createState() => _MapHome();
}

class _MapHome extends State<MapHome> {

  late GoogleMapController mapController;
  final Location _location = Location();

  final LatLng _center = const LatLng(-22.832916, -47.053429);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
            children: [
              GoogleMap(
                polygons: pucPolygons(),
                myLocationEnabled: true,
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 18.5,
                ),
              ),
              Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 0, 0),
                  child:
                  BackButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => MyApp())
                      );
                    },
                  ),
              ),
            ]
        ),
      ),
    );
  }
}

Set<Polygon> pucPolygons() {
  List<LatLng> polygonOne = [];
  List<LatLng> polygonTwo = [];
  List<LatLng> polygonThree = [];

  polygonOne.add(LatLng(-22.832354, -47.053681));
  polygonOne.add(LatLng(-22.832315, -47.053387));
  polygonOne.add(LatLng(-22.832554, -47.053366));
  polygonOne.add(LatLng(-22.832585, -47.053609));

  polygonTwo.add(LatLng(-22.832617, -47.053595));
  polygonTwo.add(LatLng(-22.832585, -47.053359));
  polygonTwo.add(LatLng(-22.832956, -47.053292));
  polygonTwo.add(LatLng(-22.832962, -47.053524));

  polygonThree.add(LatLng(-22.833036, -47.053508));
  polygonThree.add(LatLng(-22.832992, -47.053312));
  polygonThree.add(LatLng(-22.833850, -47.053140));
  polygonThree.add(LatLng(-22.833850, -47.053374));

  Set<Polygon> polygonSet = new Set();
  polygonSet.add(Polygon(
    polygonId: PolygonId('PUCGreen'),
    points: polygonOne,
    strokeColor: Colors.black,
    strokeWidth: 2,
    fillColor: Colors.green.withAlpha(50)
  ));

  polygonSet.add(Polygon(
      polygonId: PolygonId('PUCOrange'),
      points: polygonTwo,
      strokeColor: Colors.black,
      strokeWidth: 2,
      fillColor: Colors.orange.withAlpha(50)
  ));

  polygonSet.add(Polygon(
      polygonId: PolygonId('PUCRed'),
      points: polygonThree,
      strokeColor: Colors.black,
      strokeWidth: 2,
      fillColor: Colors.red.withAlpha(50)
  ));

  return polygonSet;
}
