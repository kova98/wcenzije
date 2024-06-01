import 'package:flutter/material.dart';
import 'package:wcenzije/helpers/date_helper.dart';
import 'package:wcenzije/helpers/gender_helper.dart';
import 'package:wcenzije/models/review.dart';
import 'package:wcenzije/screens/review.dart';
import 'package:wcenzije/services/reviews_repo.dart';

class ReviewsScreen extends StatelessWidget {
  final List<int> reviewIds;
  final repo = ReviewsRepository();

  ReviewsScreen(this.reviewIds, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Review>>(
      future: repo.getReviews(reviewIds),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(),
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ),
          );
        }
        var reviews = snapshot.data!;
        return Scaffold(
          appBar: AppBar(title: Text(reviews[0].name)),
          backgroundColor: Colors.blue,
          body: ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReviewScreen(reviews[index].id),
                ),
              ),
              child: Card(
                child: ListTile(
                  title: Text(reviews[index].author ?? "anonimni korisnik"),
                  subtitle: Text(shortDate(reviews[index].dateCreated)),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        reviews[index].gender.icon(),
                        color: Theme.of(context).primaryColorDark,
                        size: 32,
                      ),
                    ],
                  ),
                  trailing: Text("${reviews[index].rating}/10"),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
