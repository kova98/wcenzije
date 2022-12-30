import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wcenzije/models/review.dart';
import 'package:wcenzije/screens/permission.dart';
import 'package:wcenzije/screens/profile.dart';
import 'package:wcenzije/services/auth.dart';
import 'package:wcenzije/services/geolocator.dart';
import 'package:wcenzije/widgets/map.dart';
import 'package:wcenzije/services/reviews_repo.dart';

import 'add_review/where.dart';
import 'login.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final repo = ReviewsRepository();

  final authService = AuthService();

  var _selectedScreen = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        color: Colors.blue,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  _selectedScreen == 0 ? Icons.home : Icons.home_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _selectedScreen = 0;
                  });
                },
              ),
              Padding(padding: EdgeInsets.all(1)),
              IconButton(
                icon: Icon(
                  _selectedScreen == 1 ? Icons.person : Icons.person_outline,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () async {
                  final isAuthorized = await authService.isAuthorized();
                  if (!isAuthorized) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(HomeScreen()),
                      ),
                    );
                    return;
                  }
                  setState(() {
                    _selectedScreen = 1;
                  });
                },
              ),
            ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final isAuthorized = await authService.isAuthorized();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => isAuthorized
                  ? AddReviewWhereScreen()
                  : LoginScreen(AddReviewWhereScreen()),
            ),
          );
        },
      ),
      body: FutureBuilder<bool>(
        future: isLocationEnabled(),
        builder: (context, snapshot) => snapshot.hasData
            ? snapshot.data!
                ? _selectedScreen == 0
                    ? map()
                    : ProfileScreen()
                : const PermissionScreen()
            : const CircularProgressIndicator(),
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
