import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wcenzije/models/review.dart';
import 'package:wcenzije/screens/permission.dart';
import 'package:wcenzije/services/geolocator.dart';
import 'package:wcenzije/widgets/map.dart';
import 'package:wcenzije/services/reviews_repo.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final repo = ReviewsRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: FutureBuilder<bool>(
        future: isLocationEnabled(),
        builder: (context, snapshot) => snapshot.hasData
            ? snapshot.data!
                ? map()
                : const PermissionScreen()
            : progressIndicator(),
      ),
    );
  }

  FutureBuilder<MapData> map() {
    return FutureBuilder<MapData>(
      future: loadMapData(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Map(snapshot.data!.reviews, snapshot.data!.position)
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
      },
    );
  }

  Future<bool> isLocationEnabled() async {
    final error = await getPermissionError();
    return error == null;
  }

  Future<MapData> loadMapData() async {
    final reviews = await repo.getReviews();
    final location = await determinePosition();

    return MapData(reviews, location);
  }

  bool isLocationPermissionGranted() => false;

  progressIndicator() => const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
}

class MapData {
  final List<Review> reviews;
  final Position position;

  MapData(this.reviews, this.position);
}
