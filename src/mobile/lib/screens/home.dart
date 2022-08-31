import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wcenzije/models/review.dart';
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
      body: FutureBuilder<MapData>(
        future: loadMapData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // remove the splash screen and show the map
            FlutterNativeSplash.remove();
            return Map(snapshot.data!.reviews, snapshot.data!.position);
          }

          // this text is unnecessary, because the splash screen overlaps it
          return const Text("Loading ...");
        },
      ),
    );
  }

  Future<MapData> loadMapData() async {
    final reviews = await repo.getReviews();
    final location = await determinePosition();

    return MapData(reviews, location);
  }
}

class MapData {
  final List<Review> reviews;
  final Position position;

  MapData(this.reviews, this.position);
}
