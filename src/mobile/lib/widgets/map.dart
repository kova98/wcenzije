import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:collection/collection.dart";
import 'package:wcenzije/models/review.dart';
import 'package:wcenzije/screens/login.dart';
import 'package:wcenzije/screens/review.dart';
import 'package:wcenzije/screens/reviews.dart';
import 'package:wcenzije/services/auth.dart';

import '../helpers/assets_helper.dart';
import '../helpers/google_maps_helper.dart';
import '../screens/add_review/where.dart';

class Map extends StatefulWidget {
  final List<Review>? reviews;
  final Position position;
  const Map(
    this.reviews,
    this.position, {
    Key? key,
  }) : super(key: key);

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  BitmapDescriptor icon = BitmapDescriptor.defaultMarker;
  final authService = AuthService();

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
    final _initialCameraPosition = CameraPosition(
      target: LatLng(widget.position.latitude, widget.position.longitude),
      zoom: 18,
    );

    return Scaffold(
      body: GoogleMap(
        onMapCreated: (GoogleMapController c) {
          GoogleMapsHelper.changeMapMode(c, "assets/maps_style.json");
        },
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        markers: _getMarkers(context),
      ),
    );
  }

  Set<Marker> _getMarkers(BuildContext context) {
    final markers = _groupReviews(widget.reviews ?? [])
        .where((toilet) => toilet.reviews[0].location.isNotEmpty)
        .map(
          (toilet) => Marker(
            markerId: MarkerId(toilet.reviews[0].id.toString()),
            infoWindow: InfoWindow(title: toilet.name),
            icon: icon,
            position: _getPosition(toilet.reviews[0].location),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => toilet.reviews.length == 1
                      ? ReviewScreen(toilet.reviews[0].id)
                      : ReviewsScreen(sortByDate(toilet.reviews)),
                ),
              )
            },
          ),
        )
        .toSet();

    return markers;
  }

  LatLng _getPosition(String location) {
    final locations = location.split(',').map((e) => double.parse(e)).toList();
    return LatLng(locations[0], locations[1]);
  }

  List<Toilet> _groupReviews(List<Review> reviews) {
    List<Toilet> toilets = [];

    widget.reviews
        ?.groupListsBy((element) => element.name)
        .forEach((key, value) {
      toilets.add(Toilet(key, value));
    });

    return toilets;
  }

  List<Review> sortByDate(List<Review> reviews) {
    reviews.sort((a, b) => (b.dateCreated).compareTo(a.dateCreated));

    return reviews;
  }
}

class Toilet {
  String name;
  List<Review> reviews;
  Toilet(this.name, this.reviews);
}
