import 'package:flutter/material.dart';
import 'package:wcenzije/helpers/date_helper.dart';
import 'package:wcenzije/helpers/gender_helper.dart';
import 'package:wcenzije/models/review.dart';
import 'package:wcenzije/screens/review.dart';

class ReviewsScreen extends StatelessWidget {
  List<Review> reviews;
  // TODO: refactor to load reviews from the API

  ReviewsScreen(this.reviews, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    color: reviews[index].gender.color(),
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
  }
}
