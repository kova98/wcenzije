import 'package:flutter/material.dart';
import 'package:wcenzije/models/review.dart';
import 'package:wcenzije/widgets/carousel.dart';

class ReviewScreen extends StatelessWidget {
  final Review review;

  ReviewScreen(this.review);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(review.name),
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(top: 4),
            ),
            Center(
              child: Text(
                "${review.rating}/10",
                style: TextStyle(fontSize: 36),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
            ),
            Container(height: 400, child: Carousel(review.imageUrls)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(review.content),
            ),
          ],
        ));
  }
}
