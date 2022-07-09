import 'package:flutter/material.dart';
import 'package:wcenzije/models/review.dart';
import 'package:wcenzije/widgets/map.dart';
import 'package:wcenzije/services/reviews_repo.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final repo = ReviewsRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: FutureBuilder<List<Review>>(
        future: repo.getReviews(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Map(snapshot.data)
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
        },
      ),
    );
  }
}
