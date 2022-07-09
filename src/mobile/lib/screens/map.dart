import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/assets_helper.dart';
import '../helpers/google_maps_helper.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  BitmapDescriptor icon = BitmapDescriptor.defaultMarker;

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(45.81008366919697, 15.97100945646627),
    zoom: 18,
  );

  @override
  void initState() {
    AssetsHelper.getBytesFromAsset('assets/images/wcenzija-icon.png', 64)
        .then((onValue) {
      setState(() {
        icon = BitmapDescriptor.fromBytes(onValue);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (GoogleMapController c) {
          GoogleMapsHelper.changeMapMode(c, "assets/maps_style.json");
        },
        myLocationButtonEnabled: false,
        zoomControlsEnabled: true,
        initialCameraPosition: _initialCameraPosition,
        markers: {
          Marker(
              markerId: const MarkerId('test'),
              infoWindow: const InfoWindow(title: 'Hemingway Bistro/Bar ⭐8'),
              icon: icon,
              position: const LatLng(45.81008366919697, 15.97100945646627),
              flat: true)
        },
      ),
    );
  }
}
