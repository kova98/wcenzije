import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wcenzije/models/review.dart';

import '../helpers/assets_helper.dart';
import '../helpers/google_maps_helper.dart';

class Map extends StatefulWidget {
  final List<Review>? reviews;
  const Map(
    this.reviews, {
    Key? key,
  }) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
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
        markers: _getMarkers(),
      ),
    );
  }

  Set<Marker> _getMarkers() {
    var markers = widget.reviews
        ?.where((element) => element.location.isNotEmpty)
        .map(
          (e) => Marker(
            markerId: MarkerId(e.id.toString()),
            infoWindow: InfoWindow(title: _getTitle(e)),
            icon: icon,
            position: _getPosition(e.location),
          ),
        )
        .toSet();

    return markers ?? <Marker>{};
  }

  String _getTitle(Review e) {
    return "${e.name} ⭐${e.rating}";
  }

  LatLng _getPosition(String location) {
    final locations = location.split(',').map((e) => double.parse(e)).toList();
    return LatLng(locations[0], locations[1]);
  }
}