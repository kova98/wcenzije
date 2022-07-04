import 'package:flutter/material.dart';
import 'package:wcenzije/models/review.dart';
import 'package:wcenzije/services/reviews_repo.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final repo = ReviewsRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wcenzije"),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Review>>(
          future: repo.getReviews(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {},
                        title: Text(snapshot.data![index].id.toString()),
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          }),
    );
  }
}
