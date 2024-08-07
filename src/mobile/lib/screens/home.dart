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
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final repo = ReviewsRepository();

  final authService = AuthService();

  var _selectedScreen = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isLocationEnabled(),
      builder: (context, snapshot) => snapshot.hasData
          ? snapshot.data! // location is enabled
              ? scaffold()
              : const PermissionScreen()
          : const CircularProgressIndicator(),
    );
  }

  FutureBuilder<MapData> map() {
    return FutureBuilder<MapData>(
      future: loadMapData(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Map(snapshot.data!.reviews, snapshot.data!.position)
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Future<bool> isLocationEnabled() async {
    final error = await getPermissionError();
    return error == null;
  }

  Future<MapData> loadMapData() async {
    final reviews = await repo.getReviewsForMap();
    final location = await determinePosition();

    return MapData(reviews, location);
  }

  bool isLocationPermissionGranted() => false;

  progressIndicator() => const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );

  scaffold() => Scaffold(
        extendBody: true,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
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
                const Padding(padding: EdgeInsets.all(1)),
                IconButton(
                  icon: Icon(
                    _selectedScreen == 1 ? Icons.person : Icons.person_outline,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () async {
                    final isAuthorized = await authService.isAuthorized();
                    if (!isAuthorized) {
                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const LoginScreen(HomeScreen()),
                          ),
                        );
                      }
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
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => isAuthorized
                      ? const AddReviewWhereScreen()
                      : const LoginScreen(AddReviewWhereScreen()),
                ),
              );
            }
          },
        ),
        body: _selectedScreen == 0 ? map() : ProfileScreen(),
      );
}

class MapData {
  final List<Review> reviews;
  final Position position;

  MapData(this.reviews, this.position);
}
