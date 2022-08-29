import 'package:flutter/material.dart';
import 'package:wcenzije/helpers/gender_helper.dart';
import 'package:wcenzije/models/review.dart';
import 'package:wcenzije/screens/review.dart';

class ReviewsScreen extends StatelessWidget {
  List<Review> reviews;

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
              builder: (context) => ReviewScreen(reviews[index]),
            ),
          ),
          child: Card(
            child: ListTile(
              title: Text(reviews[index].name),
              // subtitle: Text(DateTime.now().toString()), TODO: Add date
              leading: Icon(
                reviews[index].gender.icon(),
                color: reviews[index].gender.color(),
              ),
              trailing: Text("${reviews[index].rating}/10"),
            ),
          ),
        ),
      ),
    );
  }
}
